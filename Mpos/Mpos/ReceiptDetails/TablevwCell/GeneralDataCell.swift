//
//  GeneralDataCell.swift
//  Mpos
//
//  Created by kaushal panchal on 25/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class GeneralDataCell: UITableViewCell {

    @IBOutlet weak var lblCaptionClient: UILabel!
    @IBOutlet weak var lblClient: UILabel!

    @IBOutlet weak var lblCaptionReceipt: UILabel!
    @IBOutlet weak var lblReceipt: UILabel!
    
    @IBOutlet weak var lblCaptionPolicyNumber: UILabel!
    @IBOutlet weak var lblPolicyNumber: UILabel!
    
    @IBOutlet weak var lblCaptionState: UILabel!
    @IBOutlet weak var lblState: UILabel!
    
    
    @IBOutlet weak var lblCaptionFractioning: UILabel!
    @IBOutlet weak var lblFractioning: UILabel!
    
    @IBOutlet weak var lblCaptionKind: UILabel!
    @IBOutlet weak var lblKind: UILabel!
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
