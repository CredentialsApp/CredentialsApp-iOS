//
//  MRZScannerViewController.swift
//  TrustID
//
//  Created by Berk Turan on 1/27/20.
//  Copyright © 2020 GatePay. All rights reserved.
//

import UIKit
import QKMRZScanner
import CoreNFC

class MRZScannerViewController: UIViewController, NFCTagReaderSessionDelegate, NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print(messages)
    }
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        let tag = tags.first!
        let ndefReader = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        if case let .iso7816(iso7816tag) = tag {
            session.connect(to: tag) { (error) in
                ndefReader.connect(to: iso7816tag) { (error) in
                    if error != nil { print("ERROR 1: " + error!.localizedDescription) }
                    iso7816tag.readNDEF { (message, error) in
                        if error != nil { print("ERROR 2:" + error!.localizedDescription) }
                        print("Message: " + message.debugDescription)
                    }
                }
            }
        }
    }
    
    
    // MARK: - UI Elements
    @IBOutlet weak var mrzScannerView: QKMRZScannerView!
    // MARK: - properties
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mrzScannerView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mrzScannerView.startScanning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mrzScannerView.stopScanning()
    }
    // MARK: - Function
    
    // MARK: - Actions

}

extension MRZScannerViewController: QKMRZScannerViewDelegate {
    func mrzScannerView(_ mrzScannerView: QKMRZScannerView, didFind scanResult: QKMRZScanResult) {
        let nfcService = NFCService(scanResult: scanResult)
        let tagReaderSession = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        print(scanResult.documentType)
    }
    
}
