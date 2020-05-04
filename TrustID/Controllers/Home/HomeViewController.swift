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
    var passportModel = NFCPassportModel()
    var selectedModel = 0
    var dictionary = [[String:String]]()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        let storageDate = UserDefaults.standard.object(forKey: "encodedDictionary")
        guard let encodedData = storageDate as? Data else {return}
        if encodedData != nil {
            let decodedDic = try? JSONDecoder().decode([[String:String]].self, from: encodedData as! Data)
            if decodedDic != nil {
                dictionary = decodedDic!
                for dictionary in decodedDic! {
                    let firstName = dictionary["firstName"]!
                    let lastName = dictionary["lastName"]!
                    let credential = Credential(title: firstName, description: lastName, color: .blue)
                    credentials.append(credential)
                }
            }
        }
    }
    // MARK: - Function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CredentialDetailsViewController {
            destination.image = dataProvider.retrieveImage(forKey: "passportImage", inStorageType: .userDefaults)!
            destination.credential = dictionary[selectedModel]
        }
    }
    // MARK: - Actions
    @IBAction func addCredentialButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Document Type", message: "Select document type to create a credential in TrustID.", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Passport", style: .default) { (action) in
            if action.isEnabled {
                self.navigationController?.navigationBar.isHidden = false
                self.performSegue(withIdentifier: "AddPassportSegue", sender: nil) }
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
        self.selectedModel = indexPath.row
        performSegue(withIdentifier: "CredentialDetailsSegue", sender: nil)
    }
}


