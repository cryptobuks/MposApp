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
    var dicReceiptDetails = [String:Any]()
    var dicRequestParameter = [String:AnyObject]()
    private let refreshControl = UIRefreshControl()

    
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
     
      “PARTILHAR RECIBO”. Pressing this button should result in the invocation of the device’s native “share” function. All the information contained in this screen should be passed on as text to the sharing application chosen by the user;
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
        
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tblvwReceiptDetailsListing.refreshControl = refreshControl
        } else {
            tblvwReceiptDetailsListing.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)

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
        case 4: // COBRADOS
            imgTopShadow.backgroundColor = AppColors.kGeneralSearchColorWithAlpha
            lblTitleHeader.textColor = AppColors.kGeneralSearchColor
            btnMenu.tintColor = AppColors.kGeneralSearchColor
            btnBackArrow.tintColor = AppColors.kGeneralSearchColor
            break
        default:
            break
        }
        
        self.tblvwReceiptDetailsListing.register(UINib(nibName: kCellOfReceiptHeaderCell, bundle: nil), forCellReuseIdentifier: kCellOfReceiptHeaderCell)
        self.tblvwReceiptDetailsListing.register(UINib(nibName: kCellOfGeneralDataCell, bundle: nil), forCellReuseIdentifier: kCellOfGeneralDataCell)
        self.tblvwReceiptDetailsListing.register(UINib(nibName: kCellOfAwardsDetailsCell, bundle: nil), forCellReuseIdentifier: kCellOfAwardsDetailsCell)
        self.tblvwReceiptDetailsListing.register(UINib(nibName: kCellOfCommitteesDetailsCell, bundle: nil), forCellReuseIdentifier: kCellOfCommitteesDetailsCell)
        self.tblvwReceiptDetailsListing.register(UINib(nibName: kCellOfPaymentDataCell, bundle: nil), forCellReuseIdentifier: kCellOfPaymentDataCell)

        btnTotalInvoicePrice.addTarget(self, action: #selector(btnShareClicked(_:)), for: .touchUpInside)
        
        self.tblvwReceiptDetailsListing.estimatedRowHeight = 60.0
        self.tblvwReceiptDetailsListing.rowHeight = UITableView.automaticDimension
        
        self.callReceiptDetails()
    }
    
    
    @objc func pullToRefresh(){
        self.callReceiptDetails()
    }
    
    // MARK: ClientsReceipts API CALL
    func callReceiptDetails(){
        
        let loggedUser = UserDefaultManager.SharedInstance.getLoggedUser()
        dicRequestParameter["agentContext"] = loggedUser! as AnyObject
        
        //Call lientsReceipts Service
        MainReqeustClass.BaseRequestSharedInstance.postRequestWithHeader(showLoader: true, url: base_Url, parameter: dicRequestParameter as [String : AnyObject], header: CommonMethods().createHeaderDic(strMethod: receiptDetailsUrl), success: { (response) in
            print(response)
            self.dicReceiptDetails = response

            self.tblvwReceiptDetailsListing.reloadData()
            self.refreshControl.endRefreshing()
            
        })
        { (responseError) in
//            CommonMethods().displayAlertView("Error", aStrMessage: responseError, aStrOtherTitle: "ok")
            addErrorView(senderViewController: self, strErrorMessage: responseError)
        }
    }
    
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMenuClicked(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "SideMenu", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
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

    
    @objc func btnShareClicked(_ sender: UIButton) {
               // text to share
        let text = """
        DADOS GERAIS
        
        CLIENTE
        \(dicReceiptDetails["clientName"] as? String ?? "")
        
        RECIBO
        \(dicReceiptDetails["receiptId"] as? String ?? "")
        
        APÓLICE
        \(dicReceiptDetails["policyId"] as? String ?? "")
        
        ESTADO
        \(dicReceiptDetails["situation"] as? String ?? "")
        
        FRACIONAMENTO
        \(dicReceiptDetails["fractionation"] as? String ?? "")
        
        TIPO
        \(dicReceiptDetails["type"] as? String ?? "")
        
        PRÉMIOS
        
        PRÉMIO COMERCIAL
        \(dicReceiptDetails["commercialPremium"] as? Float ?? 0)€
        
        ENCARGOS DE VIDA
        \(dicReceiptDetails["lifeCharges"] as? Float ?? 0)€
        
        BONUS/MALUS
        \(dicReceiptDetails["bonusMalus"] as! Float)€
            
        IMPOSTOS
        \(dicReceiptDetails["taxes"] as! Float)€
        
        TOTAL RECIBO
        \(dicReceiptDetails["total"] as? Float ?? 0)€
        
        CAPITAL E RECIBO
        \(dicReceiptDetails["commercialPremium"] as? Float ?? 0)€
        
        LOCAL DE COBRANÇA
        \(dicReceiptDetails["billingLocation"] as? String ?? "")
        
        COMISSÕES
        
        ANGARIAÇÃO
        \(dicReceiptDetails["fundraising"] as? Float ?? 0)€
        
        COBRANÇA
        \(dicReceiptDetails["collections"] as? Float ?? 0)€
        
        DADOS DE PAGAMENTO
        
        ENTIDADE
        112543
        
        REFERÊNCIA
        256389187
        
        VALOR TOTAL
        \(dicReceiptDetails["total"] as? Float ?? 0)€
        """
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
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
            case 4: // COBRADOS
                lblColor = AppColors.kGeneralSearchColor
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
        case 4: // COBRADOS
            lblColor = AppColors.kGeneralSearchColor
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
            
            cellForGeneralData.lblClient.text = dicReceiptDetails["clientName"] as? String
            cellForGeneralData.lblReceipt.text = dicReceiptDetails["receiptId"] as? String
            cellForGeneralData.lblPolicyNumber.text = dicReceiptDetails["policyId"] as? String
            cellForGeneralData.lblState.text = dicReceiptDetails["situation"] as? String
            cellForGeneralData.lblFractioning.text = dicReceiptDetails["fractionation"] as? String
            cellForGeneralData.lblKind.text = dicReceiptDetails["type"] as? String
            print(cellForGeneralData)
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

            
            cellForAwardsDetailsCell.lblBonus.text = "\(dicReceiptDetails["bonusMalus"] as! Float)"
            cellForAwardsDetailsCell.lblTaxes.text = "\(dicReceiptDetails["taxes"] as! Float)"
            cellForAwardsDetailsCell.lblAdditional.text = "\(dicReceiptDetails["additional"] as? Float ?? 0)"
            cellForAwardsDetailsCell.lblCommissions.text = "\(dicReceiptDetails["lifeCharges"] as? Float ?? 0)"
            cellForAwardsDetailsCell.lblTotalReceipt.text = "\(dicReceiptDetails["total"] as? Float ?? 0)"
            cellForAwardsDetailsCell.lblLocalRecovery.text = dicReceiptDetails["billingLocation"] as? String
            cellForAwardsDetailsCell.lblCommercialAward.text = "\(dicReceiptDetails["commercialPremium"] as? Float ?? 0)"
            cellForAwardsDetailsCell.lblCapitalAndReceipt.text = "\(dicReceiptDetails["capitalAndReceipt"] as? Float ?? 0)"
            print(cellForAwardsDetailsCell)
            return cellForAwardsDetailsCell
        case 2:
            cellForCommitteesDetailsCell.lblCaptionAngariation.textColor = lblColor
            cellForCommitteesDetailsCell.lblCaptionCollection.textColor = lblColor
            
            cellForCommitteesDetailsCell.lblAngariation.text = "\(dicReceiptDetails["fundraising"] as? Float ?? 0)"
            cellForCommitteesDetailsCell.lblCollection.text = "\(dicReceiptDetails["collections"] as? Float ?? 0)"
            print(cellForCommitteesDetailsCell)

            return cellForCommitteesDetailsCell
        case 3:
            cellForPaymentCell.lblCaptionEntity.textColor = lblColor
            cellForPaymentCell.lblCaptionReference.textColor = lblColor
            cellForPaymentCell.lblCaptionTotalValue.textColor = lblColor
            print(cellForPaymentCell)

            return cellForPaymentCell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}

