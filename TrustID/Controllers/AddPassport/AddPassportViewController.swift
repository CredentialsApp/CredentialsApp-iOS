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
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nfcScannerButton.isEnabled = false
        facialAuthenticationButton.isEnabled = false
        passportReader = PassportReader()
    }
    // MARK: - Function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MRZScannerViewController {
            destination.mrzDelegate = self
        } else if let destination = segue.destination as? HomeViewController {
            destination.credentials.append(self.credential)
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
