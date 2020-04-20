//
//  HomeViewController.swift
//  TrustID
//
//  Created by Berk Turan on 12/24/19.
//  Copyright © 2019 GatePay. All rights reserved.
//

import UIKit
import NFCPassportReader
class HomeViewController: UIViewController {
    // MARK: - UI Elements
    @IBOutlet weak var addCredentialButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - properties
    var credentials = [Credential]()
    let dataProvider = DataProvider()
    var selectedCred = Credential(title: "", description: "", color: .none)
    var passportModel = NFCPassportModel()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        let credential = UserDefaults.standard.object(forKey: "credential") as? Credential
        if credential != nil { credentials.append(credential!) }
    }
    // MARK: - Function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CredentialDetailsViewController {
            destination.credential = passportModel
        }
    }
    // MARK: - Actions
    @IBAction func addCredentialButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Document Type", message: "Select document type to create a credential in TrustID.", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Passport", style: .default) { (action) in
            if action.isEnabled { self.performSegue(withIdentifier: "AddPassportSegue", sender: nil) }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(action1)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CredentialDetailsSegue", sender: nil)
    }
}


