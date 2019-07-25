//
//  PaymentDataCell.swift
//  Mpos
//
//  Created by kaushal panchal on 25/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class PaymentDataCell: UITableViewCell {

    @IBOutlet weak var lblCaptionEntity: UILabel!
    @IBOutlet weak var lblEntity: UILabel!
    @IBOutlet weak var lblCaptionReference: UILabel!
    @IBOutlet weak var lblReference: UILabel!
    @IBOutlet weak var lblCaptionTotalValue: UILabel!
    @IBOutlet weak var lblTotalValue: UILabel!


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
