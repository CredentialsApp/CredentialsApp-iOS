
//  DetailVC.swift
//  TrustID
//
//  Created by Burak Keceli on 30.05.20.
//  Copyright © 2020 GatePay. All rights reserved.
//

import UIKit

//class DetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

class DetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var DS_headerTitle: UILabel!
    @IBOutlet weak var DS_Header: UIView!
    
    @IBOutlet weak var DS_doneButton: UIButton!
    
    @IBOutlet weak var DS_Subject_TableView: UITableView!
 
    @IBOutlet weak var filling_textView: UITextView!
    
    var screenSize = UIScreen.main.bounds
    var issuingAuthorityCertPEM:String = ""
    let DS_Subject_Titles = ["Country or Region", "Organization", "Organization Unit", "Common Name", "Common Name"]
   
    
    @IBAction func DS_doneButton_Tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugPrint("DetailVCDetailVCDetailVCDetailVCcert basla")
        
        if self.traitCollection.userInterfaceStyle == .dark {
            self.view.backgroundColor = UIColor(red: 0.01, green: 0.01, blue: 0.01, alpha: 1.00)
            self.view.backgroundColor = UIColor(red: 0.01, green: 0.01, blue: 0.01, alpha: 1.00)
        } else {
            self.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.00)
            self.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.00)
        }
        
        filling_textView.alpha = 0
        //filling_textView.text = "sleam"
        
        DS_Header.frame.origin.x = 0
        DS_Header.frame.origin.y = 0
        DS_Header.frame.size.width = screenSize.size.width
        DS_Header.frame.size.height = 60
        
        DS_doneButton.frame.origin.y = DS_Header.frame.size.height / 2 - DS_doneButton.frame.size.height / 2.3
        DS_doneButton.frame.origin.x = DS_Header.frame.size.width - DS_doneButton.frame.size.width * 1.2
        
        DS_headerTitle.frame.origin.y = DS_Header.frame.size.height / 2 - DS_headerTitle.frame.size.height / 2.3
        DS_headerTitle.frame.origin.x = DS_Header.frame.size.width / 2 - DS_headerTitle.frame.size.width / 2
        
        
        
        
        
        DS_Subject_TableView.delegate = self
        DS_Subject_TableView.dataSource = self
        DS_Subject_TableView.isScrollEnabled = false
        DS_Subject_TableView.allowsSelection = false
        DS_Subject_TableView.isUserInteractionEnabled = false
        
        let nib = UINib(nibName: "DS_Subject_TableViewCell", bundle: nil)
        DS_Subject_TableView.register(nib, forCellReuseIdentifier: "DS_Subject_TableViewCell")
        
        debugPrint("DetailVCDetailVCDetailVCDetailVCcert bit")
        debugPrint(issuingAuthorityCertPEM)
        
        //DS_ScrollView.frame.size.height = 950
        //DS_ScrollView.frame.size.width = 150
        //DS_ScrollView.frame.origin.x = 0
        //DS_ScrollView.frame.origin.y = 0
        
        
  
        

        // Do any additional setup after loading the view.
        
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var return_int:Int = 0
        
        if tableView == self.DS_Subject_TableView {
            return_int = DS_Subject_Titles.count
        }
        
        return return_int
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        debugPrint("hadibe0")
        
        var cell:UITableViewCell!
        
        if tableView == self.DS_Subject_TableView {
            
            debugPrint("hadibemk ya 0 ")
            
            var pCell = DS_Subject_TableView.dequeueReusableCell(withIdentifier: "DS_Subject_TableViewCell", for: indexPath) as! DS_Subject_TableViewCell
            
            
            
            debugPrint("hadibemk ya 1 ")
            
            pCell.DS_Subject_Title.text = DS_Subject_Titles[indexPath.row]
            pCell.DS_Subject_Label.text = DS_Subject_Titles[indexPath.row] as! String
            pCell.DS_Subject_Title.frame.origin.x = screenSize.width / 100 * 4
            pCell.DS_Subject_Label.frame.origin.x = screenSize.width / 100 * 35
            pCell.selectionStyle = .none
                debugPrint("hadibemk ya 2 ")
            tableView.frame.origin.x = -1
            tableView.frame.size.width = screenSize.width + 2
            tableView.frame.origin.y = screenSize.width / 6
            pCell.separatorInset = UIEdgeInsets.init(top: 0.0, left: screenSize.width / 100 * 35, bottom: 0.0, right: screenSize.width / 100 * 5)
            
            let contentSize : CGSize = self.DS_Subject_TableView.contentSize
            let width = self.DS_Subject_TableView.contentSize.width
            let height = self.DS_Subject_TableView.contentSize.height
                       
            debugPrint("hadibe1")
                
            tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)
            tableView.layer.borderColor = UIColor.lightGray.cgColor
            tableView.layer.borderWidth = 0.3
                
            
            cell = pCell
        }
        
        return cell
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
