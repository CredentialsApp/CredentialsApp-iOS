//
//  CredentialsViewController.swift
//  TrustID
//
//  Created by Berk Turan on 12/24/19.
//  Copyright © 2019 GatePay. All rights reserved.
//

import UIKit

class CredentialsViewController: UIViewController {
    // MARK: - UI Elements
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    // MARK: - properties
    var selectedIdentifiers = [String]()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.lightGray
    }
    // MARK: - Function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? BluetoothViewController else { return }
        viewController.credential = selectedIdentifiers
    }
    // MARK: - Actions
    @IBAction func doneBarButtonItemTapped(_sender: UIBarButtonItem) {
        for cell in tableView.visibleCells {
            guard let identifierCell = cell as? IdentifierTableViewCell else { return }
            if identifierCell.radioButton.selected == true {
                selectedIdentifiers.append(identifierCell.identifierLabel.text!)
            }
        }
        performSegue(withIdentifier: "goToBluetoothSegue", sender: nil)
    }
}

extension CredentialsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return STDIdentifier.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdentifierTableViewCell") as? IdentifierTableViewCell
        cell?.identifierLabel.text = STDIdentifier.allCases[indexPath.row].rawValue
        return cell ?? IdentifierTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? IdentifierTableViewCell else { return }
        switch cell.radioButton.selected {
        case true:
            cell.radioButton.selected = false
        default:
            cell.radioButton.selected = true
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
