//
//  BluetoothViewController.swift
//  TrustID
//
//  Created by Berk Turan on 12/27/19.
//  Copyright © 2019 GatePay. All rights reserved.
//

import UIKit

class BluetoothViewController: UIViewController {
    // MARK: - UI Elements
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // MARK: - properties
    var credential: [String]?
    var bluetoothService: BluetoothService?
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
        activityIndicator.startAnimating()
    }
    override func viewDidAppear(_ animated: Bool) {
        bluetoothService = BluetoothService(delegate: self)
        bluetoothService?.credentialData = credential?[0] ?? "NIL"
    }
    override func viewDidDisappear(_ animated: Bool) {
        bluetoothService?.peripheralManager?.stopAdvertising()
    }
    
    // MARK: - Function
    
    // MARK: - Actions
    
}

