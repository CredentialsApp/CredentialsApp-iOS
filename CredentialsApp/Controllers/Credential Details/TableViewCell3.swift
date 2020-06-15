//
//  TableViewCell3.swift
//  TrustID
//
//  Created by Burak Keceli on 30.05.20.
//  Copyright © 2020 GatePay. All rights reserved.
//

import UIKit

class TableViewCell3: UITableViewCell {
    
    @IBOutlet var issuing_state_title_label: UILabel!
    @IBOutlet var issuing_state_label: UILabel!
    @IBOutlet weak var right_arrow: UIImageView!
    
    var screenSize = UIScreen.main.bounds

    override func awakeFromNib() {
        super.awakeFromNib()
        right_arrow.frame.size.height = issuing_state_title_label.frame.size.height * 10 / 15
        right_arrow.frame.size.width =  right_arrow.frame.size.height * 54 / 86
        right_arrow.frame.origin.x = screenSize.size.width - right_arrow.frame.size.width * 2.7
        right_arrow.frame.origin.y = issuing_state_title_label.frame.origin.y + issuing_state_title_label.frame.size.height / 2 - right_arrow.frame.size.height / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
