//
//  UserService.swift
//  TrustID
//
//  Created by Berk Turan on 12/18/19.
//  Copyright © 2019 GatePay. All rights reserved.
//

import Foundation

class UserService {
    // MARK: - Properties
    var user: User
    // MARK: - Initializers
    init(user: User) {
        self.user = user
    }
    // MARK: - Function
    func getBirthDateParts() -> [Int] {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: user.birthDate)
        return [components.day!, components.month!, components.year!]
    }
}
