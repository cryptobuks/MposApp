//
//  DataConfirmationDropDownCell.swift
//  Mpos
//
//  Created by Yash on 23/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class DataConfirmationDropDownCell: UITableViewCell
{
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var ctHeightbtnDropDown: NSLayoutConstraint!

    var btnDropDownTapped: ((String)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnDropDownAction(_ sender: UIButton)
    {
        let arrtemp = ["Eu entrego ao cliente","Ageas envia automaticamente","email para luis.gomes@mail.com"]
        ActionSheetStringPicker.show(withTitle: "", rows: arrtemp as [Any], initialSelection: 0, doneBlock:
            {
                picker, value, index in
                self.btnDropDownTapped?(index as? String ?? "")
                return
        }, cancel: { ActionStringCancelBlock in return }, origin: self)
    }


}
