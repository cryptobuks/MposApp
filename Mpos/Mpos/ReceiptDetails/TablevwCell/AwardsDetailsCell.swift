//
//  AwardsDetailsCell.swift
//  Mpos
//
//  Created by kaushal panchal on 25/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class AwardsDetailsCell: UITableViewCell {

    @IBOutlet weak var lblCaptionCommercialAward: UILabel!
    @IBOutlet weak var lblCommercialAward: UILabel!
    @IBOutlet weak var lblCaptionCommissions: UILabel!
    @IBOutlet weak var lblCommissions: UILabel!
    @IBOutlet weak var lblCaptionBonus: UILabel!
    @IBOutlet weak var lblBonus: UILabel!
    @IBOutlet weak var lblCaptionTaxes: UILabel!
    @IBOutlet weak var lblTaxes: UILabel!
    @IBOutlet weak var lblCaptionAdditional: UILabel!
    @IBOutlet weak var lblAdditional: UILabel!
    @IBOutlet weak var lblCaptionTotalReceipt: UILabel!
    @IBOutlet weak var lblTotalReceipt: UILabel!
    @IBOutlet weak var lblCaptionCapitalAndReceipt: UILabel!
    @IBOutlet weak var lblCapitalAndReceipt: UILabel!
    @IBOutlet weak var lblCaptionLocalRecovery: UILabel!
    @IBOutlet weak var lblLocalRecovery: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
