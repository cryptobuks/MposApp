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
    @IBOutlet weak var lblAgentName: UILabel!
    @IBOutlet weak var lblAgentID: UILabel!
    var categoryColor = UIColor()
    var dictNotificationobject = [String:Any]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let dictagentContext = UserDefaultManager.SharedInstance.getLoggedUser()
        {
            lblAgentName.text = "\(dictagentContext["name"] ?? "")"
            lblAgentID.text = "ASF: \(dictagentContext["id"] ?? "")"
            lblAgentCode.text = "\(dictagentContext["agent"] ?? "")"
        }
        
        //Call KPI api is called to fill up the three main buttons (KPIs) in the home screen
        self.tblCategoryList.estimatedRowHeight = 80
        self.tblCategoryList.rowHeight = UITableView.automaticDimension
        
        self.getKPI()
    }
    
    func getKPI()
    {
        MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: true, url: "5d3b10593000008800a29f78", parameter: nil, success: { (response) in
            print(response)
            
            if let arrKPIList = response["kpiList"] as? NSArray
            {
                self.dictNotificationobject = arrKPIList.lastObject as! [String : Any]
                for index in 0..<arrKPIList.count-1
                {
                    self.arrRows.add(arrKPIList[index])
                    self.tblCategoryList.reloadData()
                }
            }
        })
        { (responseError) in
            print(responseError)
        }
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
            cell.lblCategoryName.text = dicData["type"] as? String
            
            switch indexPath.row
            {
            case 0:
                cell.imgCategoryColor.backgroundColor = AppColors.kOrangeColor
                cell.lblCount.textColor = AppColors.kOrangeColor
                break
            case 1:
                cell.imgCategoryColor.backgroundColor = AppColors.kPurpulColor
                cell.lblCount.textColor = AppColors.kPurpulColor
                break
            case 2:
                cell.imgCategoryColor.backgroundColor = AppColors.kGreenColor
                cell.lblCount.textColor = AppColors.kGreenColor
                break
            default:
                cell.imgCategoryColor.backgroundColor = AppColors.kOrangeColor
                cell.lblCount.textColor = AppColors.kOrangeColor
                break
            }
            
            cell.lblCount.text =  "\(dicData["quantity"] ?? "")"
            cell.lblPrice.text = "\(dicData["amount"] ?? "")€"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "InvoiceList", bundle: nil)
        let invoiceListingVC = storyBoard.instantiateViewController(withIdentifier: "InvoiceListingVC") as! InvoiceListingVC
        invoiceListingVC.InvoiceType = indexPath.row + 1
        self.navigationController?.pushViewController(invoiceListingVC, animated: true)
    }
  
}
