//
//  CategoryListTableViewCell.swift
//  Mpos
//
//  Created by Yash on 20/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class CategoryListTableViewCell: UITableViewCell
{
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgCategoryColor: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
