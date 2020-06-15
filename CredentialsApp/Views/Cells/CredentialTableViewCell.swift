//
//  CredentialTableViewCell.swift
//  TrustID
//
//  Created by Berk Turan on 12/30/19.
//  Copyright © 2019 GatePay. All rights reserved.
//

import UIKit

class CredentialTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleDescription: UITextView!
    //@IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var flag: UIImageView!
    
    @IBOutlet weak var view: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
