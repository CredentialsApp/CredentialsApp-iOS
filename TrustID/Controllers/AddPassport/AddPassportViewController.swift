//
//  AddPassportViewController.swift
//  TrustID
//
//  Created by Berk Turan on 3/18/20.
//  Copyright © 2020 GatePay. All rights reserved.
//

import UIKit
import NFCPassportReader
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
    // MARK: - Actions
    @IBAction func scanPassportButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ScannerViewSegue", sender: nil)
    }
    @IBAction func nfcScannerButtonTapped(_ sender: UIButton) {
        passportReader.readPassport(mrzKey: self.mrzKey) { (model, error) in
            if error == nil {
                self.credential = Credential(title: "Passport", description: model!.nationality, color: .blue)
                self.model = model!
                DispatchQueue.main.async {
                    self.nfcScannerButton.setBackgroundImage(UIImage(named: "button_2_done"), for: .disabled)
                    self.performSegue(withIdentifier: "HomeViewSegue", sender: nil)
                }
            }
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
