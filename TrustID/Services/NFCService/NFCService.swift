//
//  NFCService.swift
//  TrustID
//
//  Created by Berk Turan on 1/23/20.
//  Copyright © 2020 GatePay. All rights reserved.
//

import Foundation
import QKMRZScanner
import NFCPassportReader
import CoreNFC
class NFCService: NSObject {
    // MARK: - properties
    private var reader: PassportReader!
    private var scanResult: QKMRZScanResult!
    private var passportDetails = PassportDetails()
    private var tagReader: NFCTagReaderSession!
    private var ndefReader: NFCNDEFReaderSession!
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
        fillPassportDetails(with: scanResult)
        let mrzKey = passportDetails.getMRZKey()
        
    }
    
    func fillPassportDetails(with information: QKMRZScanResult) {
        passportDetails.expiryDate = getDateParts(date: information.expiryDate!)
        passportDetails.passportNumber = information.documentNumber.replacingOccurrences(of: "U", with: "")
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
        return suffixed.description + monthString + dayString
    }
    
}

