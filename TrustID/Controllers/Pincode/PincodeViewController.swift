//
//  PincodeViewController.swift
//  TrustID
//
//  Created by Berk Turan on 12/18/19.
//  Copyright © 2019 GatePay. All rights reserved.
//

import UIKit
import Sejima
class PincodeViewController: UIViewController {
    // MARK: - UI Elements
    @IBOutlet weak var pinCodeView: MUPinCode!
    @IBOutlet weak var nextButton: TrustButton!
    
    // MARK: - properties
    var user : User = User(firstName: "", lastName: "", birthDate: Date(), gender: .male, socialSecurityNumber: "", pincode: nil)
    var userDelegate: UserDelegate?
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pinCodeView.keyboardType = .numberPad
    }
    // MARK: - Function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: - Actions
    @IBAction func nextButtonTapped(_sender: UIButton) {
        if pinCodeView.code.count == 6 {
            user.setPincode(pincode: Int(pinCodeView.code)!)
            performSegue(withIdentifier: "goToHomeSegue", sender: nil)
        }else {
            present(AlertService().createAlert(type: .isPincodeFilled)!, animated: true, completion: nil)
        }
    }
}

