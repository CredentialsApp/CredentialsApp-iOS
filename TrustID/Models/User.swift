//
//  User.swift
//  TrustID
//
//  Created by Berk Turan on 12/18/19.
//  Copyright © 2019 GatePay. All rights reserved.
//

import Foundation

struct User {
    let firstName: String
    let lastName: String
    let birthDate: Date
    let gender: Gender
    let socialSecurityNumber: String
    var pincode: Int?
    
    mutating func setPincode(pincode : Int) {
        self.pincode = pincode
    }
}

enum Gender: String, CaseIterable {
    case male = "Male"
    case female = "Female"
}
