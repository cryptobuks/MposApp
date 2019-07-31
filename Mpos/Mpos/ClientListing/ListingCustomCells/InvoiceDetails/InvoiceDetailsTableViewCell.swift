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
    var bTerceirosSelected = Bool()
    var bSectionSelected = Bool()


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
    
    func goToErrorPage()
    {
        let storyBoard = UIStoryboard(name: "MposError", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "MposErrorVC") as! MposErrorVC
        controller.strErrorMessage = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla sed interdum elit, fringilla commodo nunc."
        self.viewControllerForTableView?.navigationController?.pushViewController(controller, animated: true)

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
        var lblAlphaColor = UIColor()

        cellForInvoiceWithCheckBox.btnCheckBox.isHidden = true
        cellForInvoiceWithCheckBox.btnDownload.isHidden = true
        cellForInvoiceWithCheckBox.btnViewMore.isHidden = false
        cellForInvoiceWithCheckBox.imgSelected.isHidden = true
        cellForInvoiceWithCheckBox.ctWidthImgSelected.constant = 0

        switch InvoiceType {
        case 1: //RISCO DE ANULAÇÃO
            lblColor = AppColors.kOrangeColor
            lblAlphaColor = AppColors.kOrangeColorWithAlpha
            cellForInvoiceWithCheckBox.btnCheckBox.isHidden = false
            break
        case 2: //POR COBRAR
            lblColor = AppColors.kPurpulColor
            lblAlphaColor = AppColors.kPurpulColorWithAlpha
            cellForInvoiceWithCheckBox.btnCheckBox.isHidden = false
            break
        case 3: // COBRADOS
            lblColor = AppColors.kGreenColor
            lblAlphaColor = AppColors.kGreenColorWithAlpha
            cellForInvoiceWithCheckBox.btnDownload.isHidden = false
            break
        case 4: // General Search
            lblColor = AppColors.kGeneralSearchColor
            lblAlphaColor = AppColors.kGeneralSearchColorWithAlpha
            cellForInvoiceWithCheckBox.btnCheckBox.isHidden = false
            break
        default:
            break
        }
        
        cellForInvoiceWithCheckBox.lblCaptionReceipt.textColor = lblColor
        cellForInvoiceWithCheckBox.lblCaptionValue.textColor = lblColor
        cellForInvoiceWithCheckBox.lblCaptionIssueDate.textColor = lblColor
        
        /*
         Furthermore, the screens to be presented as a result of a general search when the “Terceiros” radio button is selected are slightly different as:
         1. The text under “CLIENTE” is not pressable and does not direct users to the “Detalhe_cliente” screen;
         2. The “+ VER MAIS” and “DOWNLOAD” text boxes / buttons are not included in individual invoice tickets;
         */
        if(bTerceirosSelected == true)
        {
            cellForInvoiceWithCheckBox.btnDownload.isHidden = true
            cellForInvoiceWithCheckBox.btnViewMore.isHidden = true
        }
        
        /*
            In addition to the two points above, there can also be instances in which individual invoice tickets cannot be selected. Also, there can be instances where only the back-end is aware that particular invoice tickets cannot proceed to further screens within the app. In the first instance, these individual receipts have red design elements and a “danger” icon instead of a checkbox, as illustrated in figure 15 (i.e. in the second invoice ticket shown in the figure). In the second instance, as well as when users press the “danger” icon, the full-screen, closeable pop-up window represented in figure 16 is presented to the user;
         */
        if indexPath.row == 1
        {
            cellForInvoiceWithCheckBox.btnCheckBox.setImage(UIImage(named: "ic_InvoiceError"), for: .normal)
            cellForInvoiceWithCheckBox.imgSelected.isHidden = false
            cellForInvoiceWithCheckBox.ctWidthImgSelected.constant = 10
            cellForInvoiceWithCheckBox.imgSelected.backgroundColor = AppColors.kErrorColor
        }
        
        cellForInvoiceWithCheckBox.btnCheckBoxTapped =
            {
                //For Error
                if indexPath.row == 1
                {
                    self.goToErrorPage()
                }
                else
                {
                    if cellForInvoiceWithCheckBox.btnCheckBox.isSelected
                    {
                        cellForInvoiceWithCheckBox.btnCheckBox.isSelected = false
                        cellForInvoiceWithCheckBox.imgSelected.isHidden = true
                        cellForInvoiceWithCheckBox.ctWidthImgSelected.constant = 0
                        (self.viewControllerForTableView as! ClientWiseInvoiceListing).btnTotalInvoicePrice.isHidden = true
                        (self.viewControllerForTableView as! ClientWiseInvoiceListing).ctHeightbtnTotalPrice.constant = 0
                    }
                    else
                    {
                        cellForInvoiceWithCheckBox.btnCheckBox.isSelected = true
                        cellForInvoiceWithCheckBox.imgSelected.isHidden = false
                        cellForInvoiceWithCheckBox.ctWidthImgSelected.constant = 10
                        cellForInvoiceWithCheckBox.imgSelected.backgroundColor = lblAlphaColor
                        (self.viewControllerForTableView as! ClientWiseInvoiceListing).btnTotalInvoicePrice.isHidden = false
                        (self.viewControllerForTableView as! ClientWiseInvoiceListing).ctHeightbtnTotalPrice.constant = 60

                    }
                }
        }
        
        
       
        if bSectionSelected
        {
            cellForInvoiceWithCheckBox.btnCheckBox.isSelected = true
            cellForInvoiceWithCheckBox.imgSelected.isHidden = false
            cellForInvoiceWithCheckBox.ctWidthImgSelected.constant = 10
            cellForInvoiceWithCheckBox.imgSelected.backgroundColor = lblAlphaColor
        }
        else
        {
            cellForInvoiceWithCheckBox.btnCheckBox.isSelected = false
            cellForInvoiceWithCheckBox.imgSelected.isHidden = true
            cellForInvoiceWithCheckBox.ctWidthImgSelected.constant = 0
        }
        
        cellForInvoiceWithCheckBox.btnViewMore.addTarget(self, action: #selector(btnMoreInfoClicked(_:)), for: .touchUpInside)
        
    
        
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
