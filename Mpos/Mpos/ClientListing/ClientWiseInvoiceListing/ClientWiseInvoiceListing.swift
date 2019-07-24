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

    
    var selectedCompanyIndex:Int = -1
    var selectedInvoiceIndex:NSMutableArray = []

    var InvoiceType:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
            imgTopShadow.backgroundColor = AppColors.kOrangeColor
            lblTitleHeader.text = "RISCO DE ANULAÇÃO"
            lblTitleHeader.textColor = AppColors.kOrangeColor
            btnMenu.tintColor = AppColors.kOrangeColor
            btnBackArrow.tintColor = AppColors.kOrangeColor
            
            break
        case 2: //POR COBRAR
            imgTopShadow.backgroundColor = AppColors.kPurpulColor
            lblTitleHeader.text = "POR COBRAR"
            lblTitleHeader.textColor = AppColors.kPurpulColor
            btnMenu.tintColor = AppColors.kPurpulColor
            btnBackArrow.tintColor = AppColors.kPurpulColor
            
            break
        case 3: // COBRADOS
            imgTopShadow.backgroundColor = AppColors.kGreenColor
            lblTitleHeader.text = "COBRADOS"
            lblTitleHeader.textColor = AppColors.kGreenColor
            btnMenu.tintColor = AppColors.kGreenColor
            btnBackArrow.tintColor = AppColors.kGreenColor
            
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
        
        self.tblvwInvoiceListing.reloadData()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMenuClicked(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "SideMenu", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
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
            btnTotalInvoicePrice.isHidden = false
        }
        else
        {
            btnTotalInvoicePrice.isHidden = true
        }
        
        tblvwInvoiceListing.reloadData()
        
    }
    
    @objc func btnPlusBtnClicked(_ sender: UIButton) {
        
        if selectedInvoiceIndex.contains(sender.tag)
        {
            selectedInvoiceIndex.remove(sender.tag)
        }
        else
        {
            selectedInvoiceIndex.add(sender.tag)

        }
       
        if selectedInvoiceIndex.count > 0
        {
            btnTotalInvoicePrice.isHidden = false
        }
        else
        {
            btnTotalInvoicePrice.isHidden = true
        }
        
        tblvwInvoiceListing.reloadData()
        
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selectedInvoiceIndex.contains(indexPath.row)
        {
            return 85 + (2 * 260)
        }
        
        return 85
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let companyDetailCell = tableView.dequeueReusableCell(withIdentifier: kCellOfCompanyDetails) as! CompanyDetailsCellTableViewCell
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
        return companyDetailCell
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
            cellForClientDetails.btnExpandCollapse.isHidden = true

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
        if selectedInvoiceIndex.contains(indexPath.row)
        {
            cellForClientDetails.btnExpandCollapse.isSelected = true
        }
        else
        {
            cellForClientDetails.btnExpandCollapse.isSelected = false
        }
        cellForClientDetails.InvoiceType = InvoiceType
        return cellForClientDetails
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

    }
}

