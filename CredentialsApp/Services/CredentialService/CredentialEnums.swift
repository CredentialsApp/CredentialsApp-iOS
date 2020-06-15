//
//  CredentialEnums.swift
//  TrustID
//
//  Created by Berk Turan on 1/1/20.
//  Copyright © 2020 GatePay. All rights reserved.
//

import Foundation

enum CredentialCategory: String {
    case identity = "01"
    case medical =  "02"
    case degree = "03"
    case employment = "04"
    case achievements = "05"
}

enum SubcredentialCategory: String {
    case citizenship = "01"
    case passport = "02"
    case drivingLicence = "03"
    case residence = "04"
    case language = "05"
    case std = " 01"
    case diagnosis = " 02"
    case vaccine = " 03"
    case degree = "01 "
    case employment = " 02 "
    case achievement = "03 "
    case certificate = " 04"
    case doorUnlock = "01  "
    case smartMeter = "02  "
    case smartDrivingTracker = "03  "
}

enum STDIdentifierHash: String, CaseIterable {
    case chlamydia = "01"
    case chancroid = "02"
    case pubicLice = "03"
    case hsv1 = "04"
    case hsv2 = "05"
    case hepatitisB = "06"
    case trichomoniasis = "07"
    case hiv = "08"
    case hpv = "09"
    case mcv1 = "0A"
    case mcv2 = "0B"
    case mcv3 = "0C"
    case mcv4 = "0D"
    case scabies = "0E"
    case gonorrhea = "0F"
}
