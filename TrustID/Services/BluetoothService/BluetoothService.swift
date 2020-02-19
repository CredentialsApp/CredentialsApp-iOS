//
//  BluetoothManager.swift
//  BLE
//
//  Created by Leonardo Cardoso on 09/02/2017.
//  Copyright © 2017 leocardz.com. All rights reserved.
//

import CoreBluetooth
import UIKit

protocol BlueEar {
    func didStartConfiguration()
    func didStartAdvertising()
    func didSendData()
    func didReceiveData()
    func didUseCaseEnded()
}

class BluetoothService: NSObject {

    // MARK: - Properties
    let localName: String = UIDevice.current.name
    let properties: CBCharacteristicProperties = [.read, .notify, .writeWithoutResponse, .write]
    let permissions: CBAttributePermissions = [.readable, .writeable]
    var bluetoothMessaging: BlueEar?
    var peripheralManager: CBPeripheralManager?
    var serviceCBUUID =  CBUUID(string: "0x3131")
    var characteristicCBUUID = CBUUID(string: "0x9A12")
    var service: CBMutableService?
    var characterisctic: CBMutableCharacteristic?
    var credentialData = "Credential Data: "
    // MARK: - Initializers
    convenience init (delegate: BlueEar?) {
        self.init()
        self.bluetoothMessaging = delegate
        // Configuring service
        self.service = CBMutableService(type: serviceCBUUID, primary: true)
        // Configuring characteristic
        self.characterisctic = CBMutableCharacteristic(type: characteristicCBUUID, properties: self.properties, value: nil, permissions: self.permissions)
        guard let characterisctic: CBCharacteristic = self.characterisctic else { return }
        // Add characterisct to service
        self.service?.characteristics = [characterisctic]
        self.bluetoothMessaging?.didStartConfiguration()
        // Initiate peripheral and start advertising
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
}
