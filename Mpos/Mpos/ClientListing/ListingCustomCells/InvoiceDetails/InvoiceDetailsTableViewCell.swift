//
//  InvoiceDetailsTableViewCell.swift
//  Mpos
//
//  Created by kaushal panchal on 22/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import QuickLook
protocol InvoiceDetailsTableViewCellDelegate {
    func updateReceiptObject(bSelectedValue:Bool,indexpath:IndexPath,iSelectedReceiptIndex:Int)
}
class InvoiceDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgLeftSelection: UIImageView!
    @IBOutlet weak var lblCaptionInvoiceNumber: UILabel!
    @IBOutlet weak var lblCaptionPrice: UILabel!
    @IBOutlet weak var lblInvoiceNumber: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var btnExpandCollapse: UIButton!
    @IBOutlet weak var tblvwInvoices: UITableView!

    var delegate: InvoiceDetailsTableViewCellDelegate?

    var objPolicyDetails = [String:Any]()
    var selectedIndexPath = IndexPath()
    var objParent = UIViewController()

    var InvoiceType:Int = 0
    var bTerceirosSelected = Bool()
    var bSectionSelected = Bool()
    lazy var previewItem = NSURL()
    
    var btnExpandCollapseSelected: (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.tblvwInvoices.register(UINib(nibName: kCellOfInvoiceDetailsWIthCheckBoxTableViewCell, bundle: nil), forCellReuseIdentifier: kCellOfInvoiceDetailsWIthCheckBoxTableViewCell)
        
        self.tblvwInvoices.register(UINib(nibName: kCellOfInvoiceDetailsHeaderCell, bundle: nil), forCellReuseIdentifier: kCellOfInvoiceDetailsHeaderCell)
        
        self.tblvwInvoices.estimatedRowHeight = 260.0
        self.tblvwInvoices.estimatedSectionHeaderHeight = 85
        self.tblvwInvoices.rowHeight = UITableView.automaticDimension
        
        self.tblvwInvoices.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func btnMoreInfoClicked(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "ReceiptDetails", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ReceiptDetailsVC") as! ReceiptDetailsVC
        controller.InvoiceType = InvoiceType
        var dicRequest = [String:AnyObject]()
        if let arrReceipts = self.objPolicyDetails["receipts"] as? [Any]
        {
            if let objReceiptsDetail = arrReceipts[sender.tag] as? [String:Any]
            {
                dicRequest["policyId"] = objReceiptsDetail["policyId"] as AnyObject?
                dicRequest["receiptId"] = objReceiptsDetail["receiptId"] as AnyObject?
                dicRequest["companyId"] = objReceiptsDetail["companyId"] as AnyObject?

            }
        }
        controller.dicRequestParameter = dicRequest
        self.viewControllerForTableView?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func goToErrorPage()
    {
        let storyBoard = UIStoryboard(name: "MposError", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "MposErrorVC") as! MposErrorVC
        controller.strErrorMessage = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla sed interdum elit, fringilla commodo nunc."
        self.viewControllerForTableView?.navigationController?.pushViewController(controller, animated: true)

    }
    
    func downloadDocuments(iSelectedIndexPath:IndexPath)
    {
        
        
        var dicRequest = [String:AnyObject]()
        if let arrReceipts = self.objPolicyDetails["receipts"] as? [Any]
        {
            if let objReceiptsDetail = arrReceipts[iSelectedIndexPath.row] as? [String:Any]
            {
                dicRequest["policyId"] = objReceiptsDetail["policyId"] as AnyObject?
                dicRequest["receiptId"] = objReceiptsDetail["receiptId"] as AnyObject?
                dicRequest["companyId"] = objReceiptsDetail["companyId"] as AnyObject?
                dicRequest["documentId"] = objReceiptsDetail["pdf"] as AnyObject?

            }
        }
       
        MainReqeustClass.BaseRequestSharedInstance.postRequestWithHeader(showLoader: true, url: base_Url, parameter: dicRequest as [String : AnyObject], header: CommonMethods().createHeaderDic(strMethod: getDocUrl), success: { (response) in
            print(response)
            
            if let strBase64String = response["pdf"] as? String
            {
                let base64Encoded = strBase64String
                let decodedData = Data(base64Encoded: base64Encoded)!
                saveImageDocumentDirectory(imageData: decodedData, imageName: "Test\(iSelectedIndexPath.row)\(iSelectedIndexPath.section).pdf")
            }
            
            self.previewItem = getImageFromDocumentDirectory(imageName: "Test\(iSelectedIndexPath.row)\(iSelectedIndexPath.section).pdf")
            // Display file
            let previewController = QLPreviewController()
            previewController.dataSource = self
            self.objParent.present(previewController, animated: true, completion: nil)
        })
        { (responseError) in
            CommonMethods().displayAlertView("Error", aStrMessage: responseError, aStrOtherTitle: "ok")
        }
    }
    
    @IBAction func btnExpandCollapseAction(_ sender: UIButton)
    {
        self.btnExpandCollapseSelected?()
    }
}

//MARK:-UITableViewDelegate,UITableViewDataSource
extension InvoiceDetailsTableViewCell : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let arrReceipts = objPolicyDetails["receipts"] as? [Any]
        {
            return arrReceipts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
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
        
        //Set Danger icon.
        /* if indexPath.row == 1
         {
         cellForInvoiceWithCheckBox.btnCheckBox.setImage(UIImage(named: "ic_InvoiceError"), for: .normal)
         cellForInvoiceWithCheckBox.imgSelected.isHidden = false
         cellForInvoiceWithCheckBox.ctWidthImgSelected.constant = 10
         cellForInvoiceWithCheckBox.imgSelected.backgroundColor = AppColors.kErrorColor
         }*/
        
        if let arrReceipts = objPolicyDetails["receipts"] as? [Any]
        {
            if let objReceiptsDetail = arrReceipts[indexPath.row] as? [String:Any]
            {
                cellForInvoiceWithCheckBox.lblReceiptNumber.text = objReceiptsDetail["receiptId"] as? String
                cellForInvoiceWithCheckBox.lblIssueDate.text = objReceiptsDetail["issueDate"] as? String
                cellForInvoiceWithCheckBox.lblValue.text = "\(String(describing: objReceiptsDetail["amount"] as! Double).toCurrencyFormat())"
                
                if let isSelectedReceipt = objReceiptsDetail[kkeyisReceiptSelected] as? Bool, isSelectedReceipt == true
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
            }
        }
        
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
//        if indexPath.row == 1
//        {
//            cellForInvoiceWithCheckBox.btnCheckBox.setImage(UIImage(named: "ic_InvoiceError"), for: .normal)
//            cellForInvoiceWithCheckBox.imgSelected.isHidden = false
//            cellForInvoiceWithCheckBox.ctWidthImgSelected.constant = 10
//            cellForInvoiceWithCheckBox.imgSelected.backgroundColor = AppColors.kErrorColor
//        }
        
        cellForInvoiceWithCheckBox.btnCheckBoxTapped =
            {
                if let arrReceipts = self.objPolicyDetails["receipts"] as? [Any]
                {
                    if let objReceiptsDetail = arrReceipts[indexPath.row] as? [String:Any]
                    {
                        if let isSelectedReceipt = objReceiptsDetail[kkeyisReceiptSelected] as? Bool, isSelectedReceipt == true
                        {
                            cellForInvoiceWithCheckBox.btnCheckBox.isSelected = false
                            self.delegate?.updateReceiptObject(bSelectedValue: false, indexpath: self.selectedIndexPath,iSelectedReceiptIndex:indexPath.row)
                        }
                        else
                        {
                            cellForInvoiceWithCheckBox.btnCheckBox.isSelected = true
                            self.delegate?.updateReceiptObject(bSelectedValue: true, indexpath: self.selectedIndexPath,iSelectedReceiptIndex:indexPath.row)
                        }
                    }
                }
                //For Error
//                if indexPath.row == 1
//                {
//                    self.goToErrorPage()
//                }
        }
        
        cellForInvoiceWithCheckBox.btnDownloadTapped =
            {
                self.downloadDocuments(iSelectedIndexPath: indexPath)
        }
       
        
        cellForInvoiceWithCheckBox.btnViewMore.addTarget(self, action: #selector(btnMoreInfoClicked(_:)), for: .touchUpInside)
        cellForInvoiceWithCheckBox.btnViewMore.tag = indexPath.row
        return cellForInvoiceWithCheckBox
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        return UITableView.automaticDimension
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
        
        headerCell.lblBranch.text = (objPolicyDetails["branch"] as! String)
        
        if var strInsuredType = objPolicyDetails["insuredType"]
        {
            if (strInsuredType is NSNull)
            {
                strInsuredType = ""
            }
            headerCell.lblCaptionRegistrationNumber.text = "\(strInsuredType)"
        }
        
        if var strInsuredObject = objPolicyDetails["insuredObject"]
        {
            if (strInsuredObject is NSNull)
            {
                strInsuredObject = ""
            }
            headerCell.lblRegistrationNumber.text = "\(strInsuredObject)"
        }
        
        return headerCell
    }
}
//MARK:- QLPreviewController Datasource
extension InvoiceDetailsTableViewCell: QLPreviewControllerDataSource
{
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int
    {
        return 1
    }
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem
    {
        return self.previewItem as QLPreviewItem
    }
}
