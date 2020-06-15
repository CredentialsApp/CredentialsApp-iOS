//
//  NewViewController.swift
//  TrustID
//
//  Created by Burak Keceli on 30.05.20.
//  Copyright © 2020 GatePay. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = "Hello, new view controller"
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
    }
}
