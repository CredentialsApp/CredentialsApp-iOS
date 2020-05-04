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
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var mrzKeyLabel: UILabel!
    @IBOutlet weak var documentNumberLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    // MARK: - properties
    var credential = [String:String]()
    var image = UIImage()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        passportImageView.image = image
        documentNumberLabel.text = credential["documentNumber"]
        firstNameLabel.text = credential["firstName"]
        lastNameLabel.text = credential["lastName"]
        mrzKeyLabel.text = credential["mrzKey"]
        dateOfBirthLabel.text = credential["birthDate"]
    }
    // MARK: - Function
    
    // MARK: - Actions
}
