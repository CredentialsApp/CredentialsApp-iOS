//
//  AddPassportViewController.swift
//  TrustID
//
//  Created by Berk Turan on 3/18/20.
//  Copyright © 2020 GatePay. All rights reserved.
//

import UIKit
import NFCPassportReader
import LocalAuthentication
import CryptoKit
class AddPassportViewController: UIViewController {
    // MARK: - UI Elements
    @IBOutlet weak var scanPassportButton: UIButton!
    @IBOutlet weak var nfcScannerButton: UIButton!
    @IBOutlet weak var facialAuthenticationButton: UIButton!
    
    // MARK: - properties
    var mrzKey = ""
    private var passportReader: PassportReader!
    private var passportDetails = PassportDetails()
    var credential = Credential(title: "", description: "", color: .none)
    var model = NFCPassportModel()
    let dataProvider = DataProvider()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nfcScannerButton.isEnabled = false
        facialAuthenticationButton.isEnabled = false
        passportReader = PassportReader()
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    // MARK: - Function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MRZScannerViewController {
            destination.mrzDelegate = self
        }
        if let destination = segue.destination as? HomeViewController {
            destination.passportModel = model
        }
    }
    func bytesConvertToHexstring(byte : [UInt8]) -> String {
        var string = ""
        for val in byte {
            //getBytes(&byte, range: NSMakeRange(i, 1))
            string = string + String(format: "%02X", val)
        }
        return string
    }
    // MARK: - Actions
    @IBAction func scanPassportButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ScannerViewSegue", sender: nil)
    }
    @IBAction func nfcScannerButtonTapped(_ sender: UIButton) {
        passportReader.readPassport(mrzKey: self.mrzKey) { (model, error) in
            if error == nil {
                self.credential = Credential(title: "Passport", description: model!.nationality, color: .blue)
                self.model = model!
                let dg1Hash = self.bytesConvertToHexstring(byte: (model?.getHashesForDatagroups(hashAlgorythm: "SHA256")[DataGroupId.DG1])!)
                UserDefaults.standard.set(dg1Hash, forKey: "dg1Hash")
                self.dataProvider.store(image: (model?.passportImage)!, forKey: "passportImage", withStorageType: .userDefaults)
                var passportModelDictionary = [String: String]()
                passportModelDictionary["firstName"] = model?.firstName
                passportModelDictionary["lastName"] = model?.lastName
                passportModelDictionary["birthDate"] = model?.dateOfBirth
                passportModelDictionary["documentNumber"] = model?.documentNumber
                passportModelDictionary["mrzKey"] = model?.passportMRZ
                passportModelDictionary["issueState"] = model?.nationality
                passportModelDictionary["gender"] = model?.gender
                let encoder = JSONEncoder()
                var newDictionary: [[String:String]] = []
                newDictionary.append(passportModelDictionary)
                let encodedDictionary = try! JSONEncoder().encode(newDictionary)
                UserDefaults.standard.set(encodedDictionary, forKey: "encodedDictionary")
                guard let storageDate = UserDefaults.standard.object(forKey: "encodedDictionary") else { return }
                guard let encodedData = storageDate as? Data else {return}
                if encodedData != nil {
                    var decodedDictionary = try! JSONDecoder().decode([[String:String]].self, from: storageDate as! Data)
                    if decodedDictionary.contains(passportModelDictionary) == false {
                        decodedDictionary.append(passportModelDictionary)
                        let encodedPassportModelDic = try! encoder.encode(decodedDictionary)
                        UserDefaults.standard.set(encodedPassportModelDic, forKey: "encodedDictionary")
                    }
                }
                DispatchQueue.main.async {
                    self.nfcScannerButton.isEnabled = false
                    self.nfcScannerButton.setBackgroundImage(#imageLiteral(resourceName: "button2_done"), for: .disabled)
                    self.facialAuthenticationButton.isEnabled = true
                }
            }
        }
    }
    @IBAction func facialAuthButtonTapped (_sender: UIButton) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        UserDefaults.standard.set(true, forKey: "isPassportAdded")
                        self!.facialAuthenticationButton.setBackgroundImage(UIImage(named: "button_3_done"), for: .disabled)
                        self!.performSegue(withIdentifier: "HomeViewSegue", sender: nil)
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self!.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
}

extension AddPassportViewController: MRZDelegate {
    func passKey(with mrzKey: String) {
        self.mrzKey = mrzKey
        scanPassportButton.setBackgroundImage(UIImage(named: "button_1_done"), for: .disabled)
        scanPassportButton.isEnabled = false
        nfcScannerButton.isEnabled = true
    }
}
