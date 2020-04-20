//
//  SceneDelegate.swift
//  TrustID
//
//  Created by Berk Turan on 12/18/19.
//  Copyright © 2019 GatePay. All rights reserved.
//

import UIKit
import CryptorECC
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        var parameters: [String: String] = [:]
        URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
            parameters[$0.name] = $0.value
        }
        guard let callbackUrl = parameters["callback_url"]?.description else { return }
        guard let p256PrivateKey = UserDefaults.standard.object(forKey: "p256PrivateKey") as? String else { return }
        guard let publicKey = UserDefaults.standard.object(forKey: "publicKeyPem") as? String else { return }
        guard let privateKey = try? ECPrivateKey(key: p256PrivateKey) else { return }
        guard let dg1Hash = UserDefaults.standard.object(forKey: "dg1Hash") as? String else { return }
        guard let hashSignature = try? parameters["signing_hash"]?.sign(with: privateKey).asn1.hashValue else { return }
        guard let dsSignature = try? dg1Hash.sign(with: privateKey).asn1.description else { return }
        
        let buildedCallback = "\(callbackUrl)?verification_result=success&verification_document=passport&verification_scope=existence&DG1_hash=\(String(describing: dg1Hash.description))&DG1_hashing_algorithm=sha-256&DS_signature=MHcCAQEEIEM6ZKxdPGWwu2KGpYVvUIQFH6dAan1i+u81JmLV8M5GoAoGCCqGSM49\nAwEHoUQDQgAEf3SkckYENwcf2lJEvkBMlQOYgwlz3IZMpQ3AaBY1GqJA30LOYG8w\nLWLerci2lPRkHMvyMD3q8Ro0BpOAS15fXg==&DS_signature_algorithm=ECC&random_hash_signature=\(hashSignature)&random_hash_signing_algoritm=ECC&user_public_key=MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE3zlk7kkgZIPr9RY6V5hdAAsRZtP8\ne5SVJj3y6o/8+FVjxtLHUYEVzd3CecBzz3+h2eZHx9cwXXAKo7lnGiYTTQ"
        let ac = UIAlertController(title: "Builded Callback", message: buildedCallback, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.window?.rootViewController?.present(ac, animated: true, completion: nil)
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

