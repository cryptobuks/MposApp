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
    var selectedCategoryColor = UIColor()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btnBack.tintColor = selectedCategoryColor
        btnSidebar.tintColor = selectedCategoryColor
        lblTitle.textColor = selectedCategoryColor

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
        controller.selectedCategoryColor = selectedCategoryColor
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
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = UITableViewCell()
        switch indexPath.row
        {
        case 0:
            let cellListwithLogoCell = tableView.dequeueReusableCell(withIdentifier: kDataConfirmataionListwithLogoCell, for: indexPath) as! DataConfirmataionListwithLogoCell
            cell = cellListwithLogoCell
            break
        case 1...2:
            let cellListwithLogoCell = tableView.dequeueReusableCell(withIdentifier: kDataConfirmationNormalListCell, for: indexPath) as! DataConfirmationNormalListCell
            cell = cellListwithLogoCell
            break
        case 3:
            let cellListwithLogoCell = tableView.dequeueReusableCell(withIdentifier: "DataConfirmationDropDownCell", for: indexPath) as! DataConfirmationDropDownCell
            cellListwithLogoCell.lblTitle.textColor = selectedCategoryColor
            cellListwithLogoCell.btnDropDownTapped =
                { text in
                 
                    cellListwithLogoCell.btnDropDown.setTitle(text, for: .normal)
                    self.btnConfirm.isHidden = false
            }
            
            cell = cellListwithLogoCell
            break
        default:
            break
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return UITableView.automaticDimension
    }
}
