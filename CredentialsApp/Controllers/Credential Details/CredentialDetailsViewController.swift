//
//  CredentialDetailsViewController.swift
//  TrustID
//
//  Created by Berk Turan on 3/20/20.
//  Copyright © 2020 GatePay. All rights reserved.
//

import UIKit
import NFCPassportReader

extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {

        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4

        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

class FooterView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

/*
class MyCustomHeader: UITableViewHeaderFooterView {
    let title = UILabel()


    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {

        title.translatesAutoresizingMaskIntoConstraints = false


        contentView.addSubview(title)

        // Center the image vertically and place it near the leading
        // edge of the view. Constrain its width and height to 50 points.
        NSLayoutConstraint.activate([

        
            // Center the label vertically, and use it to fill the remaining
            // space in the header view.
            title.heightAnchor.constraint(equalToConstant: 30),

            title.trailingAnchor.constraint(equalTo:
                   contentView.layoutMarginsGuide.trailingAnchor),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
*/

class CredentialDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    

    // MARK: - UI Elements
    @IBOutlet weak var passportImageView: UIImageView!

    @IBOutlet weak var left_image_filling: UIImageView!
    @IBOutlet weak var right_image_filling: UIImageView!
    @IBOutlet weak var top_image_view: UIImageView!
    @IBOutlet weak var image_circle_fill: UIImageView!
    @IBOutlet weak var image_circle: UIImageView!


    @IBOutlet var tableVieww:UITableView!
    @IBOutlet var tableVieww2:UITableView!
    @IBOutlet var tableVieww3:UITableView!
    
    @IBOutlet weak var personal_info_label: UILabel!
    
    @IBOutlet weak var document_info_label: UILabel!
    
    @IBOutlet weak var credential_title: UILabel!
    
    
 
    //

    let myData = ["Full Name", "Nationality", "Birthdate"]
    var myData2 = [""]
    
    let document_info_labels = ["Document Type", "Serial Number", "Expiry Date"]

    var document_info_data =  [""]
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailVC {
            destination.issuingAuthorityCertPEM = credential["DS_certToPEM"]!
        }
    }
    
     override func viewDidLoad() {
         super.viewDidLoad()
        
        if self.traitCollection.userInterfaceStyle == .dark {
            image_circle.alpha = 0
            self.view.backgroundColor = UIColor(red: 0.01, green: 0.01, blue: 0.01, alpha: 1.00)

        } else {
            image_circle.alpha = 1
            self.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.00)
        }
        
        
        
 
         
         passportImageView.image = image

         
         
         setImageComponents()

        myData2 = [credential["firstName"]! + " " + credential["lastName"]!, credential["nationality"]!, credential["birthDate"]!]
        
        
        document_info_data = [credential["documentType"]! , credential["documentNumber"]! , credential["documentExpiryDate"]!]
    
        
        let nib = UINib(nibName: "DemoTableViewCell", bundle: nil)
        tableVieww.register(nib, forCellReuseIdentifier: "DemoTableViewCell")
        
        let nib2 = UINib(nibName: "TableViewCell2", bundle: nil)
        tableVieww2.register(nib2, forCellReuseIdentifier: "TableViewCell2")
        
        let nib3 = UINib(nibName: "TableViewCell3", bundle: nil)
        tableVieww3.register(nib3, forCellReuseIdentifier: "TableViewCell3")
        
        
        
        
        //tableVieww.register(MyCustomHeader.self, forHeaderFooterViewReuseIdentifier: "MyCustomHeader")
        
        

        
        tableVieww.delegate = self
        tableVieww.dataSource = self
        tableVieww.isScrollEnabled = false
        tableVieww.allowsSelection = false
        tableVieww.isUserInteractionEnabled = false
        
        tableVieww2.delegate = self
        tableVieww2.dataSource = self
        tableVieww2.isScrollEnabled = false
        tableVieww2.allowsSelection = false
        tableVieww2.isUserInteractionEnabled = false
        
        tableVieww3.delegate = self
        tableVieww3.dataSource = self
        tableVieww3.isScrollEnabled = false
        tableVieww3.allowsSelection = true
        tableVieww3.isUserInteractionEnabled = true
        
        
        //tableVieww.allowsSelectionDuringEditing = false


        
        
        

        /*
        let contentSize : CGSize = self.tableVieww.contentSize
        let width = self.tableVieww.contentSize.width
        let height = self.tableVieww.contentSize.height
        
        tableVieww.frame = CGRect(x: tableVieww.frame.origin.x, y: tableVieww.frame.origin.y, width: tableVieww.frame.size.width, height: tableVieww.contentSize.height)
        
         */
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()


        tableVieww?.reloadData()
        tableVieww2?.reloadData()
        tableVieww3?.reloadData()
    
     }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var return_int:Int = 0
        
        if tableView == self.tableVieww {
            return_int = myData.count
        }
        else if tableView == self.tableVieww2 {
            return_int = document_info_labels.count
        }
        else if tableView == self.tableVieww3 {
            return_int = 1
        }
        
        return return_int
    }
    
  /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
       
        if tableView == self.tableVieww3 {
            tableView.deselectRow(at: IndexPath.init(row: 0, section: 0), animated: true)
            
            performSegue(withIdentifier: "showdetail", sender: self)
        }

    }
    */

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        
        if tableView == self.tableVieww {
        var pCell = tableVieww.dequeueReusableCell(withIdentifier: "DemoTableViewCell", for: indexPath) as! DemoTableViewCell
        pCell.myLabel.text = myData[indexPath.row]
        pCell.myLabel2.text = myData2[indexPath.row] as! String
        pCell.myLabel.frame.origin.x = screenSize.width / 100 * 4
        pCell.myLabel2.frame.origin.x = screenSize.width / 100 * 35
        pCell.selectionStyle = .none
            
        tableVieww.frame.origin.x = -1
        tableVieww.frame.size.width = screenSize.width + 2
        tableVieww.frame.origin.y = passportImageView.frame.origin.y + passportImageView.frame.size.height * 40 / 25
        pCell.separatorInset = UIEdgeInsets.init(top: 0.0, left: screenSize.width / 100 * 35, bottom: 0.0, right: screenSize.width / 100 * 5)
        
            debugPrint("hadibe-1")
            
        tableVieww.frame = CGRect(x: tableVieww.frame.origin.x, y: tableVieww.frame.origin.y, width: tableVieww.frame.size.width, height: tableVieww.contentSize.height)
            
        if self.traitCollection.userInterfaceStyle == .dark {
            tableVieww.layer.borderColor = UIColor.darkGray.cgColor
        }
        else {
            tableVieww.layer.borderColor = UIColor.lightGray.cgColor
        }
            
        tableVieww.layer.borderWidth = 0.3
            
                   
        personal_info_label.frame.origin.y = tableVieww.frame.origin.y - personal_info_label.frame.size.height * 20 / 13
        personal_info_label.frame.origin.x = screenSize.width / 100 * 5
            
            
            
                
            cell = pCell
        }
        
        else if tableView == self.tableVieww2 {
            
        var pCell = tableVieww2.dequeueReusableCell(withIdentifier: "TableViewCell2", for: indexPath) as! TableViewCell2
        pCell.myLabel_2.text = document_info_labels[indexPath.row]
        pCell.myLabel2_2.text = document_info_data[indexPath.row] as! String
        pCell.myLabel_2.frame.origin.x = screenSize.width / 100 * 4
        pCell.myLabel2_2.frame.origin.x = screenSize.width / 100 * 40
        //pCell.selectionStyle = .none
            
            tableVieww2.frame.origin.x = -1
            tableVieww2.frame.size.width = screenSize.width + 2
            tableVieww2.frame.origin.y = tableVieww.frame.origin.y + self.tableVieww.contentSize.height + screenSize.width / 8
            pCell.separatorInset = UIEdgeInsets.init(top: 0.0, left: screenSize.width / 100 * 40, bottom: 0.0, right: screenSize.width / 100 * 5)
                
            tableVieww2.frame = CGRect(x: tableVieww2.frame.origin.x, y: tableVieww2.frame.origin.y, width: tableVieww2.frame.size.width, height: tableVieww2.contentSize.height)
 
            
            if self.traitCollection.userInterfaceStyle == .dark {
                tableVieww2.layer.borderColor = UIColor.darkGray.cgColor
            }
            else {
                tableVieww2.layer.borderColor = UIColor.lightGray.cgColor
            }
            tableVieww2.layer.borderWidth = 0.3
                
                       
            document_info_label.frame.origin.y = tableVieww2.frame.origin.y - document_info_label.frame.size.height * 20 / 13
            document_info_label.frame.origin.x = screenSize.width / 100 * 5
            
            
           
            
            

            cell = pCell
        }
        

        else if tableView == self.tableVieww3 {
            
        var pCell = tableVieww3.dequeueReusableCell(withIdentifier: "TableViewCell3", for: indexPath) as! TableViewCell3
        pCell.issuing_state_label.text = credential["issuingAuthority"]! 
        pCell.issuing_state_label.frame.origin.x = screenSize.width / 100 * 4
        pCell.issuing_state_label.frame.origin.x = screenSize.width / 100 * 40
        //pCell.selectionStyle = .none
        pCell.selectionStyle = .none
            
            tableVieww3.frame.origin.x = -1
            tableVieww3.frame.size.width = screenSize.width + 2
            tableVieww3.frame.origin.y = tableVieww.frame.origin.y + self.tableVieww.contentSize.height + screenSize.width / 8  + self.tableVieww2.contentSize.height - 0.5
            pCell.separatorInset = UIEdgeInsets.init(top: 0.0, left: screenSize.width / 100 * 50, bottom: 0.0, right: screenSize.width / 100 * 50)
                  
            //tableVieww3.frame = CGRect(x: tableVieww3.frame.origin.x, y: tableVieww3.frame.origin.y, width: tableVieww3.frame.size.width, height: tableVieww3.contentSize.height)
            
            if self.traitCollection.userInterfaceStyle == .dark {
                tableVieww3.layer.borderColor = UIColor.darkGray.cgColor
            }
            else {
                tableVieww3.layer.borderColor = UIColor.lightGray.cgColor
            }
            
            tableVieww3.layer.borderWidth = 0.3
                


            cell = pCell
        }
        
        if self.traitCollection.userInterfaceStyle == .dark {
            cell.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1.00)
        } else {
            cell.backgroundColor = .white
        }

        
        


        
        return cell
    }
    
    
    
    
    
 
    
    /*
    func tableView(_ tableView: UITableView,
            viewForHeaderInSection section: Int) -> UIView? {
       let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                   "MyCustomHeader") as! MyCustomHeader
       view.title.text = "slm"

       return view
    }
    */
    // don't forget to hook this up from the storyboard
 




    

    
    
    //@IBOutlet weak var tableview: UITableView!
    


    
    
    var screenSize = UIScreen.main.bounds
    
    // MARK: - properties
    var credential = [String:String]()
    var image = UIImage()
    
   override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
       super.traitCollectionDidChange(previousTraitCollection)

       guard UIApplication.shared.applicationState == .inactive else {
           return
       }

       viewDidLoad()
   }
    
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        debugPrint("mk")
        setImageComponents()
    }

 
    
    // MARK: - Life Cycle

    
    // MARK: - Life Cycle
     func setImageComponents() {
        super.viewDidLoad()
        
        screenSize = UIScreen.main.bounds

        
        let image_ratio = image.size.height / image.size.width
        let uiimageview_real_width = passportImageView.frame.size.height / image_ratio

        
        passportImageView.frame.size.width = uiimageview_real_width
        
        
        
        credential_title.frame.origin.x = screenSize.size.width / 2 -  credential_title.frame.size.width / 2
        credential_title.frame.origin.y = screenSize.size.width / 12
        
        passportImageView.frame.origin.x = screenSize.size.width / 2 -  passportImageView.frame.size.width / 2
        passportImageView.frame.origin.y = credential_title.frame.origin.y + credential_title.frame.size.height * 2.5
        
        let space1 = screenSize.width - passportImageView.frame.size.width
        let space2 = space1 / 2

        let passportImageView_wh_gap = passportImageView.frame.size.height - passportImageView.frame.size.width
        

        
        left_image_filling.frame.size.width = passportImageView_wh_gap / 2 + passportImageView.frame.size.height / 40
        left_image_filling.frame.size.height = passportImageView.frame.size.height
        left_image_filling.frame.origin.x = space2 - left_image_filling.frame.size.width
        left_image_filling.frame.origin.y = passportImageView.frame.origin.y
        left_image_filling.backgroundColor = image.getPixelColor(pos: CGPoint(x:14,y:14))
        
        right_image_filling.frame.size.width = passportImageView_wh_gap / 2 + passportImageView.frame.size.height / 40
        right_image_filling.frame.size.height = passportImageView.frame.size.height
        right_image_filling.frame.origin.x = space2 + passportImageView.frame.size.width
        right_image_filling.frame.origin.y = passportImageView.frame.origin.y
        right_image_filling.backgroundColor = image.getPixelColor(pos: CGPoint(x:14,y:14))
        
        top_image_view.frame.size.width = passportImageView.frame.size.height + passportImageView.frame.size.height / 20
        top_image_view.frame.size.height = passportImageView.frame.size.height / 16
        top_image_view.frame.origin.x = left_image_filling.frame.origin.x
        top_image_view.frame.origin.y = left_image_filling.frame.origin.y - passportImageView.frame.size.height / 20
        top_image_view.backgroundColor = image.getPixelColor(pos: CGPoint(x:14,y:14))
        
        image_circle_fill.frame.size.width = passportImageView.frame.size.height + passportImageView.frame.size.height / 20
        image_circle_fill.frame.size.height = image_circle_fill.frame.size.width
        image_circle_fill.frame.origin.x = top_image_view.frame.origin.x
        image_circle_fill.frame.origin.y = top_image_view.frame.origin.y
        image_circle_fill.setImageColor(color:self.view.backgroundColor!)
        
        image_circle.frame.size.width = passportImageView.frame.size.height + passportImageView.frame.size.height / 20
        image_circle.frame.size.height = image_circle_fill.frame.size.width
        image_circle.frame.origin.x = top_image_view.frame.origin.x
        image_circle.frame.origin.y = top_image_view.frame.origin.y

        
        
        
        
        let strip_aralik = passportImageView.frame.size.height / 100 * 50
        
        
        
        /*
        strip_long.frame.origin.x = 0
        strip_long.frame.origin.y = passportImageView.frame.origin.y + passportImageView.frame.size.height * 100 / 80
        strip_long.frame.size.width = screenSize.width
        strip_long.frame.size.height = passportImageView.frame.size.height / 185
        
        strip_short1.frame.origin.x = screenSize.width / 100 * 32
        strip_short1.frame.origin.y = strip_long.frame.origin.y + strip_aralik
        strip_short1.frame.size.width = screenSize.width / 100 * 65
        strip_short1.frame.size.height = passportImageView.frame.size.height / 185
        
        strip_short2.frame.origin.x = screenSize.width / 100 * 32
        strip_short2.frame.origin.y = strip_short1.frame.origin.y + strip_aralik
        strip_short2.frame.size.width = screenSize.width / 100 * 65
        strip_short2.frame.size.height = passportImageView.frame.size.height / 185
        
        strip_long2.frame.origin.x = 0
        strip_long2.frame.origin.y = strip_short2.frame.origin.y + strip_aralik
        strip_long2.frame.size.width = screenSize.width
        strip_long2.frame.size.height = passportImageView.frame.size.height / 185
        
        given_name.frame.origin.x = screenSize.width / 20
        given_name.frame.origin.y = strip_long.frame.origin.y + strip_aralik / 2 - given_name.frame.size.height / 2
        given_name.alpha = 0.9
        
        given_name_label.frame.origin.x = screenSize.width / 100 * 32
        given_name_label.frame.origin.y = strip_long.frame.origin.y + strip_aralik / 2 - given_name.frame.size.height / 2
        given_name_label.alpha = 0.9
        
        nationality.frame.origin.x = screenSize.width / 20
        nationality.frame.origin.y = strip_short1.frame.origin.y + strip_aralik / 2 - given_name.frame.size.height / 2
        nationality.alpha = 0.9
        
        nationality_label.frame.origin.x = screenSize.width / 100 * 32
        nationality_label.frame.origin.y = strip_short1.frame.origin.y + strip_aralik / 2 - given_name.frame.size.height / 2
        nationality_label.alpha = 0.9
        
        birthdate.frame.origin.x = screenSize.width / 20
        birthdate.frame.origin.y = strip_short2.frame.origin.y + strip_aralik / 2 - given_name.frame.size.height / 2
        birthdate.alpha = 0.9
        
        birthdate_label.frame.origin.x = screenSize.width / 100 * 32
        birthdate_label.frame.origin.y = strip_short2.frame.origin.y + strip_aralik / 2 - given_name.frame.size.height / 2
        birthdate_label.alpha = 0.9
        
        
        
        if self.traitCollection.userInterfaceStyle == .dark {
            strip_long.alpha = 0.1
            strip_short1.alpha = 0.1
            strip_short2.alpha = 0.1
            strip_long2.alpha = 0.1
        } else {
            strip_long.alpha = 1
            strip_short1.alpha = 1
            strip_short2.alpha = 1
            strip_long2.alpha = 1
        }
        
        
        */
        
        
        
        
        
        //tableview
        
        


        
    }
    
    

    

    
    

    // MARK: - Function
    
    // MARK: - Actions
}


