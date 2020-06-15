//
//  AlertService.swift
//  TrustID
//
//  Created by Berk Turan on 12/24/19.
//  Copyright © 2019 GatePay. All rights reserved.
//

import Foundation
import UIKit
struct AlertService {
    func createAlert(type: AlertType) -> UIAlertController? {
        let action = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        switch type {
        case .fillAllFields:
            let alertController = UIAlertController(title: "There are Empty Fields.", message: "You Should Fill All Fields to Continue.", preferredStyle: .alert)
            alertController.addAction(action)
            return alertController
        case .isPincodeFilled:
            let alertController = UIAlertController(title: "You Have to Fill Whole Pincode.", message: "", preferredStyle: .alert)
            alertController.addAction(action)
            return alertController
    }
}
}

enum AlertType {
    case fillAllFields
    case isPincodeFilled
}

