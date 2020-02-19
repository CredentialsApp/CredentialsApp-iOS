//
//  NFCService.swift
//  TrustID
//
//  Created by Berk Turan on 1/23/20.
//  Copyright © 2020 GatePay. All rights reserved.
//

import Foundation
import NFCPassportReader
import QKMRZScanner
class NFCService: NSObject {
    
    // MARK: - properties
    private var reader: PassportReader!
    private var scanResult: QKMRZScanResult!
    
    // MARK: - Life Cycle
    override init() {
        super.init()
        self.reader = PassportReader()
    }
    
    convenience init(scanResult: QKMRZScanResult) {
        self.init()
        self.reader = PassportReader()
        self.scanResult = scanResult
    }
    
    // MARK: - Function
    func read() {
        let mrzKey = fillPassportDetails(with: scanResult)
        reader.readPassport(mrzKey: mrzKey, tags: [.COM, .DG1, .DG2], skipSecureElements: true) { (model, error) in
            print(model)
        }
    }
    
    func fillPassportDetails(with information: QKMRZScanResult) -> String {
        let passportDetails = PassportDetails()
        passportDetails.expiryDate = "230708"
        passportDetails.passportNumber = scanResult.documentNumber.replacingOccurrences(of: "U", with: "")
        passportDetails.dateOfBirth = "980708"
        let mrzKey = passportDetails.getMRZKey()
        debugPrint(mrzKey)
        return mrzKey
    }
    
}



