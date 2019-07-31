//
//  DataConfirmationVC.swift
//  Mpos
//
//  Created by Yash on 22/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class DataConfirmationVC: UIViewController
{
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSidebar: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblvwDataConfirmation: UITableView!
    @IBOutlet weak var btnConfirm: UIButton!

    //Declare Variables
    var InvoiceType:Int = 0
    var lblColor = UIColor()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
        case 4: // General Search
            lblColor = AppColors.kGeneralSearchColor
            break
        default:
            break
        }
        
        btnBack.tintColor = lblColor
        btnSidebar.tintColor = lblColor
        lblTitle.textColor = lblColor

        self.tblvwDataConfirmation.estimatedSectionHeaderHeight = 80
        self.tblvwDataConfirmation.estimatedRowHeight = 80
        self.tblvwDataConfirmation.estimatedSectionHeaderHeight = UITableView.automaticDimension
        self.tblvwDataConfirmation.rowHeight = UITableView.automaticDimension
        self.tblvwDataConfirmation.tableFooterView = UIView(frame: .zero)

        // Do any additional setup after loading the view.
        self.tblvwDataConfirmation.register(UINib(nibName: kDataConfirmationHeaderCell, bundle: nil), forCellReuseIdentifier: kDataConfirmationHeaderCell)
        
        self.tblvwDataConfirmation.register(UINib(nibName: kDataConfirmataionListwithLogoCell, bundle: nil), forCellReuseIdentifier: kDataConfirmataionListwithLogoCell)

        self.tblvwDataConfirmation.register(UINib(nibName: kDataConfirmationNormalListCell, bundle: nil), forCellReuseIdentifier: kDataConfirmationNormalListCell)
    }
    
    @IBAction func goBackTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func gotoPaymentScreen(_ sender: UIButton)
    {
        let storyBoard = UIStoryboard(name: "PaymentMode", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "PaymentMethodListVC") as! PaymentMethodListVC
        controller.InvoiceType = InvoiceType
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func btnClientClicked(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "InvoiceList", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ClientDetailsVC") as! ClientDetailsVC
        controller.invoiceType = InvoiceType
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: User Actions
    @IBAction func openSidebar(_ sender: UIButton)
    {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension DataConfirmationVC: UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: kDataConfirmationHeaderCell) as! DataConfirmationHeaderCell
        
        headerCell.btnTap.addTarget(self, action: #selector(btnClientClicked(_:)), for: .touchUpInside)
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
        case 4: // General Search
            lblColor = AppColors.kGeneralSearchColor
            break
        default:
            break
        }
        headerCell.lblTitle.textColor = lblColor
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = UITableViewCell()
        switch indexPath.row
        {
        case 0:
            let cellListwithLogoCell = tableView.dequeueReusableCell(withIdentifier: kDataConfirmataionListwithLogoCell, for: indexPath) as! DataConfirmataionListwithLogoCell
            cellListwithLogoCell.lblTitle.textColor = lblColor
            cell = cellListwithLogoCell
            break
        case 1...2:
            let cellListwithLogoCell = tableView.dequeueReusableCell(withIdentifier: kDataConfirmationNormalListCell, for: indexPath) as! DataConfirmationNormalListCell
            cellListwithLogoCell.lblTitleHeader.textColor = lblColor
            cellListwithLogoCell.lblPriceHeader.textColor = lblColor
            cell = cellListwithLogoCell
            break
        case 3:
            let cellListwithLogoCell = tableView.dequeueReusableCell(withIdentifier: "DataConfirmationDropDownCell", for: indexPath) as! DataConfirmationDropDownCell
            cellListwithLogoCell.lblTitle.textColor = lblColor
            cellListwithLogoCell.btnDropDownTapped =
                { text in
                 
                    cellListwithLogoCell.btnDropDown.setTitle(text, for: .normal)
                    cellListwithLogoCell.btnDropDown.isHidden = true
                    cellListwithLogoCell.imgDropDown.isHidden = true
                    cellListwithLogoCell.ctHeightbtnDropDown.constant = 0
                    self.tblvwDataConfirmation.reloadData()
                    self.btnConfirm.isHidden = false
            }
            
            cell = cellListwithLogoCell
            break
        default:
            break
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 3
        {
            return UITableView.automaticDimension
        }
        return 85
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 60
    }
}