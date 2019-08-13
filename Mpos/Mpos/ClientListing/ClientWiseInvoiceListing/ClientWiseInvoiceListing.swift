//
//  ClientWiseInvoiceListing.swift
//  Mpos
//
//  Created by kaushal panchal on 23/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//
/*
 The behaviour of these screens is the same as that of the general search results screen originating from a search recognized by the back-end as a “NIF” search while having the “Meus” radio button selected. The colours are different and the development of these screens should follow the visual identity provided in the Adobe XD files.
 There is an extra element with regard to the “COBRADOS” screens:
 1. Every time a user accesses the Home Page screen the KPIs in the “COBRADOS” box are registered;
 2. When a user accesses it and the number is greater than that of the last time he accessed the Home Page screen, a red notification mark should appear in the top right corner of the “COBRADOS” box, with the difference between the two numbers (i.e. Number of invoices now minus number of invoices the last time the user accessed the Home Page screen).
 Thus, all behavioural rules stated in the context of the general search results screens apply to the screens presented in figures 20 and 21. But in summary:
 1. Pressing one of the individual boxes in the screens represented in figures 17 to 19 will lead to screens which have no boxes expanded at all (i.e. unless they have only one item inside, that is, if there is only one “Company”, one “Apólice” and one invoice ticket inside that “Apólice” box);
 2. The filter bar follows the same rules as those of search, including the contemplation of whether the back-end detects the search as a “NIF”, “Apólice” or “Recibo” search (i.e. the presentation of the boxes in the results should follow the same presentation patterns and rules with regard to the expansion of boxes);
 3. Only the items in “COBRADOS” will have the “Download” functionality for invoice tickets;
 4. Pressing the “AVANÇAR” button directs users to the “Mpos_Resumo” screen, which is explained in the next section.
 */
import UIKit

class ClientWiseInvoiceListing: UIViewController {
    
    @IBOutlet weak var tblvwInvoiceListing: UITableView!
    @IBOutlet weak var imgTopShadow: UIImageView!
    @IBOutlet weak var lblTitleHeader: UILabel!
    
    @IBOutlet weak var btnBackArrow: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var vwHeader: UIView!
    
    @IBOutlet weak var btnTotalInvoicePrice: UIButton!
    @IBOutlet weak var ctHeightbtnTotalPrice: NSLayoutConstraint!
    
    var InvoiceType:Int = 0
    var objClientRef = [String:Any]()
    var indexSelectedCompany:Int = -1

    var arrCompanies = NSMutableArray()
    var StrType : String = ""

    private let refreshControl = UIRefreshControl()


    /*
     Furthermore, the screens to be presented as a result of a general search when the “Terceiros” radio button is selected are slightly different as:
     1. The text under “CLIENTE” is not pressable and does not direct users to the “Detalhe_cliente” screen;
     2. The “+ VER MAIS” and “DOWNLOAD” text boxes / buttons are not included in individual invoice tickets;
     */
    var bTerceirosSelected = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ctHeightbtnTotalPrice.constant = 0
        btnTotalInvoicePrice.isHidden = true
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
        
        
        
        switch InvoiceType {
        case 1: //RISCO DE ANULAÇÃO
            imgTopShadow.backgroundColor = AppColors.kOrangeColorWithAlpha
            lblTitleHeader.text = "RISCO DE ANULAÇÃO"
            lblTitleHeader.textColor = AppColors.kOrangeColor
            btnMenu.tintColor = AppColors.kOrangeColor
            btnBackArrow.tintColor = AppColors.kOrangeColor
            refreshControl.tintColor = AppColors.kOrangeColor
            break
        case 2: //POR COBRAR
            imgTopShadow.backgroundColor = AppColors.kPurpulColorWithAlpha
            lblTitleHeader.text = "POR COBRAR"
            lblTitleHeader.textColor = AppColors.kPurpulColor
            btnMenu.tintColor = AppColors.kPurpulColor
            btnBackArrow.tintColor = AppColors.kPurpulColor
            refreshControl.tintColor = AppColors.kPurpulColor

            
            break
        case 3: // COBRADOS
            imgTopShadow.backgroundColor = AppColors.kGreenColorWithAlpha
            lblTitleHeader.text = "COBRADOS"
            lblTitleHeader.textColor = AppColors.kGreenColor
            btnMenu.tintColor = AppColors.kGreenColor
            btnBackArrow.tintColor = AppColors.kGreenColor
            refreshControl.tintColor = AppColors.kGreenColor

            
            break
        case 4: // Search
            imgTopShadow.backgroundColor = AppColors.kGeneralSearchColorWithAlpha
            lblTitleHeader.text = "RESULTADOS"
            lblTitleHeader.textColor = AppColors.kGeneralSearchColor
            btnMenu.tintColor = AppColors.kGeneralSearchColor
            btnBackArrow.tintColor = AppColors.kGeneralSearchColor
            refreshControl.tintColor = AppColors.kGeneralSearchColor

            break
        default:
            break
        }
        
        self.tblvwInvoiceListing.register(UINib(nibName: kCellOfCompanyDetails, bundle: nil), forCellReuseIdentifier: kCellOfCompanyDetails)
        self.tblvwInvoiceListing.register(UINib(nibName: kCellOfInvoiceDetails, bundle: nil), forCellReuseIdentifier: kCellOfInvoiceDetails)
        self.tblvwInvoiceListing.register(UINib(nibName: kDataConfirmationHeaderCell, bundle: nil), forCellReuseIdentifier: kDataConfirmationHeaderCell)
        
        self.tblvwInvoiceListing.estimatedSectionHeaderHeight = 80
        self.tblvwInvoiceListing.estimatedRowHeight = 60.0
        self.tblvwInvoiceListing.rowHeight = UITableView.automaticDimension
        self.tblvwInvoiceListing.tableFooterView = UIView(frame: .zero)
        
        if InvoiceType < 4
        {
            // Add Refresh Control to Table View
            if #available(iOS 10.0, *) {
                tblvwInvoiceListing.refreshControl = refreshControl
            } else {
                tblvwInvoiceListing.addSubview(refreshControl)
            }
            // Configure Refresh Control
            refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
            self.callClientReceipts(type: StrType)
        }
        else
        {
            self.setSelectedKeyinServerResponse()
            self.tblvwInvoiceListing.reloadData()
        }
    }
    
    
    @objc func pullToRefresh(){
        self.callClientReceipts(type: StrType)
    }
    
    // MARK: ClientsReceipts API CALL
    func callClientReceipts(type:String)
    {
        let params = ["type":type]
        //Call lientsReceipts Service
        MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: true, url: "5d3b11453000000f00a29f7e", parameter: params as [String : AnyObject], success: { (response) in
            print(response)
            
            self.arrCompanies.removeAllObjects()
            
            if let arrCompanies = response["companies"] as? NSArray
            {
                self.arrCompanies.addObjects(from: arrCompanies as! [Any])
            }
            self.setSelectedKeyinServerResponse()
            self.tblvwInvoiceListing.reloadData()
            self.refreshControl.endRefreshing()
            
        })
        { (responseError) in
            print(responseError)
        }
    }
    
    func setSelectedKeyinServerResponse()
    {
        for iIndex in 0..<arrCompanies.count
        {
            if let dicCompany = arrCompanies[iIndex] as? [String:Any]
            {
                let dictCompanyMutableObject = NSMutableDictionary(dictionary: dicCompany)
                dictCompanyMutableObject.setValue(false, forKey: kSectionCellSelected)
                
                var arrPoliciesMutableObject = NSMutableArray()
                if let arrPolicies = dicCompany["policies"] as? [Any]
                {
                    arrPoliciesMutableObject = NSMutableArray(array: arrPolicies)
                    for iIndexPolicy in 0..<arrPoliciesMutableObject.count
                    {
                        if let objPolicyDetail = arrPoliciesMutableObject[iIndexPolicy] as? [String:Any]
                        {
                            let dictPolicyDetailMutableObject = NSMutableDictionary(dictionary: objPolicyDetail)
                            dictPolicyDetailMutableObject.setValue(false, forKey: kkeyisPolicySelected)
                            
                            //set Receipt selected Key
                            var arrReceiptsMutableObject = NSMutableArray()
                            if let arrReceipts = objPolicyDetail["receipts"] as? [Any]
                            {
                                arrReceiptsMutableObject = NSMutableArray(array: arrReceipts)
                                for iIndexReceipt in 0..<arrReceiptsMutableObject.count
                                {
                                    if let objReceiptsDetail = arrReceiptsMutableObject[iIndexReceipt] as? [String:Any]
                                    {
                                        let dictReceiptsDetailMutableObject = NSMutableDictionary(dictionary: objReceiptsDetail)
                                        dictReceiptsDetailMutableObject.setValue(true, forKey: kkeyisReceiptSelected)
                                        arrReceiptsMutableObject.replaceObject(at: iIndexReceipt, with: dictReceiptsDetailMutableObject)
                                    }
                                }
                            }
                            /////////////////////////////
                            dictPolicyDetailMutableObject.setValue(arrReceiptsMutableObject, forKey: "receipts")

                            arrPoliciesMutableObject.replaceObject(at: iIndexPolicy, with: dictPolicyDetailMutableObject)
                        }
                    }
                }
                dictCompanyMutableObject.setValue(arrPoliciesMutableObject, forKey: "policies")
                arrCompanies.replaceObject(at: iIndex, with: dictCompanyMutableObject)
            }
        }
    }
    
    //MARK: User actions
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
    
    func setSectionSelection(iSelectedIndex: Int,bSetValue:Bool)
    {
        for iIndex in 0..<arrCompanies.count
        {
            if let dicCompany = arrCompanies[iIndex] as? [String:Any]
            {
                let dictCompanyMutableObject = NSMutableDictionary(dictionary: dicCompany)
                dictCompanyMutableObject.setValue(false, forKey: kSectionCellSelected)
                
                let arrPoliciesMutableObject = self.setCompanybasedPolicySelection(dictCompany: dicCompany, bSelected: false)
                dictCompanyMutableObject.setValue(arrPoliciesMutableObject, forKey: "policies")
                arrCompanies.replaceObject(at: iIndex, with: dictCompanyMutableObject)
            }
        }

        if bSetValue == true
        {
            if let dicCompany = arrCompanies[iSelectedIndex] as? [String:Any]
            {
                indexSelectedCompany = iSelectedIndex
                let dictCompanyMutableObject = NSMutableDictionary(dictionary: dicCompany)
                dictCompanyMutableObject.setValue(true, forKey: kSectionCellSelected)
//
//                let arrPoliciesMutableObject = self.setCompanybasedPolicySelection(dictCompany: dicCompany, bSelected: true)
//                dictCompanyMutableObject.setValue(arrPoliciesMutableObject, forKey: "policies")
                arrCompanies.replaceObject(at: iSelectedIndex, with: dictCompanyMutableObject)
            }
        }

        self.setTotalInvoicePrice(iSelectedSection: iSelectedIndex, iSelectedRow: -1)
        tblvwInvoiceListing.reloadData()
    }
    
    func setCompanybasedPolicySelection(dictCompany:[String:Any], bSelected: Bool) -> NSMutableArray
    {
        var arrPoliciesMutableObject = NSMutableArray()
        if let arrPolicies = dictCompany["policies"] as? [Any]
        {
            arrPoliciesMutableObject = NSMutableArray(array: arrPolicies)
            for iIndexPolicy in 0..<arrPoliciesMutableObject.count
            {
                if let objPolicyDetail = arrPoliciesMutableObject[iIndexPolicy] as? [String:Any]
                {
                    let dictPolicyDetailMutableObject = NSMutableDictionary(dictionary: objPolicyDetail)
                    dictPolicyDetailMutableObject.setValue(bSelected, forKey: kkeyisPolicySelected)
                    arrPoliciesMutableObject.replaceObject(at: iIndexPolicy, with: dictPolicyDetailMutableObject)
                }
            }
        }
        return arrPoliciesMutableObject
    }
    
    func setTotalInvoicePrice(iSelectedSection: Int,iSelectedRow: Int)
    {
        if let dicCompany = arrCompanies[iSelectedSection] as? [String:Any]
        {
            if (dicCompany[kSectionCellSelected] as! Bool == true)
            {
                let amount = "\(dicCompany["amount"] ?? "")".toCurrencyFormat()
                btnTotalInvoicePrice.setTitle("AVANÇAR | \(amount)", for: .normal)
                ctHeightbtnTotalPrice.constant = 60
                btnTotalInvoicePrice.isHidden = false
            }
            else
            {
                var bPolicySelected = false
                var iAmount = 0
                if iSelectedRow == -1
                {
                    if let arrPolicies = dicCompany["policies"] as? [Any]
                    {
                        for iIndexPolicy in 0..<arrPolicies.count
                        {
                            if let objPolicyDetail = arrPolicies[iIndexPolicy] as? [String:Any]
                            {
                                if objPolicyDetail[kkeyisPolicySelected] as! Bool == true
                                {
                                    iAmount = iAmount + (objPolicyDetail["amount"] as? Int ?? 0)
                                    bPolicySelected = true
                                }
                            }
                        }
                    }
                }
                else
                {
                    if let arrPolicies = dicCompany["policies"] as? [Any]
                    {
                        for iIndexPolicy in 0..<arrPolicies.count
                        {
                            if let objPolicyDetail = arrPolicies[iIndexPolicy] as? [String:Any]
                            {
                                if objPolicyDetail[kkeyisPolicySelected] as! Bool == true
                                {
                                    bPolicySelected = true
                                    iAmount = iAmount + (objPolicyDetail["amount"] as? Int ?? 0)
                                }
                            }
                        }
                    }
                }
                
                if bPolicySelected == true
                {
                    let amount = "\(iAmount)".toCurrencyFormat()
                    btnTotalInvoicePrice.setTitle("AVANÇAR | \(amount)", for: .normal)
                    ctHeightbtnTotalPrice.constant = 60
                    btnTotalInvoicePrice.isHidden = false
                }
                else
                {
                    ctHeightbtnTotalPrice.constant = 0
                    btnTotalInvoicePrice.isHidden = true
                }
            }
        }
    }
    
    func setPolicySelection(iSelectedSection: Int,iSelectedRow: Int,bSetValue:Bool)
    {
        /*for iIndex in 0..<arrCompanies.count
        {
            if let dicCompany = arrCompanies[iIndex] as? [String:Any]
            {
                let dictCompanyMutableObject = NSMutableDictionary(dictionary: dicCompany)
                var arrPoliciesMutableObject = NSMutableArray()
                if let arrPolicies = dicCompany["policies"] as? [Any]
                {
                    arrPoliciesMutableObject = NSMutableArray(array: arrPolicies)
                    for iIndexPolicy in 0..<arrPoliciesMutableObject.count
                    {
                        if let objPolicyDetail = arrPoliciesMutableObject[iIndexPolicy] as? [String:Any]
                        {
                            let dictPolicyDetailMutableObject = NSMutableDictionary(dictionary: objPolicyDetail)
                            dictPolicyDetailMutableObject.setValue(false, forKey: kkeyisPolicySelected)
                            arrPoliciesMutableObject.replaceObject(at: iIndexPolicy, with: dictPolicyDetailMutableObject)
                        }
                    }
                }
                dictCompanyMutableObject.setValue(arrPoliciesMutableObject, forKey: "policies")
                arrCompanies.replaceObject(at: iIndex, with: dictCompanyMutableObject)
            }
        }*/
        indexSelectedCompany = iSelectedSection

        for iIndex in 0..<arrCompanies.count
        {
            if iSelectedSection == iIndex
            {
            }
            else
            {
                if let dicCompany = arrCompanies[iIndex] as? [String:Any]
                {
                    let dictCompanyMutableObject = NSMutableDictionary(dictionary: dicCompany)
                    dictCompanyMutableObject.setValue(false, forKey: kSectionCellSelected)
                    let arrPoliciesMutableObject = self.setCompanybasedPolicySelection(dictCompany: dicCompany, bSelected: false)
                    dictCompanyMutableObject.setValue(arrPoliciesMutableObject, forKey: "policies")
                    arrCompanies.replaceObject(at: iIndex, with: dictCompanyMutableObject)
                }
            }
        }

        
        if let dicCompany = arrCompanies[iSelectedSection] as? [String:Any]
        {
            let dictCompanyMutableObject = NSMutableDictionary(dictionary: dicCompany)
            var arrPoliciesMutableObject = NSMutableArray()
            if let arrPolicies = dicCompany["policies"] as? [Any]
            {
                arrPoliciesMutableObject = NSMutableArray(array: arrPolicies)
                if let objPolicyDetail = arrPoliciesMutableObject[iSelectedRow] as? [String:Any]
                {
                    let dictPolicyDetailMutableObject = NSMutableDictionary(dictionary: objPolicyDetail)
                    dictPolicyDetailMutableObject.setValue(bSetValue, forKey: kkeyisPolicySelected)
                    arrPoliciesMutableObject.replaceObject(at: iSelectedRow, with: dictPolicyDetailMutableObject)
                }
            }
            dictCompanyMutableObject.setValue(arrPoliciesMutableObject, forKey: "policies")
            arrCompanies.replaceObject(at: iSelectedSection, with: dictCompanyMutableObject)
        }

        self.setTotalInvoicePrice(iSelectedSection: iSelectedSection, iSelectedRow: iSelectedRow)
        tblvwInvoiceListing.reloadData()
    }
    
    @objc func btnClientClicked(_ sender: Any)
    {
        if(bTerceirosSelected == false)
        {
            let storyBoard = UIStoryboard(name: "InvoiceList", bundle: nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: "ClientDetailsVC") as! ClientDetailsVC
            controller.invoiceType = InvoiceType
            controller.objClientRef = objClientRef
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func gotoPaymentScreen(_ sender: UIButton)
    {
        let storyBoard = UIStoryboard(name: "DataConfirmation", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "DataConfirmationVC") as! DataConfirmationVC
        controller.InvoiceType = InvoiceType
        controller.objClientRef = self.objClientRef
        controller.objSelectedCompany = self.arrCompanies[indexSelectedCompany] as! [String : Any]
        self.navigationController?.pushViewController(controller, animated: true)
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
extension ClientWiseInvoiceListing : UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return arrCompanies.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 0
        }
        
        if let dicCompany = arrCompanies[section-1] as? [String:Any]
        {
            if let arrPolicies = dicCompany["policies"] as? [Any]
            {
              return arrPolicies.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let dicCompany = arrCompanies[indexPath.section-1] as? [String:Any]
        {
            if let arrPolicies = dicCompany["policies"] as? [Any]
            {
                if let objPolicyDetail = arrPolicies[indexPath.row] as? [String:Any]
                {
                    if (objPolicyDetail[kkeyisPolicySelected] as! Bool == true)
                    {
                        if let arrReceipts = objPolicyDetail["receipts"] as? [Any]
                        {
                            return CGFloat(85 + 100 + (arrReceipts.count * 260))
                        }
                    }
                }
            }
        }
        return 85
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return 0
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: kDataConfirmationHeaderCell) as! DataConfirmationHeaderCell
        let companyDetailCell = tableView.dequeueReusableCell(withIdentifier: kCellOfCompanyDetails) as! CompanyDetailsCellTableViewCell
        
        if section == 0
        {
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
            headerCell.btnTap.addTarget(self, action: #selector(btnClientClicked(_:)), for: .touchUpInside)
            headerCell.lblTitle.textColor = lblColor
            headerCell.lblsubTitle.text = objClientRef["name"] as? String
            
            return headerCell
        }
        else
        {
            switch InvoiceType {
            case 1: //RISCO DE ANULAÇÃO
                companyDetailCell.btnCheckBox.isHidden = false
                break
            case 2: //POR COBRAR
                companyDetailCell.btnCheckBox.isHidden = false
                break
            case 3: // COBRADOS
                companyDetailCell.btnCheckBox.isHidden = true
                break
            case 4: //General Search
                companyDetailCell.btnCheckBox.isHidden = false
                break
            default:
                break
            }
            
            if let dicCompany = arrCompanies[section-1] as? [String:Any]
            {
                companyDetailCell.lblCompanyName.text = dicCompany["company"] as? String


                companyDetailCell.lblInvoiceTotal.text = "\(String(describing: dicCompany["amount"] as! Double).toCurrencyFormat())"
                companyDetailCell.btnCheckBox.isSelected = dicCompany[kSectionCellSelected] as! Bool
            }

            companyDetailCell.btnRadioTapped = {
                
                if let dicCompany = self.arrCompanies[section-1] as? [String:Any]
                {
                    if (dicCompany[kSectionCellSelected] as! Bool == true) {
                        self.setSectionSelection(iSelectedIndex: section-1, bSetValue: false)
                    }
                    else {
                        self.setSectionSelection(iSelectedIndex: section-1, bSetValue: true)
                    }
                }
            }
            return companyDetailCell
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellForClientDetails = tableView.dequeueReusableCell(withIdentifier: kCellOfInvoiceDetails) as! InvoiceDetailsTableViewCell

        cellForClientDetails.selectionStyle = .none
        var lblColor = UIColor()
        var sideImageColor = UIColor()
        cellForClientDetails.btnExpandCollapse.isHidden = false
        
        switch InvoiceType {
        case 1: //RISCO DE ANULAÇÃO
            lblColor = AppColors.kOrangeColor
            sideImageColor = AppColors.kOrangeColorWithAlpha
            break
        case 2: //POR COBRAR
            lblColor = AppColors.kPurpulColor
            sideImageColor = AppColors.kPurpulColorWithAlpha
            break
        case 3: // COBRADOS
            lblColor = AppColors.kGreenColor
            sideImageColor = AppColors.kGreenColorWithAlpha
            break
        case 4: // General Search
            lblColor = AppColors.kGeneralSearchColor
            sideImageColor = AppColors.kGeneralSearchColorWithAlpha
            break
        default:
            break
        }
        
        if let dicCompany = arrCompanies[indexPath.section-1] as? [String:Any]
        {
            if let arrPolicies = dicCompany["policies"] as? [Any]
            {
                if let objPolicyDetail = arrPolicies[indexPath.row] as? [String:Any]
                {
                    cellForClientDetails.lblInvoiceNumber.text = (objPolicyDetail["policy"] as! String)
                    cellForClientDetails.lblPrice.text = "\(objPolicyDetail["noReceipts"] as! String) - \(String(describing: objPolicyDetail["amount"] as! Double).toCurrencyFormat())"
                    cellForClientDetails.btnExpandCollapse.isSelected = objPolicyDetail[kkeyisPolicySelected] as! Bool
                    
                    if objPolicyDetail[kkeyisPolicySelected] as! Bool == true
                    {
                        cellForClientDetails.imgLeftSelection.backgroundColor = sideImageColor
                        cellForClientDetails.bSectionSelected = true
                    }
                    else
                    {
                        if (dicCompany[kSectionCellSelected] as! Bool == true)
                        {
                            cellForClientDetails.imgLeftSelection.backgroundColor = sideImageColor
                        }
                        else
                        {
                            cellForClientDetails.imgLeftSelection.backgroundColor = UIColor.clear
                        }

                        cellForClientDetails.bSectionSelected = false
                    }
                    cellForClientDetails.objPolicyDetails = objPolicyDetail
                }
            }
        }

        
        cellForClientDetails.lblCaptionInvoiceNumber.textColor = lblColor
        cellForClientDetails.lblCaptionPrice.textColor = lblColor
        cellForClientDetails.btnExpandCollapse.addTarget(cellForClientDetails, action: #selector(cellForClientDetails.btnExpandCollapseAction(_:)), for: .touchUpInside)
        
        cellForClientDetails.btnExpandCollapseSelected = {
            
            if let dicCompany = self.arrCompanies[indexPath.section-1] as? [String:Any]
            {
                if let arrPolicies = dicCompany["policies"] as? [Any]
                {
                    if let objPolicyDetail = arrPolicies[indexPath.row] as? [String:Any]
                    {
                        if (objPolicyDetail[kkeyisPolicySelected] as! Bool == true)
                        {
                            self.setPolicySelection(iSelectedSection: indexPath.section-1, iSelectedRow: indexPath.row, bSetValue: false)
                        }
                        else
                        {
                            self.setPolicySelection(iSelectedSection: indexPath.section-1, iSelectedRow: indexPath.row, bSetValue: true)
                        }
                    }
                }
            }
        }
        cellForClientDetails.tblvwInvoices.reloadData()
        cellForClientDetails.InvoiceType = InvoiceType
        cellForClientDetails.bTerceirosSelected = bTerceirosSelected
        cellForClientDetails.objParent = self
        
        return cellForClientDetails
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

    }
}

