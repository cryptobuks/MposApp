//
//  InvoiceDetailsHeaderCell.swift
//  Mpos
//
//  Created by kaushal panchal on 27/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class InvoiceDetailsHeaderCell: UITableViewCell {

     @IBOutlet weak var lblCaptionBranch: UILabel!
     @IBOutlet weak var lblBranch: UILabel!
     @IBOutlet weak var lblCaptionRegistrationNumber: UILabel!
     @IBOutlet weak var lblRegistrationNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
