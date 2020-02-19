//
//  BluetoothServiceConfigration.swift
//  TrustID
//
//  Created by Berk Turan on 1/1/20.
//  Copyright © 2020 GatePay. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

// MARK: - CBPeripheralManagerDelegate
extension BluetoothService: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("peripheralManagerDidUpdateState")
        if peripheral.state == .poweredOn {
            guard let service: CBMutableService = self.service else { return }
            self.peripheralManager?.removeAllServices()
            self.peripheralManager?.add(service)
        }
    }
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        print("\ndidAdd service")
        let advertisingData: [String: Any] = [
            CBAdvertisementDataServiceUUIDsKey: [self.service?.uuid],
            CBAdvertisementDataLocalNameKey: UIDevice.current.name
        ]
        self.characterisctic?.value = credentialData.data(using: .utf8)
        self.peripheralManager?.stopAdvertising()
        self.peripheralManager?.startAdvertising(advertisingData)
    }

    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if peripheral.isAdvertising { self.bluetoothMessaging?.didStartAdvertising() } else { return }
    }

    // Listen to dynamic values
    // Called when CBPeripheral .setNotifyValue(true, for: characteristic) is called from the central
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("\ndidSubscribeTo characteristic")
        guard let characterisctic: CBMutableCharacteristic = self.characterisctic else { return }
        do {
            // Writing data to characteristics
            let data: Data = credentialData.data(using: .utf8)!
            self.peripheralManager?.updateValue(data, for: characterisctic, onSubscribedCentrals: [central])
            self.bluetoothMessaging?.didSendData()
        } catch let error {
            print(error)
        }
    }
    // Read static values
    // Called when CBPeripheral .readValue(for: characteristic) is called from the central
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("\ndidReceiveRead request")
        self.characterisctic?.value = credentialData.data(using: .utf8)
        if let uuid: CBUUID = self.characterisctic?.uuid, request.characteristic.uuid == uuid {
            if let data = characterisctic?.value {
                if let receivedData: String = try String(decoding: data, as: UTF8.self) {
                    print("DATA IS SENDED: \(receivedData)")
                }
            }
        }
    }

    // Called when receiving writing from Central.
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("\ndidReceiveWrite requests")
        guard
            let characteristicCBUUID: CBUUID = self.characteristicCBUUID,
            let request: CBATTRequest = requests.filter({ $0.characteristic.uuid == characteristicCBUUID }).first,
            let value: Data = request.value
            else { return }
        // Send response to central if this writing request asks for response [.withResponse]
        print("Sending response: Success")
        self.peripheralManager?.respond(to: request, withResult: .success)
        do {
            if let receivedData: String = try String(decoding: value, as: UTF8.self) {
                if receivedData == "AHMET" {
                    self.bluetoothMessaging?.didUseCaseEnded()
                }
                self.bluetoothMessaging?.didReceiveData()
                credentialData += receivedData
                self.peripheralManager?.updateValue(value, for: self.characterisctic!, onSubscribedCentrals: [request.central])
                self.peripheralManager?.respond(to: request, withResult: .success)
            } else {
                return
            }
        } catch let error {
            print(error)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("WORKED")
        self.bluetoothMessaging?.didUseCaseEnded()
    }
}

