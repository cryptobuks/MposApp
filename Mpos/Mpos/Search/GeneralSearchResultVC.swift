//
//  GeneralSearchResultVC.swift
//  Mpos
//
//  Created by Yash on 24/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

/*
 Class Purpose: Screen 4, Screen 4.1, Screen 4.2, Screen 4.3 | General search results | (Mpos_resultado, Mpos_resultado_1 and Mpos_pesquisa_1-2 in the attached Adobe XD file)
 The general search results screens essentially present invoices grouped by company (“Companhia”), policy (“Apólice”) and client (“Cliente”). The presentation / grouping hierarchy in this screen is absolutely critical for ensuring the correct behaviour of the application. Moreover, this presentation depends on the search criteria used. Therefore, we present below the three screens which can be returned as a result of a search when the “Meus” radio button is selected. These are represented in figures, 7, 8 and 9, and are as follows:
 */

import UIKit

class GeneralSearchResultVC: UIViewController
{
    @IBOutlet weak var tblvwInvoiceListing: UITableView!
    @IBOutlet weak var imgTopShadow: UIImageView!
    @IBOutlet weak var lblTitleHeader: UILabel!
    
    @IBOutlet weak var btnBackArrow: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var vwHeader: UIView!
    
    @IBOutlet weak var lblClientTitle: UILabel!
    @IBOutlet weak var lblClientName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.setupUIBasedOnInvoiceType()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setupUIBasedOnInvoiceType() {
        
        vwHeader.layer.masksToBounds = false
        vwHeader.layer.shadowRadius = 4
        vwHeader.layer.shadowOpacity = 1
        vwHeader.layer.shadowColor = UIColor.gray.cgColor
        vwHeader.layer.shadowOffset = CGSize(width: 0 , height:2)
        btnBackArrow.setImage(btnBackArrow.imageView?.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        btnMenu.setImage(btnMenu.imageView?.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        
        imgTopShadow.backgroundColor = AppColors.kGeneralSearchColor
        lblTitleHeader.text = "RISCO DE ANULAÇÃO"
        lblTitleHeader.textColor = AppColors.kGeneralSearchColor
        btnMenu.tintColor = AppColors.kGeneralSearchColor
        btnBackArrow.tintColor = AppColors.kGeneralSearchColor
        lblClientTitle.textColor = AppColors.kGeneralSearchColor
        
        self.tblvwInvoiceListing.register(UINib(nibName: kCellOfCompanyDetails, bundle: nil), forCellReuseIdentifier: kCellOfCompanyDetails)
        self.tblvwInvoiceListing.register(UINib(nibName: kCellOfInvoiceDetails, bundle: nil), forCellReuseIdentifier: kCellOfInvoiceDetails)
        
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
    @IBAction func btnRadioBtnClicked(_ sender: UIButton) {
        
        if sender.isSelected
        {
            sender.isSelected = false
        }
        else
        {
            sender.isSelected = true
        }
    }
    
    @IBAction func btnClientClicked(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "InvoiceList", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ClientDetailsVC") as! ClientDetailsVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnConfirmClicked(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "DataConfirmation", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "DataConfirmationVC") as! DataConfirmationVC
        controller.selectedCategoryColor = AppColors.kGeneralSearchColor
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
extension GeneralSearchResultVC : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let companyDetailCell = tableView.dequeueReusableCell(withIdentifier: kCellOfCompanyDetails) as! CompanyDetailsCellTableViewCell
        companyDetailCell.btnCheckBox.isHidden = false
        companyDetailCell.btnCheckBox.addTarget(self, action: #selector(btnRadioBtnClicked(_:)), for: .touchUpInside)
        return companyDetailCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellForClientDetails = tableView.dequeueReusableCell(withIdentifier: kCellOfInvoiceDetails) as! InvoiceDetailsTableViewCell
        
        cellForClientDetails.selectionStyle = .none
        var lblColor = UIColor()
        lblColor = AppColors.kGeneralSearchColor
        cellForClientDetails.imgLeftSelection.backgroundColor = AppColors.kGeneralSearchColor
        cellForClientDetails.btnExpandCollapse.isHidden = false
        
        cellForClientDetails.lblCaptionInvoiceNumber.textColor = lblColor
        cellForClientDetails.lblCaptionPrice.textColor = lblColor
        
        return cellForClientDetails
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
}
