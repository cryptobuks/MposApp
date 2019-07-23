//
//  InvoiceDetailsTableViewCell.swift
//  Mpos
//
//  Created by kaushal panchal on 22/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class InvoiceDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgLeftSelection: UIImageView!
    @IBOutlet weak var lblCaptionInvoiceNumber: UILabel!
    @IBOutlet weak var lblCaptionPrice: UILabel!
    @IBOutlet weak var lblInvoiceNumber: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var btnExpandCollapse: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
