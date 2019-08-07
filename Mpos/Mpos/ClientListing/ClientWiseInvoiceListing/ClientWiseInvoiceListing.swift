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
    
    var selectedCompanyIndex:Int = -1
    var selectedInvoiceIndex = NSMutableArray()

    var InvoiceType:Int = 0
    var objClientRef = [String:Any]()
    
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
            self.tblvwInvoiceListing.reloadData()
            self.refreshControl.endRefreshing()
            
        })
        { (responseError) in
            print(responseError)
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
    
    @objc func btnRadioBtnClicked(_ sender: UIButton) {

        if sender.tag == selectedCompanyIndex{
            selectedCompanyIndex = -1
        }
        else
        {
            selectedCompanyIndex = sender.tag
        }
        
        if selectedCompanyIndex > -1
        {
            ctHeightbtnTotalPrice.constant = 60
            btnTotalInvoicePrice.isHidden = false
        }
        else
        {
            ctHeightbtnTotalPrice.constant = 0
            btnTotalInvoicePrice.isHidden = true
        }
        
        if let dicCompany = arrCompanies[sender.tag-1] as? [String:Any]
        {
            btnTotalInvoicePrice.setTitle("AVANÇAR | \(dicCompany["amount"] as? Int ?? 0)€", for: .normal)

        }
        tblvwInvoiceListing.reloadData()
        
    }
    
    @objc func btnPlusBtnClicked(_ sender: UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:tblvwInvoiceListing)
        let indexPath = self.tblvwInvoiceListing.indexPathForRow(at: buttonPosition)
        
        
        if selectedInvoiceIndex.contains(indexPath!)
        {
            selectedInvoiceIndex.remove(indexPath!)
        }
        else
        {
            selectedInvoiceIndex.add(indexPath!)

        }
       
//        if selectedInvoiceIndex.count > 0
//        {
//            ctHeightbtnTotalPrice.constant = 60
//            btnTotalInvoicePrice.isHidden = false
//        }
//        else
//        {
//            ctHeightbtnTotalPrice.constant = 0
//            btnTotalInvoicePrice.isHidden = true
//        }
//        
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
extension ClientWiseInvoiceListing : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrCompanies.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        if selectedInvoiceIndex.contains(indexPath)
        {
            if let dicCompany = arrCompanies[indexPath.section-1] as? [String:Any]
            {
                if let arrPolicies = dicCompany["policies"] as? [Any]
                {
                    return CGFloat(85 + 100 + (arrPolicies.count * 260))
                }
            }
        }
        return 85
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 0
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return UITableView.automaticDimension
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
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
            
            companyDetailCell.btnCheckBox.tag = section
            companyDetailCell.btnCheckBox.addTarget(self, action: #selector(btnRadioBtnClicked(_:)), for: .touchUpInside)
            
            if section == selectedCompanyIndex
            {
                companyDetailCell.btnCheckBox.isSelected = true
            }
            else
            {
                companyDetailCell.btnCheckBox.isSelected = false
            }
            
            if let dicCompany = arrCompanies[section-1] as? [String:Any]
            {
                companyDetailCell.lblCompanyName.text = dicCompany["company"] as? String
                companyDetailCell.lblInvoiceTotal.text = "\(dicCompany["amount"] as? Int ?? 0)€"
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
        
        if indexPath.section == selectedCompanyIndex{
            cellForClientDetails.imgLeftSelection.backgroundColor = sideImageColor
        }
        else{
            cellForClientDetails.imgLeftSelection.backgroundColor = UIColor.clear

        }
        cellForClientDetails.lblCaptionInvoiceNumber.textColor = lblColor
        cellForClientDetails.lblCaptionPrice.textColor = lblColor
        
        cellForClientDetails.btnExpandCollapse.tag = indexPath.row
        cellForClientDetails.btnExpandCollapse.addTarget(self, action: #selector(btnPlusBtnClicked(_:)), for: .touchUpInside)
        
        if selectedInvoiceIndex.contains(indexPath)
        {
            cellForClientDetails.btnExpandCollapse.isSelected = true
        }
        else
        {
            cellForClientDetails.btnExpandCollapse.isSelected = false
        }
        
        if selectedCompanyIndex == indexPath.section
        {
            cellForClientDetails.bSectionSelected = true
        }
        else
        {
            cellForClientDetails.bSectionSelected = false
        }

        cellForClientDetails.tblvwInvoices.reloadData()
        cellForClientDetails.InvoiceType = InvoiceType
        cellForClientDetails.bTerceirosSelected = bTerceirosSelected
        cellForClientDetails.objParent = self
        
        if let dicCompany = arrCompanies[indexPath.section-1] as? [String:Any]
        {
            if let arrPolicies = dicCompany["policies"] as? [Any]
            {
                if let objPolicyDetail = arrPolicies[indexPath.row] as? [String:Any]
                {
                    cellForClientDetails.lblInvoiceNumber.text = (objPolicyDetail["policy"] as! String)
                    cellForClientDetails.lblPrice.text = "\(objPolicyDetail["noReceipts"] as! String) - \(objPolicyDetail["amount"] as! Int)"
                    cellForClientDetails.objPolicyDetails = objPolicyDetail
                }
            }
        }
        return cellForClientDetails
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

    }
}

