//
//  ReceiptDetailsVC.swift
//  Mpos
//
//  Created by kaushal panchal on 25/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class ReceiptDetailsVC: UIViewController {
    
    @IBOutlet weak var tblvwReceiptDetailsListing: UITableView!
    @IBOutlet weak var imgTopShadow: UIImageView!
    @IBOutlet weak var lblTitleHeader: UILabel!
    
    @IBOutlet weak var btnBackArrow: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var vwHeader: UIView!
    
    @IBOutlet weak var btnTotalInvoicePrice: UIButton!
    
    
    var selectedIndex:Int = -1
    
    var InvoiceType:Int = 0
    var arrayTitles : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        arrayTitles = ["DADOS GERAIS","PRÉMIOS","COMISSÕES","DADOS DE PAGAMENTO"]
        self.setupUIBasedOnInvoiceType()
    }
    
    /*
     “RISCO DE ANULAÇÃO”, “POR COBRAR”, and “COBRADOS”. Pressing each of these will direct the user to a specific screen:
     1. If users press the “RISCO DE ANULAÇÃO” button in the Home Page screen they will be directed to the “Mpos_Lista_Risco de anulacao” screen. This action will invoke web service WS006;
     2. If users press the “POR COBRAR” button in the Home Page screen they will be directed to the “Mpos_por_cobrar” screen. This action will invoke web service WS006;
     3. If users press the “COBRADOS” button in the Home Page screen they will be directed to the “Mpos_Cobrados” screen. This action will invoke web service WS006;
     
     */
    func setupUIBasedOnInvoiceType() {
        
        vwHeader.layer.masksToBounds = false
        vwHeader.layer.shadowRadius = 4
        vwHeader.layer.shadowOpacity = 1
        vwHeader.layer.shadowColor = UIColor.gray.cgColor
        vwHeader.layer.shadowOffset = CGSize(width: 0 , height:2)
        btnBackArrow.setImage(btnBackArrow.imageView?.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        btnMenu.setImage(btnMenu.imageView?.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        lblTitleHeader.text = "DETALHE DO RECIBO"

        switch InvoiceType {
        case 1: //RISCO DE ANULAÇÃO
            imgTopShadow.backgroundColor = AppColors.kOrangeColorWithAlpha
            lblTitleHeader.textColor = AppColors.kOrangeColor
            btnMenu.tintColor = AppColors.kOrangeColor
            btnBackArrow.tintColor = AppColors.kOrangeColor
            
            break
        case 2: //POR COBRAR
            imgTopShadow.backgroundColor = AppColors.kPurpulColorWithAlpha
            lblTitleHeader.textColor = AppColors.kPurpulColor
            btnMenu.tintColor = AppColors.kPurpulColor
            btnBackArrow.tintColor = AppColors.kPurpulColor
            
            break
        case 3: // COBRADOS
            imgTopShadow.backgroundColor = AppColors.kGreenColorWithAlpha
            lblTitleHeader.textColor = AppColors.kGreenColor
            btnMenu.tintColor = AppColors.kGreenColor
            btnBackArrow.tintColor = AppColors.kGreenColor
            
            break
        default:
            break
        }
        
        self.tblvwReceiptDetailsListing.register(UINib(nibName: kCellOfReceiptHeaderCell, bundle: nil), forCellReuseIdentifier: kCellOfReceiptHeaderCell)
        self.tblvwReceiptDetailsListing.register(UINib(nibName: kCellOfGeneralDataCell, bundle: nil), forCellReuseIdentifier: kCellOfGeneralDataCell)
        self.tblvwReceiptDetailsListing.register(UINib(nibName: kCellOfAwardsDetailsCell, bundle: nil), forCellReuseIdentifier: kCellOfAwardsDetailsCell)
        self.tblvwReceiptDetailsListing.register(UINib(nibName: kCellOfCommitteesDetailsCell, bundle: nil), forCellReuseIdentifier: kCellOfCommitteesDetailsCell)
        self.tblvwReceiptDetailsListing.register(UINib(nibName: kCellOfPaymentDataCell, bundle: nil), forCellReuseIdentifier: kCellOfPaymentDataCell)

        
        self.tblvwReceiptDetailsListing.estimatedRowHeight = 60.0
        self.tblvwReceiptDetailsListing.rowHeight = UITableView.automaticDimension
        self.tblvwReceiptDetailsListing.reloadData()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMenuClicked(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "SideMenu", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func btnPlusBtnClicked(_ sender: UIButton) {
        
        if sender.tag == selectedIndex{
            selectedIndex = -1
        }
        else
        {
            selectedIndex = sender.tag
        }
        
        tblvwReceiptDetailsListing.reloadData()
        
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
//MARK:-UITableViewDelegate,UITableViewDataSource
extension ReceiptDetailsVC : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedIndex == section{
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selectedIndex == indexPath.section{
            switch indexPath.section {
            case 0:
                return 455
            case 1:
                return 600
            case 2:
                return 160
            case 3:
                return 250
            default:
                break
            }
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: kCellOfReceiptHeaderCell) as! ReceiptHeaderCell
        var lblColor = UIColor()
        
        if selectedIndex == section
        {
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
            default:
                break
            }
        }
        else
        {
            lblColor = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
        }
        
        headerCell.lblTitle.textColor = lblColor
        headerCell.lblTitle.text = arrayTitles[section]
        headerCell.btnExpandCollapse.addTarget(self, action: #selector(btnPlusBtnClicked(_:)), for: .touchUpInside)
        headerCell.btnExpandCollapse.tag = section
        
        
        if section == selectedIndex
        {
            headerCell.btnExpandCollapse.tintColor = lblColor
            headerCell.btnExpandCollapse.isSelected = true
            headerCell.btnExpandCollapse.setImage(headerCell.btnExpandCollapse.imageView?.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .selected)
        }
        else
        {
            headerCell.btnExpandCollapse.tintColor = #colorLiteral(red: 0.5450980392, green: 0.5450980392, blue: 0.5450980392, alpha: 1)
            headerCell.btnExpandCollapse.isSelected = false
            headerCell.btnExpandCollapse.setImage(headerCell.btnExpandCollapse.imageView?.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        }
        return headerCell
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellForGeneralData = tableView.dequeueReusableCell(withIdentifier: kCellOfGeneralDataCell) as! GeneralDataCell
        let cellForAwardsDetailsCell = tableView.dequeueReusableCell(withIdentifier: kCellOfAwardsDetailsCell) as! AwardsDetailsCell
        let cellForCommitteesDetailsCell = tableView.dequeueReusableCell(withIdentifier: kCellOfCommitteesDetailsCell) as! CommitteesDetailsCell
        let cellForPaymentCell = tableView.dequeueReusableCell(withIdentifier: kCellOfPaymentDataCell) as! PaymentDataCell
        
        cellForGeneralData.selectionStyle = .none
        cellForAwardsDetailsCell.selectionStyle = .none
        cellForCommitteesDetailsCell.selectionStyle = .none
        cellForPaymentCell.selectionStyle = .none

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
        default:
            break
        }
    
        switch indexPath.section {
        case 0:
            cellForGeneralData.lblCaptionKind.textColor = lblColor
            cellForGeneralData.lblCaptionState.textColor = lblColor
            cellForGeneralData.lblCaptionClient.textColor = lblColor
            cellForGeneralData.lblCaptionReceipt.textColor = lblColor
            cellForGeneralData.lblCaptionFractioning.textColor = lblColor
            cellForGeneralData.lblCaptionPolicyNumber.textColor = lblColor

            return cellForGeneralData
        case 1:
            cellForAwardsDetailsCell.lblCaptionBonus.textColor = lblColor
            cellForAwardsDetailsCell.lblCaptionTaxes.textColor = lblColor
            cellForAwardsDetailsCell.lblCaptionAdditional.textColor = lblColor
            cellForAwardsDetailsCell.lblCaptionCommissions.textColor = lblColor
            cellForAwardsDetailsCell.lblCaptionTotalReceipt.textColor = lblColor
            cellForAwardsDetailsCell.lblCaptionLocalRecovery.textColor = lblColor
            cellForAwardsDetailsCell.lblCaptionCommercialAward.textColor = lblColor
            cellForAwardsDetailsCell.lblCaptionCapitalAndReceipt.textColor = lblColor

            return cellForAwardsDetailsCell
        case 2:
            cellForCommitteesDetailsCell.lblCaptionAngariation.textColor = lblColor
            cellForCommitteesDetailsCell.lblCaptionCollection.textColor = lblColor
            return cellForCommitteesDetailsCell
        case 3:
            cellForPaymentCell.lblCaptionEntity.textColor = lblColor
            cellForPaymentCell.lblCaptionReference.textColor = lblColor
            cellForPaymentCell.lblCaptionTotalValue.textColor = lblColor
            return cellForPaymentCell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}

