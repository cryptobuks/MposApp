//
//  SideMenuHeaderTableViewCell.swift
//  Mpos
//
//  Created by Kevin on 19/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class SideMenuHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblAgentTitle: UILabel!
    @IBOutlet weak var lblAgentName: UILabel!
    @IBOutlet weak var lblAgentNumber: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
