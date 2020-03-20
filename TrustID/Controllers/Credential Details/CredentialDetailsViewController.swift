//
//  CredentialDetailsViewController.swift
//  TrustID
//
//  Created by Berk Turan on 3/20/20.
//  Copyright © 2020 GatePay. All rights reserved.
//

import UIKit
import NFCPassportReader
class CredentialDetailsViewController: UIViewController {
    // MARK: - UI Elements
    @IBOutlet weak var passportImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!
    @IBOutlet weak var mrzKeyLabel: UILabel!
    @IBOutlet weak var documentNumberLabel: UILabel!
    
    // MARK: - properties
    var credential = NFCPassportModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        passportImageView.image = credential.passportImage
        documentNumberLabel.text = credential.documentNumber
        firstNameLabel.text = credential.firstName
        lastNameLabel.text = credential.lastName
        mrzKeyLabel.text = credential.passportMRZ
    }
    // MARK: - Function
    
    // MARK: - Actions
}
