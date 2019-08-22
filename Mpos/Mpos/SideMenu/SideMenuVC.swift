//
//  SideMenuVC.swift
//  Mpos
//
//  Created by Kevin on 18/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController
{
    @IBOutlet weak var tblSideMenu: UITableView!
    var arrRows = NSMutableArray()
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.tblSideMenu.estimatedSectionHeaderHeight = 80
        self.tblSideMenu.estimatedRowHeight = 80
        self.tblSideMenu.estimatedSectionHeaderHeight = UITableView.automaticDimension
        self.tblSideMenu.rowHeight = UITableView.automaticDimension
        
        let arrData = UserDefaultManager.SharedInstance.getArrayData(strKeyName: "SidebarData")
        arrRows = arrData ?? NSMutableArray()

        self.tblSideMenu.reloadData()
        // Do any additional setup after loading the view.
    }
    
    //MARK: User Actions
    @IBAction func goBackTapped(_ sender: UIButton)
    {
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: User Actions
    @IBAction func searchTapped(_ sender: UIButton)
    {
        let storyBoard = UIStoryboard(name: "Search", bundle: nil)
        let searchVC = storyBoard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    //MARK: User Actions
    @IBAction func logoutBtnClicked(_ sender: UIButton)
    {
        let storyBoard = UIStoryboard(name: "SideMenu", bundle: nil)
        let logoutvc = storyBoard.instantiateViewController(withIdentifier: "LogoutVC") as! LogoutVC
        self.navigationController?.pushViewController(logoutvc, animated: true)
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
extension SideMenuVC: UITableViewDataSource,UITableViewDelegate
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
        return 170
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrRows.count+2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "SideMenuHeaderTableViewCell") as! SideMenuHeaderTableViewCell
       
        if let dictagentContext = UserDefaultManager.SharedInstance.getLoggedUser()
        {
            headerCell.lblAgentName.text = "\(dictagentContext["name"] ?? "")"
            headerCell.lblAgentTitle.text = "ASF: \(dictagentContext["id"] ?? "")"
            headerCell.lblAgentNumber.text = "\(dictagentContext["agent"] ?? "")"
        }
        return headerCell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuContentTableViewCell", for: indexPath) as! SideMenuContentTableViewCell
        
            if indexPath.row > 2
            {
                cell.imgIcon.image = UIImage(named:"ic_terms")
                cell.lblTitle.font = UIFont(name: "Ubuntu", size: 14.0)
                cell.lblTitle.textColor = UIColor(red: 177.0/255.0, green: 177.0/255.0, blue: 177.0/255.0, alpha: 1.0)
            }
            else
            {
                switch(indexPath.row)
                {
                case 0:
                    cell.lblTitle.textColor = AppColors.kOrangeColor
                    cell.imgIcon.image = UIImage(named:"ic_Category1")
                    break
                    
                case 1:
                    cell.lblTitle.textColor = AppColors.kPurpulColor
                    cell.imgIcon.image = UIImage(named:"ic_Category2")
                    break
                    
                case 2:
                    cell.lblTitle.textColor = AppColors.kGreenColor
                    cell.imgIcon.image = UIImage(named:"ic_Category3")
                    break
                    
                default:
                    break
                }
                cell.lblTitle.font = UIFont(name: "Ubuntu-Bold", size: 14.0)
            }
            
            switch(indexPath.row)
            {
            case 0...2:
                if let dicData = arrRows[indexPath.row] as? [String:AnyObject]
                {
                    cell.lblTitle.text = (dicData["type"] as? String)?.uppercased()
                }
            case 3:
                cell.lblTitle.text = "POLÍTICA DE PRIVACIDADE"
                break
                
            case 4:
                cell.lblTitle.text = "TERMOS E CONDIÇÕES"
                break
                
            default:
                break
            }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if UITableView.automaticDimension < 40
        {
            return 60
        }
        else
        {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if UITableView.automaticDimension < 170
        {
            return 170
        }
         return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.navigationController?.popViewController(animated: true)

        /*
         The navigation keeps stacking the screens when the user changes the invoice type (KPI) from the side menu
         - The correct behaviour is: whenever the user changes the context (e.g. from POR COBRAR to COBRADOS), the stack resets and starts from the home screen
         */
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
        let navController = UINavigationController(rootViewController: controller)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController

        if indexPath.row < 3
        {
            let storyBoard = UIStoryboard(name: "InvoiceList", bundle: nil)
            let invoiceListingVC = storyBoard.instantiateViewController(withIdentifier: "InvoiceListingVC") as! InvoiceListingVC
            invoiceListingVC.InvoiceType = indexPath.row + 1
            if let dicData = arrRows[indexPath.row] as? [String:Any]
            {
                invoiceListingVC.StrType = ((dicData["type"] as? String)!)
            }
            navController.pushViewController(invoiceListingVC, animated: true)
        }
    }
}
