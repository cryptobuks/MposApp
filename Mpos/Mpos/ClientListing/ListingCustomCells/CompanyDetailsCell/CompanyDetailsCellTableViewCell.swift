//
//  CompanyDetailsCellTableViewCell.swift
//  Mpos
//
//  Created by kaushal panchal on 22/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class CompanyDetailsCellTableViewCell: UITableViewCell {

    @IBOutlet weak var imgvwCompanyLogo: UIImageView!
    @IBOutlet weak var lblInvoiceTotal: UILabel!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var lblCompanyName: UILabel!
    var btnRadioTapped: (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func btnCheckboxAction(_ sender: Any)
    {
        self.btnRadioTapped?()
    }
  
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
