//
//  BluetoothViewControllerConfigration.swift
//  TrustID
//
//  Created by Berk Turan on 1/1/20.
//  Copyright © 2020 GatePay. All rights reserved.
//

import Foundation
import UIKit

extension BluetoothViewController: BlueEar {
    func didStartConfiguration() { print("Start configuration 🎛") }
    func didStartAdvertising() { print("Start advertising 📻") }
    func didSendData() { print("Did send data ⬆️") }
    func didReceiveData() { print("Did received data ⬇️") }
    func didUseCaseEnded() {
        self.activityIndicator.stopAnimating()
        self.dismiss(animated: true, completion: nil)
    }
}
