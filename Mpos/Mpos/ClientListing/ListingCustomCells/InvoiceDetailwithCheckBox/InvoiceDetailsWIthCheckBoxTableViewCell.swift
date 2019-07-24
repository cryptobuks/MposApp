//
//  InvoiceDetailsWIthCheckBoxTableViewCell.swift
//  Mpos
//
//  Created by kaushal panchal on 24/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class InvoiceDetailsWIthCheckBoxTableViewCell: UITableViewCell {

    @IBOutlet weak var btnCheckBox: UIButton!
    
    @IBOutlet weak var lblCaptionReceipt: UILabel!
    @IBOutlet weak var lblReceiptNumber: UILabel!
    
    
    @IBOutlet weak var lblCaptionIssueDate: UILabel!
    @IBOutlet weak var lblIssueDate: UILabel!
    
    @IBOutlet weak var lblCaptionValue: UILabel!
    @IBOutlet weak var lblValue: UILabel!

    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnViewMore: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
