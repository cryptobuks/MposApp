//
//  PaymentMethodListTableViewCell.swift
//  Mpos
//
//  Created by Yash on 21/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class PaymentMethodListTableViewCell: UITableViewCell
{
    @IBOutlet weak var imgPaymentMethod: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblsubTitle: UILabel!
    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var ctWidthImgSelected: NSLayoutConstraint!
    @IBOutlet weak var vwPhoneView: UIView!
    @IBOutlet weak var ctHeightPhoneView: NSLayoutConstraint!
    @IBOutlet weak var txtfdPhoneNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var lblPhoneTitle: UILabel!
    var btnEditTapped: (()->())?

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnEditAction(_ sender: UIButton)
    {
        btnEditTapped?()
    }

}
