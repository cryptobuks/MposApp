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
    let arrRows = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.tblSideMenu.estimatedSectionHeaderHeight = 80
        self.tblSideMenu.estimatedRowHeight = 80
        self.tblSideMenu.estimatedSectionHeaderHeight = UITableView.automaticDimension
        self.tblSideMenu.rowHeight = UITableView.automaticDimension
        
        var dictTemp = ["imgIcon":"ic_Category1","Title":"RISCO DE ANULAÇÃO"]
        arrRows.add(dictTemp)
        
        dictTemp = ["imgIcon":"ic_Category2","Title":"POR COBRAR"]
        arrRows.add(dictTemp)
        
        dictTemp = ["imgIcon":"ic_Category3","Title":"COBRADOS"]
        arrRows.add(dictTemp)
        
        dictTemp = ["imgIcon":"ic_terms","Title":"POLÍTICA DE PRIVACIDADE"]
        arrRows.add(dictTemp)

        dictTemp = ["imgIcon":"ic_terms","Title":"TERMOS E CONDIÇÕES"]
        arrRows.add(dictTemp)

        self.tblSideMenu.reloadData()
        // Do any additional setup after loading the view.
    }
    
    //MARK: User Actions
    @IBAction func goBackTapped(_ sender: UIButton)
    {
       self.navigationController?.popViewController(animated: true)
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
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrRows.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "SideMenuHeaderTableViewCell") as! SideMenuHeaderTableViewCell
        return headerCell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuContentTableViewCell", for: indexPath) as! SideMenuContentTableViewCell
        
        if let dicData = arrRows[indexPath.row] as? [String:AnyObject]
        {
            cell.imgIcon.image = UIImage(named: dicData["imgIcon"] as! String)
            cell.lblTitle.text = dicData["Title"] as? String
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if UITableView.automaticDimension < 40
        {
            return 40
        }
        else
        {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return UITableView.automaticDimension
    }
}
