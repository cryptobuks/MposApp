//
//  CommitteesDetailsCell.swift
//  Mpos
//
//  Created by kaushal panchal on 25/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class CommitteesDetailsCell: UITableViewCell {

    @IBOutlet weak var lblCaptionAngariation: UILabel!
    @IBOutlet weak var lblCaptionCollection: UILabel!
    @IBOutlet weak var lblAngariation: UILabel!
    @IBOutlet weak var lblCollection: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
