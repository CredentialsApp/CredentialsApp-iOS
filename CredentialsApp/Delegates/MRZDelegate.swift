//
//  MRZDelegate.swift
//  TrustID
//
//  Created by Berk Turan on 3/20/20.
//  Copyright © 2020 GatePay. All rights reserved.
//

import Foundation

protocol MRZDelegate {
    func passKey(with mrzKey: String)
}
