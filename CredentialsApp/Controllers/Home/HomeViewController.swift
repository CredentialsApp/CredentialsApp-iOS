//
//  HomeViewController.swift
//  TrustID
//
//  Created by Berk Turan on 12/24/19.
//  Copyright © 2019 GatePay. All rights reserved.
//

import UIKit
import NFCPassportReader
import AudioToolbox


extension UIView {

func animateButtonDown() {

    UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .curveEaseIn], animations: {
        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
    }, completion: nil)
    
    UIView.animate(withDuration: 0.1, delay: 0.1, options: [.allowUserInteraction, .curveEaseOut], animations: {
        self.transform = CGAffineTransform.identity
    }, completion: nil)
    
}
    
}


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
    
    @IBAction func animateButton(sender: UITableViewCell) {

        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

        UIView.animate(withDuration: 2.0,
                                   delay: 0,
                                   usingSpringWithDamping: CGFloat(0.20),
                                   initialSpringVelocity: CGFloat(6.0),
                                   options: UIView.AnimationOptions.allowUserInteraction,
                                   animations: {
                                    sender.transform = CGAffineTransform.identity
            },
                                   completion: { Void in()  }
        )
    
    }
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let defaults = UserDefaults.standard

        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            
            defaults.set(0, forKey: "credentialsCount")
            print("App launched first time")
        }
        
        /*
        guard let storageCredentialsCount = UserDefaults.standard.object(forKey: "credentialsCount") else {return}
        

        print("storageCredentialsCount")
        print(storageCredentialsCount)
        
        
        
        guard let encodedDictionary1 = UserDefaults.standard.object(forKey: "encodedDictionary1") else {return}
        print("encodedDictionary1")
        print(encodedDictionary1)
        
        guard let encodedDictionary2 = UserDefaults.standard.object(forKey: "encodedDictionary2") else {return}
        print("encodedDictionary2")
        print(encodedDictionary2)
        guard let encodedDictionary3 = UserDefaults.standard.object(forKey: "encodedDictionary3") else {return}
        print("encodedDictionary3")
        print(encodedDictionary3)
        guard let encodedDictionary4 = UserDefaults.standard.object(forKey: "encodedDictionary4") else {return}
        print("encodedDictionary4")
        print(encodedDictionary4)
        guard let encodedDictionary5 = UserDefaults.standard.object(forKey: "encodedDictionary5") else {return}
       
        
        
        
        
        
        
        
        
        
        print("encodedDictionary5")
        print(encodedDictionary5)
        
         */
        
        self.tableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.navigationController?.navigationBar.backgroundColor = .clear

        

        
        
        
        if self.traitCollection.userInterfaceStyle == .dark {
            self.tableView.backgroundColor = UIColor(red: 0.01, green: 0.01, blue: 0.01, alpha: 1.00)
            self.view.backgroundColor = UIColor(red: 0.01, green: 0.01, blue: 0.01, alpha: 1.00)
        } else {
            self.tableView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.00)
            self.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.00)
        }
        
        tableView?.reloadData()

        
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard UIApplication.shared.applicationState == .inactive else {
            return
        }

        viewDidLoad()
    }
     
     
     override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
         debugPrint("mk")
         viewDidLoad()
     }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
        
            var totalCredentialsCount:Int = 0
        
            guard let storageCredentialsCount = UserDefaults.standard.object(forKey: "credentialsCount") else {return}
            
            
            debugPrint("sorun2")
            
            guard let storageCredentialsCount_ = storageCredentialsCount as? Int else {return}
            
            debugPrint("sorun3")
            
            if storageCredentialsCount_ != nil {
                debugPrint("sorun4")
                totalCredentialsCount = storageCredentialsCount_
            }
        
        

        for i in 0...totalCredentialsCount {
            
            if i != totalCredentialsCount {
            
                var storageDate_forKey = "credentialDictionary" + String(i + 1)
                
        let storageDate = UserDefaults.standard.object(forKey: storageDate_forKey)
        guard let encodedData = storageDate as? Data else {return}
        if encodedData != nil {
            let decodedDic = try? JSONDecoder().decode([[String:String]].self, from: encodedData as! Data)
            if decodedDic != nil {
                dictionary = decodedDic!
                for dictionary in decodedDic! {
                    
                    let documentType_MRZ = dictionary["documentType"]!
                    var documentType = ""
                    
                    if documentType_MRZ == "P"{
                        documentType = "Passport"
                    }
                    else if documentType_MRZ == "I"{
                        documentType = "ID Card"
                    }
                    else if documentType_MRZ == "V"{
                        documentType = "Visa Card"
                    }
                    else{
                        documentType = ""
                    }
                    
                    var documentAuth = dictionary["issuingAuthority"]!
                    
                    //var documentAuth = "San Francisco AIDS Foundation"
                    
                    if documentAuth.count >= 60 {
                        documentAuth = documentAuth.prefix(60) + ".."
                    }
                    
         
                    let credential = Credential(title: documentType, description: documentAuth, color: .clear)
                    credentials.append(credential)
                }
            }
        }
    }
    }
        

    }
    // MARK: - Function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CredentialDetailsViewController {
           
            destination.image = dataProvider.retrieveImage(forKey: String("credentialImage" + String(selectedModel + 1)), inStorageType: .userDefaults)!
           // destination.credential = dictionary[selectedModel]
            print("selectedmodelis ")
            print(selectedModel)
            
            
            
            let storageDate = UserDefaults.standard.object(forKey: String("credentialDictionary" + String(selectedModel + 1)))
                    guard let encodedData = storageDate as? Data else {return}
                    if encodedData != nil {
                        let decodedDic = try? JSONDecoder().decode([[String:String]].self, from: encodedData as! Data)
                        if decodedDic != nil {
                            destination.credential = decodedDic![0]
}}
      
        }
    }
    // MARK: - Actions
    @IBAction func addCredentialButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Document Type", message: "Select document type to add", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Passport", style: .default) { (action) in
            if action.isEnabled {
                UserDefaults.standard.set("Passport", forKey: "currenteMRTDtypeToAdd")
                self.navigationController?.navigationBar.isHidden = false
                self.performSegue(withIdentifier: "AddPassportSegue", sender: nil) }
        }
        /*
        let action2 = UIAlertAction(title: "ID Card", style: .default) { (action) in
            if action.isEnabled {
                UserDefaults.standard.set("ID Card", forKey: "currenteMRTDtypeToAdd")
                self.navigationController?.navigationBar.isHidden = false
                self.performSegue(withIdentifier: "AddPassportSegue", sender: nil) }
        }
        */
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(action1)
        //alertController.addAction(action2)
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
        tableView.rowHeight = 129
        
        let fixedWidth = cell?.titleDescription.frame.size.width
        cell?.titleDescription.sizeThatFits(CGSize(width: fixedWidth!, height: CGFloat.greatestFiniteMagnitude))

        
        cell?.colorView.backgroundColor = credential.color
        cell?.titleLabel.text = credential.title
        cell?.titleDescription.text = credential.description
        
        
        let newSize = cell?.titleDescription.sizeThatFits(CGSize(width: fixedWidth!, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = cell?.titleDescription.frame
        newFrame!.size = CGSize(width: max(newSize!.width, fixedWidth!), height: newSize!.height)
        cell?.titleDescription.frame = newFrame!
    
        
        cell?.view.layer.cornerRadius = 9.0
        cell?.view.frame.size.height = tableView.rowHeight * 80 / 100
        cell?.view.frame.size.width = UIScreen.main.bounds.size.width * 92 / 100
        cell?.view.frame.origin.y = tableView.rowHeight / 2 - (cell?.view.frame.size.height)! / 2
        cell?.view.frame.origin.x = UIScreen.main.bounds.size.width / 2 - (cell?.view.frame.size.width)! / 2
        
        if self.traitCollection.userInterfaceStyle == .dark {
            cell?.view.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1.00)
        }
        else {
            cell?.view.backgroundColor = .white
        }
        
        
        cell?.flag.layer.cornerRadius = 7.0
        cell?.flag.frame.size.height = (cell?.view.frame.size.height)! / 100 * 70
        cell?.flag.frame.size.width = (cell?.flag.frame.size.height)!
        cell?.flag.frame.origin.y = (cell?.view.frame.size.height)! / 2 - (cell?.flag.frame.size.height)! / 2
        cell?.flag.frame.origin.x = (cell?.view.frame.size.width)! - (cell?.flag.frame.size.width)! * 100 / 80
        

        cell?.flag.image = UIImage(named: credential.description)

        
        
        let labelGapBetween = -(cell?.view.frame.size.height)! / 30
        
        let labelTotalHeight = (cell?.titleLabel.frame.size.height)! + (cell?.titleDescription.frame.size.height)! + labelGapBetween
        
        
        
        cell?.titleLabel.frame.origin.y = ((cell?.view.frame.size.height)! - labelTotalHeight) / 2 + (cell?.view.frame.size.height)! / 30
        cell?.titleLabel.frame.origin.x = (cell?.view.frame.size.width)! / 14
        
        cell?.titleDescription.frame.origin.y = (cell?.titleLabel.frame.origin.y)! + (cell?.titleLabel.frame.size.height)! + labelGapBetween
        cell?.titleDescription.frame.origin.x = (cell?.view.frame.size.width)! / 18
        cell?.titleDescription.isUserInteractionEnabled = false
        cell?.titleDescription.backgroundColor = .clear
        
        
       //titleDescription
        

        
        
        
        
        cell?.view.layer.shadowColor = UIColor.black.cgColor
        cell?.view.layer.shadowOpacity = 0.014
        cell?.view.layer.shadowOffset = .zero
        cell?.view.layer.shadowRadius = 6
        
        
        

        
        
        return cell ?? CredentialTableViewCell()
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedModel = indexPath.row
        
        tableView.cellForRow(at: indexPath)?.animateButtonDown()
        
        performSegue(withIdentifier: "CredentialDetailsSegue", sender: nil)
    }
    
    
  
    
 
    
    
    
    
}




