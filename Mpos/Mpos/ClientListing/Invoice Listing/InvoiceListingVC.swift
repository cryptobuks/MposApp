//
//  InvoiceListingVC.swift
//  Mpos
//
//  Created by kaushal panchal on 19/07/19.
//  Copyright © 2019 k_p. All rights reserved.
//
/*
 As outlined above, there are three main buttons in the Home Page screen: “RISCO DE ANULAÇÃO”, “POR COBRAR”, and “COBRADOS”. Pressing each of these will direct the user to a specific screen:
 1. If users press the “RISCO DE ANULAÇÃO” button in the Home Page screen they will be directed to the “Mpos_Lista_Risco de anulacao” screen. This action will invoke web service WS006;
 2. If users press the “POR COBRAR” button in the Home Page screen they will be directed to the “Mpos_por_cobrar” screen. This action will invoke web service WS006;
 3. If users press the “COBRADOS” button in the Home Page screen they will be directed to the “Mpos_Cobrados” screen. This action will invoke web service WS006;
 
 Each of these screens is illustrated below, in figures 17, 18 and 19. Each of the screens presents a lateral menu and “go back” arrow in the top left corner of the screen and a standard text title in the top center. Below the title, each screen presents a standard heading which reads “FILTRAR EM RISCO DE ANULAÇÃO”, “FILTRAR POR COBRAR”, “FILTRAR COBRADOS”. Under each of these headings there is a data input bar which should prompt the native keyboard function on the device. Pressing the magnifying glass or “Return” in the native keyboard will call web services WS007 and WS006 and will result in a filtering of the boxes presented underneath this filter bar according to the filtering criteria inserted by the user. It is worth noting that this filter bar has pre-populated, indicative text stating “Filtrar por : NIF, recibo, apólice”. This pre-populated text should vanish once users press the filter bar.
 */
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

    var arrClientRefs = NSMutableArray()
    var InvoiceType:Int = 0
    var StrType : String = ""
    
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setupUIBasedOnInvoiceType()
        callSumClientsReceipts(type: StrType)
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
        
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tblvwInvoiceListing.refreshControl = refreshControl
        } else {
            tblvwInvoiceListing.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        
        switch InvoiceType {
        case 1: //RISCO DE ANULAÇÃO
            imgTopShadow.backgroundColor = AppColors.kOrangeColorWithAlpha
            lblSearchHeader.textColor = AppColors.kOrangeColor
            lblSearchHeader.text = "FILTRAR RISCO DE ANULAÇÃO"
            lblTitleHeader.text = "RISCO DE ANULAÇÃO"
            lblTitleHeader.textColor = AppColors.kOrangeColor
            btnMenu.tintColor = AppColors.kOrangeColor
            btnBackArrow.tintColor = AppColors.kOrangeColor
            refreshControl.tintColor = AppColors.kOrangeColor

            break
        case 2: //POR COBRAR
            imgTopShadow.backgroundColor = AppColors.kPurpulColorWithAlpha
            lblSearchHeader.textColor = AppColors.kPurpulColor
            lblSearchHeader.text = "FILTRAR POR COBRAR"
            lblTitleHeader.text = "POR COBRAR"
            lblTitleHeader.textColor = AppColors.kPurpulColor
            btnMenu.tintColor = AppColors.kPurpulColor
            btnBackArrow.tintColor = AppColors.kPurpulColor
            refreshControl.tintColor = AppColors.kPurpulColor
            break
        case 3: // COBRADOS
            imgTopShadow.backgroundColor = AppColors.kGreenColorWithAlpha
            lblSearchHeader.textColor = AppColors.kGreenColor
            lblSearchHeader.text = "FILTRAR COBRADOS"
            lblTitleHeader.text = "COBRADOS"
            lblTitleHeader.textColor = AppColors.kGreenColor
            btnMenu.tintColor = AppColors.kGreenColor
            btnBackArrow.tintColor = AppColors.kGreenColor
            refreshControl.tintColor = AppColors.kGreenColor


            break
        default:
            break
        }
        
        self.tblvwInvoiceListing.register(UINib(nibName: kCellOfClientListing, bundle: nil), forCellReuseIdentifier: kCellOfClientListing)
        
        self.tblvwInvoiceListing.estimatedRowHeight = 150.0
        self.tblvwInvoiceListing.rowHeight = UITableView.automaticDimension

    }
   
    @objc func pullToRefresh(){
        self.callSumClientsReceipts(type: StrType)
    }
    
    // MARK: SumClientsReceipts API CALL
    func callSumClientsReceipts(type:String){
        let params = ["type":type]
        //Call SumClientsReceipts Service
        MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: true, url: "5d3b11163000008800a29f7d", parameter: params as [String : AnyObject], success: { (response) in
            print(response)
        
            self.arrClientRefs.removeAllObjects()
            
            if let arrClientList = response["clientRefs"] as? NSArray
            {
                self.arrClientRefs.addObjects(from: arrClientList as! [Any])
            }
            self.tblvwInvoiceListing.reloadData()
            self.scrvw_Height_Constraint.constant = (self.tblvwInvoiceListing.contentSize.height + 100)
            self.refreshControl.endRefreshing()
            
        })
        { (responseError) in
            print(responseError)
        }
    }
    

    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMenuClicked(_ sender: Any) {
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
    
    @IBAction func btnSearchClicked(_ sender: Any) {
        self.callSearchAPI()
    }
    
    
    func callSearchAPI()
    {
        MainReqeustClass.BaseRequestSharedInstance.getSearchResult(parameter: nil, header: nil, strMethodName: "5d3b117d3000008600a29f84", successCall: { (response) in
            print(response)
            
            let storyBoard = UIStoryboard(name: "InvoiceList", bundle: nil)
            let clientWiseInvoiceVC = storyBoard.instantiateViewController(withIdentifier: "ClientWiseInvoiceListing") as! ClientWiseInvoiceListing
            clientWiseInvoiceVC.InvoiceType = self.InvoiceType
            
            //set data for client Listing
            clientWiseInvoiceVC.arrCompanies.removeAllObjects()
            if let arrCompanies = response["companies"] as? NSArray
            {
                clientWiseInvoiceVC.arrCompanies.addObjects(from: arrCompanies as! [Any])
            }
            
            if let dictClientRef = response["clientRef"] as? [String:Any]
            {
                clientWiseInvoiceVC.objClientRef = dictClientRef
            }
            clientWiseInvoiceVC.bSearchClicked = true
            clientWiseInvoiceVC.bTerceirosSelected = false
            self.navigationController?.pushViewController(clientWiseInvoiceVC, animated: true)
        })
        { (responseError) in
            print(responseError)
        }

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
        return arrClientRefs.count
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
        
        
        if let objClientDetails = arrClientRefs.object(at: indexPath.row) as? [String:Any]
        {
            cellForClientDetails.lblClientName.text = objClientDetails["name"] as? String
            cellForClientDetails.lblNIFValue.text = "\(objClientDetails["nif"] as! Int)"
            cellForClientDetails.lblRECIBOSValue.text = "\(String(describing: objClientDetails["quantity"] as! Int)) - \(String(describing: objClientDetails["amount"] as! Double).toCurrencyFormat())"
        }
        
        return cellForClientDetails
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "InvoiceList", bundle: nil)
        let clientWiseInvoiceVC = storyBoard.instantiateViewController(withIdentifier: "ClientWiseInvoiceListing") as! ClientWiseInvoiceListing
        clientWiseInvoiceVC.InvoiceType = self.InvoiceType
        clientWiseInvoiceVC.objClientRef = arrClientRefs.object(at: indexPath.row) as! [String : Any]
        clientWiseInvoiceVC.bTerceirosSelected = false
        clientWiseInvoiceVC.bSearchClicked = false
        self.navigationController?.pushViewController(clientWiseInvoiceVC, animated: true)
    }
}
extension InvoiceListingVC : UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.callSearchAPI()
        return true
    }
}
