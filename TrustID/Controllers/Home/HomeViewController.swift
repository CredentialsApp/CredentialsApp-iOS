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
    @IBOutlet weak var addCredentialButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: TrustImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    // MARK: - properties
    var credentials = [Credential]()
    let dataProvider = DataProvider()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let profileImage = self.dataProvider.retrieveImage(forKey: "trustProfileImage", inStorageType: .userDefaults)
        profileImageView.image = profileImage
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

    }
    // MARK: - Function
    
    // MARK: - Actions
    @IBAction func addCredentialButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Credential Type", message: "", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Passport", style: .default, handler: nil)
        let action2 = UIAlertAction(title: "Identity Card", style: .default, handler: nil)
        let action3 = UIAlertAction(title: "Driver Licence", style: .default, handler: nil)
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
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
    
    
}


