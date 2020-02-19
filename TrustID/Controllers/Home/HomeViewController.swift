//
//  HomeViewController.swift
//  TrustID
//
//  Created by Berk Turan on 12/24/19.
//  Copyright © 2019 GatePay. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - UI Elements
    @IBOutlet weak var addCredentialBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - properties
    var credentials = [Credential]()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Function
    // MARK: - Actions
    @IBAction func credentialBarButtonItemTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "addCredentialSegue", sender: nil)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return credentials.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let credential = credentials[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CredentialTableViewCell") as? CredentialTableViewCell
        tableView.rowHeight = 70.0
        cell?.colorView.backgroundColor = credential.color
        cell?.titleLabel.text = credential.title
        cell?.titleDescription.text = credential.description
        return cell ?? CredentialTableViewCell()
    }
    
    
}


