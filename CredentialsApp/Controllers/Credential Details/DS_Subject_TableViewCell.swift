//
//  DS_Subject_TableViewCell.swift
//  TrustID
//
//  Created by Burak Keceli on 30.05.20.
//  Copyright © 2020 GatePay. All rights reserved.
//

import UIKit

class DS_Subject_TableViewCell: UITableViewCell {
    
    @IBOutlet var DS_Subject_Title: UILabel!
    @IBOutlet var DS_Subject_Label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        //DS_Subject_Title.text = "mal"
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
