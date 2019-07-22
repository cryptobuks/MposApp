//
//  InvoiceListingVC.swift
//  Mpos
//
//  Created by kaushal panchal on 19/07/19.
//  Copyright © 2019 k_p. All rights reserved.
//

import UIKit

class InvoiceListingVC: UIViewController {

    @IBOutlet weak var tblvwInvoiceListing: UITableView!
    @IBOutlet weak var imgTopShadow: UIImageView!
    @IBOutlet weak var lblSearchHeader: UILabel!
    @IBOutlet weak var lblTitleHeader: UILabel!

    @IBOutlet weak var txtfdSearch: UITextField!
    @IBOutlet weak var scrvw_Height_Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnBackArrow: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var vwHeader: UIView!

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
            lblSearchHeader.textColor = AppColors.kOrangeColor
            lblSearchHeader.text = "FILTRAR RISCO DE ANULAÇÃO"
            lblTitleHeader.text = "RISCO DE ANULAÇÃO"
            lblTitleHeader.textColor = AppColors.kOrangeColor
            btnMenu.tintColor = AppColors.kOrangeColor
            btnBackArrow.tintColor = AppColors.kOrangeColor

            break
        case 2: //POR COBRAR
            imgTopShadow.backgroundColor = AppColors.kPurpulColor
            lblSearchHeader.textColor = AppColors.kPurpulColor
            lblSearchHeader.text = "FILTRAR POR COBRAR"
            lblTitleHeader.text = "POR COBRAR"
            lblTitleHeader.textColor = AppColors.kPurpulColor
            btnMenu.tintColor = AppColors.kPurpulColor
            btnBackArrow.tintColor = AppColors.kPurpulColor

            break
        case 3: // COBRADOS
            imgTopShadow.backgroundColor = AppColors.kGreenColor
            lblSearchHeader.textColor = AppColors.kGreenColor
            lblSearchHeader.text = "FILTRAR COBRADOS"
            lblTitleHeader.text = "COBRADOS"
            lblTitleHeader.textColor = AppColors.kGreenColor
            btnMenu.tintColor = AppColors.kGreenColor
            btnBackArrow.tintColor = AppColors.kGreenColor

            break
        default:
            break
        }
        
        self.tblvwInvoiceListing.register(UINib(nibName: kCellOfClientListing, bundle: nil), forCellReuseIdentifier: kCellOfClientListing)
        
        self.tblvwInvoiceListing.estimatedRowHeight = 150.0
        self.tblvwInvoiceListing.rowHeight = UITableView.automaticDimension

        self.tblvwInvoiceListing.reloadData()
        scrvw_Height_Constraint.constant = (self.tblvwInvoiceListing.contentSize.height + 100)
    }

    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMenuClicked(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "SideMenu", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
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
extension InvoiceListingVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellForClientDetails = tableView.dequeueReusableCell(withIdentifier: kCellOfClientListing) as! ClientDetailCell
        
        cellForClientDetails.selectionStyle = .none
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
        
        cellForClientDetails.lblCaptionClientName.textColor = lblColor
        cellForClientDetails.lblCaptionNIF.textColor = lblColor
        cellForClientDetails.lblCaptionRECIBOS.textColor = lblColor
        
        return cellForClientDetails
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
