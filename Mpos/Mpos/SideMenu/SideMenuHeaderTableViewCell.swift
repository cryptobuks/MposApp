//
//  SideMenuHeaderTableViewCell.swift
//  Mpos
//
//  Created by Kevin on 19/07/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class SideMenuHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblAgentTitle: UILabel!
    @IBOutlet weak var lblAgentName: UILabel!
    @IBOutlet weak var lblAgentNumber: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnChangeAgentDropDownAction(_ sender: UIButton)
    {
//        let arrtemp = ["256","257","258","259","260","261","262","263","264","265"]
//        ActionSheetStringPicker.show(withTitle: "", rows: arrtemp as [Any], initialSelection: 0, doneBlock:
//            {
//                picker, value, index in
//                self.lblAgentNumber.text = (index as? String ?? "")
//                return
//        }, cancel: { ActionStringCancelBlock in return }, origin: sender)

        MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: true, url: "5d3b10293000005f00a29f77", parameter: nil, success: { (response) in
            print(response)
            
            if let agentList = response["agentList"] as? NSArray
            {
                let arrListofAgents = NSMutableArray(array: agentList)
                
                var arrtemp = [Any]()
                for index in 0..<arrListofAgents.count
                {
                    let dictTemp = arrListofAgents[index] as! [String:Any]
                    arrtemp.append("\(dictTemp["id"] ?? "") - \(dictTemp["name"] ?? "")")
                }
                
                ActionSheetStringPicker.show(withTitle: "", rows: arrtemp , initialSelection: 0, doneBlock:
                    {
                        picker, value, index in
                        
                        let dictTemp = arrListofAgents[value] as! [String:Any]
                        self.lblAgentNumber.text = ("\(dictTemp["id"] ?? "")")
                        if let dictagentContext = UserDefaultManager.SharedInstance.getLoggedUser()
                        {
                            let dictUserObject = NSMutableDictionary(dictionary: dictagentContext)
                            dictUserObject.setValue(dictTemp["id"], forKey: "agent")
                            UserDefaultManager.SharedInstance.saveLoggedUser(dict: dictUserObject as! [String : Any])
                        }
                        return
                }, cancel: { ActionStringCancelBlock in return }, origin: sender)
            }
        })
        { (responseError) in
            print(responseError)
        }
    }

}
