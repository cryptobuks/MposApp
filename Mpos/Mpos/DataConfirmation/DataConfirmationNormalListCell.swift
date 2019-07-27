//
//  DataConfirmationNormalListCell.swift
//  Mpos
//
//  Created by Yash on 22/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class DataConfirmationNormalListCell: UITableViewCell {

    @IBOutlet weak var lblTitleHeader: UILabel!
    @IBOutlet weak var lblPriceHeader: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
