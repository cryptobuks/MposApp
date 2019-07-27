//
//  InvoiceDetailsTableViewCell.swift
//  Mpos
//
//  Created by kaushal panchal on 22/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class InvoiceDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgLeftSelection: UIImageView!
    @IBOutlet weak var lblCaptionInvoiceNumber: UILabel!
    @IBOutlet weak var lblCaptionPrice: UILabel!
    @IBOutlet weak var lblInvoiceNumber: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var btnExpandCollapse: UIButton!
    @IBOutlet weak var tblvwInvoices: UITableView!

    var InvoiceType:Int = 0


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.tblvwInvoices.register(UINib(nibName: kCellOfInvoiceDetailsWIthCheckBoxTableViewCell, bundle: nil), forCellReuseIdentifier: kCellOfInvoiceDetailsWIthCheckBoxTableViewCell)
        
        self.tblvwInvoices.register(UINib(nibName: kCellOfInvoiceDetailsHeaderCell, bundle: nil), forCellReuseIdentifier: kCellOfInvoiceDetailsHeaderCell)
        
        self.tblvwInvoices.estimatedRowHeight = 260.0
        self.tblvwInvoices.rowHeight = UITableView.automaticDimension
        
        self.tblvwInvoices.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func btnMoreInfoClicked(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "ReceiptDetails", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ReceiptDetailsVC") as! ReceiptDetailsVC
        controller.InvoiceType = InvoiceType
        self.viewControllerForTableView?.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func btnCheckBoxSelected(_ sender: UIButton) {
        
        if sender.isSelected{
            sender.isSelected = false
        }
        else
        {
            sender .isSelected = true
        }
    }
}

//MARK:-UITableViewDelegate,UITableViewDataSource
extension InvoiceDetailsTableViewCell : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 260
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellForInvoiceWithCheckBox = tableView.dequeueReusableCell(withIdentifier: kCellOfInvoiceDetailsWIthCheckBoxTableViewCell) as! InvoiceDetailsWIthCheckBoxTableViewCell
        
        cellForInvoiceWithCheckBox.selectionStyle = .none
        var lblColor = UIColor()
        
        cellForInvoiceWithCheckBox.btnCheckBox.isHidden = true
        cellForInvoiceWithCheckBox.btnDownload.isHidden = true
        switch InvoiceType {
        case 1: //RISCO DE ANULAÇÃO
            lblColor = AppColors.kOrangeColor
            cellForInvoiceWithCheckBox.btnCheckBox.isHidden = false
            break
        case 2: //POR COBRAR
            lblColor = AppColors.kPurpulColor
            cellForInvoiceWithCheckBox.btnCheckBox.isHidden = false
            break
        case 3: // COBRADOS
            lblColor = AppColors.kGreenColor
            cellForInvoiceWithCheckBox.btnDownload.isHidden = false
            break
        case 4: // General Search
            lblColor = AppColors.kGeneralSearchColor
            cellForInvoiceWithCheckBox.btnDownload.isHidden = false
            break
        default:
            break
        }
        
        cellForInvoiceWithCheckBox.lblCaptionReceipt.textColor = lblColor
        cellForInvoiceWithCheckBox.lblCaptionValue.textColor = lblColor
        cellForInvoiceWithCheckBox.lblCaptionIssueDate.textColor = lblColor
        cellForInvoiceWithCheckBox.btnViewMore.addTarget(self, action: #selector(btnMoreInfoClicked(_:)), for: .touchUpInside)
        cellForInvoiceWithCheckBox.btnCheckBox.addTarget(self, action: #selector(btnCheckBoxSelected(_:)), for: .touchUpInside)
        return cellForInvoiceWithCheckBox
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        return 85
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: kCellOfInvoiceDetailsHeaderCell) as! InvoiceDetailsHeaderCell
        
            var lblColor = UIColor()
            
            switch InvoiceType {
            case 1: //RISCO DE ANULAÇÃO
                lblColor = AppColors.kOrangeColor
                break
            case 2: //POR COBRAR
                lblColor = AppColors.kPurpulColor
                break
            case 3: // COBRADOS
                lblColor = AppColors.kGreenColor
                break
            case 4: // Search
                lblColor = AppColors.kGeneralSearchColor
            default:
                break
            }
            headerCell.lblCaptionBranch.textColor = lblColor
            headerCell.lblCaptionRegistrationNumber.textColor = lblColor

            
            return headerCell
    }
}
