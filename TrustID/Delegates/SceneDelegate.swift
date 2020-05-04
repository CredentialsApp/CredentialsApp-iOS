//
//  SceneDelegate.swift
//  TrustID
//
//  Created by Berk Turan on 12/18/19.
//  Copyright © 2019 GatePay. All rights reserved.
//

import UIKit
import CryptorECC
import Firebase
import FirebaseDynamicLinks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let walkthroughPageCheck = UserDefaults.standard.object(forKey: "isShowed") else { return }
        if walkthroughPageCheck as! Bool {
            if let incomingURL = userActivity.webpageURL {
                _ = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                    guard error == nil else { return }
                    if let dynamicLink = dynamicLink {
                    //your code for handling the dynamic link goes here
                        let urlString = dynamicLink.url?.absoluteString
                        let parsedHash = urlString?.replacingOccurrences(of: "https://trust-id.co/resolve/", with: "")
                        let hexData = Data(fromHexEncodedString: parsedHash!)!
                        let hexString = String(data: hexData, encoding: .isoLatin1)
                        let wholeUrl = "https://trust-id.co/resolve/" + hexString!
                        guard let url = URL(string: wholeUrl) else { return }
                        var parameters: [String: String] = [:]
                        URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
                            parameters[$0.name] = $0.value
                        }
                        var scopeString = parameters["scope"]
                        var scopeElements = [String]()
                        scopeString = scopeString?.trimmingCharacters(in: .whitespacesAndNewlines)
                        var check = ""
                        var index = 0
                        var messageString = ""
                        for character in scopeString! {
                            index += 1
                            if character != "," && index != scopeString!.count + 2  {
                                check += character.description
                            }else {
                                scopeElements.append(check)
                                messageString += check + "\n"
                                check = ""
                            }
                        }
                        messageString += check + "\n"
                        scopeElements.append(check)
                        let ac = UIAlertController(title: "bitHolla Wants to access your", message: NSAttributedStringHelper.createBulletedList(strings: scopeElements, font: .systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 700))).string, preferredStyle: .actionSheet)
                        let cacheCheck = UserDefaults.standard.object(forKey: "isPassportAdded") as? Bool
                        if cacheCheck != nil && cacheCheck == true {
                            guard let callbackUrl = parameters["callback_url"]?.description else { return }
                            guard let p256PrivateKey = UserDefaults.standard.object(forKey: "p256PrivateKey") as? String else { return }
                            guard let privateKey = try? ECPrivateKey(key: p256PrivateKey) else { return }
                            guard let dg1Hash = UserDefaults.standard.object(forKey: "dg1Hash") as? String else { return }
                            guard let hashSignature = try? parameters["signing_hash"]?.sign(with: privateKey).asn1.hashValue else { return }
                            let decodedDictionary = try! JSONDecoder().decode([[String:String]].self, from: UserDefaults.standard.object(forKey: "encodedDictionary") as! Data)
                            let buildedCallback = "\(callbackUrl)resolve?verification_result=success&verification_document=passport&document_issuing_state=\(decodedDictionary[0]["issueState"]!)&scope_query_parameters=\(scopeString!)&scope_result_parameters=\(decodedDictionary[0]["firstName"]! + decodedDictionary[0]["lastName"]!),\(decodedDictionary[0]["issueState"]!),\(decodedDictionary[0]["gender"]!),\(decodedDictionary[0]["documentNumber"]!)&DG1_hash=\(String(describing: dg1Hash.description))&DG1_hashing_algorithm=sha-256&DS_signature=MHcCAQEEIEM6ZKxdPGWwu2KGpYVvUIQFH6dAan1i+u81JmLV8M5GoAoGCCqGSM49AwEHoUQDQgAEf3SkckYENwcf2lJEvkBMlQOYgwlz3IZMpQ3AaBY1GqJA30LOYG8wLWLerci2lPRkHMvyMD3q8Ro0BpOAS15fXg==&DS_signature_algorithm=ECC&random_hash_signature=\(hashSignature)&random_hash_signing_algoritm=ECC&user_public_key=MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE3zlk7kkgZIPr9RY6V5hdAAsRZtP8e5SVJj3y6o8+FVjxtLHUYEVzd3CecBzz3+h2eZHx9cwXXAKo7lnGiYTTQ"
                            let trimmed = buildedCallback.trimmingCharacters(in: .whitespacesAndNewlines)
                            let alertAction = UIAlertAction(title: "Authorize", style: .default) { (action) in
                                if action.isEnabled {
                                    guard let foo = URL(string: trimmed.replacingOccurrences(of: "\n", with: "")) else { return }
                                    debugPrint("foo")
                                    UIApplication.shared.openURL(foo)
                                }
                            }
                            ac.addAction(alertAction)
                            self.resetRoot()
                            self.window?.rootViewController?.present(ac, animated: true, completion: nil)
                        }else {
                            let acc = UIAlertController(title: "Error", message: "You have not added any documents yet", preferredStyle: .alert)
                            let aa = UIAlertAction(title: "Ok", style: .default, handler: nil)
                            acc.addAction(aa)
                            self.resetRoot()
                            self.window?.rootViewController?.present(acc, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    func convertHexStringToString(hexString:String)->String!{
      if let data = hexString.data(using: .utf8){
          return String.init(data:data, encoding: .utf8)
      }else{ return nil}
    }
    
    func resetRoot() {
           guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
               return
           }
           let navigationController = UINavigationController(rootViewController: rootVC)

           UIApplication.shared.windows.first?.rootViewController = navigationController
           UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension Data {

    // From http://stackoverflow.com/a/40278391:
    init?(fromHexEncodedString string: String) {

        // Convert 0 ... 9, a ... f, A ...F to their decimal value,
        // return nil for all other input characters
        func decodeNibble(u: UInt16) -> UInt8? {
            switch(u) {
            case 0x30 ... 0x39:
                return UInt8(u - 0x30)
            case 0x41 ... 0x46:
                return UInt8(u - 0x41 + 10)
            case 0x61 ... 0x66:
                return UInt8(u - 0x61 + 10)
            default:
                return nil
            }
        }

        self.init(capacity: string.utf16.count/2)
        var even = true
        var byte: UInt8 = 0
        for c in string.utf16 {
            guard let val = decodeNibble(u: c) else { return nil }
            if even {
                byte = val << 4
            } else {
                byte += val
                self.append(byte)
            }
            even = !even
        }
        guard even else { return nil }
    }
}

class NSAttributedStringHelper {
    static func createBulletedList(strings: [String], font: UIFont? = nil) -> NSAttributedString {

        let fullAttributedString = NSMutableAttributedString()
        let attributesDictionary: [NSAttributedString.Key: Any]

        if font != nil {
            attributesDictionary = [NSAttributedString.Key.font: font!]
        } else {
            attributesDictionary = [NSAttributedString.Key: Any]()
        }

        for index in 0..<strings.count {
            let bulletPoint: String = "\u{2022}"
            var formattedString: String = "\(bulletPoint) \(strings[index])"

            if index < strings.count - 1 {
                formattedString = "\(formattedString)\n"
            }

            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString, attributes: attributesDictionary)
            let paragraphStyle = NSAttributedStringHelper.createParagraphAttribute()
   attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
        fullAttributedString.append(attributedString)
       }

        return fullAttributedString
    }

    private static func createParagraphAttribute() -> NSParagraphStyle {
        let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: NSDictionary() as! [NSTextTab.OptionKey : Any])]
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 11
        return paragraphStyle
    }
}
