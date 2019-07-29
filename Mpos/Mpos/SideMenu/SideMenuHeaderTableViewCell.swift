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
    
    @IBAction func btnChangeAgentDropDownAction(_ sender: UIButton)
    {
        let arrtemp = ["256","257","258","259","260","261","262","263","264","265"]
        ActionSheetStringPicker.show(withTitle: "", rows: arrtemp as [Any], initialSelection: 0, doneBlock:
            {
                picker, value, index in
                self.lblAgentNumber.text = (index as? String ?? "")
                return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }

}
