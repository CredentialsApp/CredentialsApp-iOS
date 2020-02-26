//
//  MRZScannerViewController.swift
//  TrustID
//
//  Created by Berk Turan on 1/27/20.
//  Copyright © 2020 GatePay. All rights reserved.
//

import UIKit
import QKMRZScanner
import NFCPassportReader

class MRZScannerViewController: UIViewController, QKMRZScannerViewDelegate {
    
    // MARK: - UI Elements
    @IBOutlet weak var mrzScannerView: QKMRZScannerView!
    
    // MARK: - properties
    private var passportReader: PassportReader!
    private var passportDetails = PassportDetails()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mrzScannerView.delegate = self
        passportReader = PassportReader()
        mrzScannerView.startScanning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mrzScannerView.stopScanning()
    }
    // MARK: - Function
    func mrzScannerView(_ mrzScannerView: QKMRZScannerView, didFind scanResult: QKMRZScanResult) {
        
        fillPassportDetails(with: scanResult)
        let mrzKey = passportDetails.getMRZKey()
        print(mrzKey)
        passportReader.readPassport(mrzKey: mrzKey) { (model, error) in
            if error != nil { debugPrint(error) }
            debugPrint(model?.firstName)
        }
    }
    func fillPassportDetails(with information: QKMRZScanResult) {
        passportDetails.expiryDate = getDateParts(date: information.expiryDate!)
        passportDetails.passportNumber = information.documentNumber
        passportDetails.dateOfBirth = getDateParts(date: information.birthDate!)
    }
    func getDateParts(date: Date) -> String {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: date)
        var dayString = String(components.day!)
        if dayString.count == 1 {
            dayString = "0" + dayString
        }
        var monthString = String(components.month!)
        if monthString.count == 1 {
            monthString = "0" + monthString
        }
        let yearString = String(components.year!)
        let suffixed = yearString.suffix(2)
        print(suffixed.description + monthString + dayString)
        return suffixed.description + monthString + dayString
    }
    // MARK: - Actions

}

