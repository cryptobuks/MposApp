//
//  DashboardVC.swift
//  Mpos
//
//  Created by Yash on 20/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController
{
    @IBOutlet weak var tblCategoryList: UITableView!
    let arrRows = NSMutableArray()
    @IBOutlet weak var lblAgentCode: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tblCategoryList.estimatedRowHeight = 80
        self.tblCategoryList.rowHeight = UITableView.automaticDimension
        
        var dictTemp = ["Title":"RISCO DE ANULAÇÃO","Count":"10","Price":"600€","Color":AppColors.kOrangeColor] as [String : Any]
        arrRows.add(dictTemp)
        
        dictTemp = ["Title":"POR COBRAR","Count":"123","Price":"4.532€","Color":AppColors.kPurpulColor]
        arrRows.add(dictTemp)
        
        dictTemp = ["Title":"COBRADOS","Count":"2","Price":"396€","Color":AppColors.kGreenColor]
        arrRows.add(dictTemp)
        
        self.tblCategoryList.reloadData()
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
    
    @IBAction func openSearch(_ sender: UIButton)
    {
        let storyBoard = UIStoryboard(name: "Search", bundle: nil)
        let searchVC = storyBoard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction func btnChangeAgentDropDownAction(_ sender: UIButton)
    {
        let arrtemp = ["256","257","258","259","260","261","262","263","264","265"]
        ActionSheetStringPicker.show(withTitle: "", rows: arrtemp as [Any], initialSelection: 0, doneBlock:
            {
                picker, value, index in
                self.lblAgentCode.text = (index as? String ?? "")
                return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
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
extension DashboardVC: UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryListTableViewCell", for: indexPath) as! CategoryListTableViewCell
        
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 4

        cell.selectionStyle  = .none
        
        if let dicData = arrRows[indexPath.row] as? [String:Any]
        {
            cell.lblCategoryName.text = dicData["Title"] as? String
            cell.imgCategoryColor.backgroundColor = dicData["Color"] as? UIColor
            cell.lblCount.textColor = dicData["Color"] as? UIColor
            cell.lblCount.text = dicData["Count"] as? String
            cell.lblPrice.text = dicData["Price"] as? String
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "InvoiceList", bundle: nil)
        let invoiceListingVC = storyBoard.instantiateViewController(withIdentifier: "InvoiceListingVC") as! InvoiceListingVC
        invoiceListingVC.InvoiceType = indexPath.row + 1
        self.navigationController?.pushViewController(invoiceListingVC, animated: true)
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        let storyBoard = UIStoryboard(name: "PaymentMode", bundle: nil)
//        let controller = storyBoard.instantiateViewController(withIdentifier: "PaymentMethodListVC") as! PaymentMethodListVC
//        if let dicData = arrRows[indexPath.row] as? [String:Any]
//        {
//            controller.selectedCategoryColor = (dicData["Color"] as? UIColor)!
//        }
//        self.navigationController?.pushViewController(controller, animated: true)
//    }
  
}
