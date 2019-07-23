//
//  ClientDetailCell.swift
//  Mpos
//
//  Created by kaushal panchal on 18/07/19.
//  Copyright © 2019 k_p. All rights reserved.
//

import UIKit

class ClientDetailCell: UITableViewCell {

    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var lblCaptionClientName: UILabel!
    @IBOutlet weak var lblClientName: UILabel!
    @IBOutlet weak var lblCaptionNIF: UILabel!
    @IBOutlet weak var lblNIFValue: UILabel!
    @IBOutlet weak var lblCaptionRECIBOS: UILabel!
    @IBOutlet weak var lblRECIBOSValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
