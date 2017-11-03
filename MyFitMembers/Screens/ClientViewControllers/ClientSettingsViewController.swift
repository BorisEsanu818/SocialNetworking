//
//  ClientSettingsViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/18/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class ClientSettingsViewController: UIViewController  , DelegateClientSettingsTableViewCellNotificationSwitchClicked{
    
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var labelVersionNumber: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    //MARK::- VARIABLES
    
    var dataSourceTableView: DataSourceTableView?
    let notificationTypes = ["Trainer Messages" ,"Weekly Reminder"]
    var changePasswordVC: ChangePasswordViewController?
    //MARK::- OVERRIDE FUNCTIONS
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changePasswordVC = StoryboardScene.Main.instantiateChangePasswordViewController()
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureTableView()
        setUpSideBar(false,allowRighSwipe: false)
        let versionNumber = Bundle.applicationVersionNumber
        print(versionNumber)
        labelVersionNumber.text = "version " + versionNumber
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK::- FUNCTIONS
    
    func configureTableView(){
        
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.ClientSettingsTableViewCell.rawValue , item: notificationTypes as [AnyObject]?, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? ClientSettingsTableViewCell else {return}
            cell.setData(indexPath.row , notificationName:self.notificationTypes[indexPath.row])
            
            }, configureDidSelect: { (indexPath) in
                
        })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        dataSourceTableView?.item = notificationTypes as [AnyObject]? ?? []
        dataSourceTableView?.cellHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }
    
    func apiHandlingMultipleActions(_ api: String , dictForBkend: OptionalDictionary){
        print(dictForBkend)
        print(api)
        ApiDetector.getDataOfURL(api, dictForBackend: dictForBkend, failure: { (data) in
            print(data)
            }, success: { (data) in
                print(data)
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:], showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
    func handleLogOutAndDeleteAccount (_ api: String){
        let dictForBackEnd = API.ApiCreateDictionary.clientListing().formatParameters()
        
        ApiDetector.getDataOfURL(api, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { (data) in
                print(data)
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                appDelegate.logOut()
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:], showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
    
    func runNotification(_ type:String , on:Bool){
        if on{
            let dictForBackend = API.ApiCreateDictionary.onOffPushClient(status:"TRUE" , notificationType: type).formatParameters()
            apiHandlingMultipleActions(ApiCollection.apiClientPush, dictForBkend: dictForBackend)
            
        }else{
            let dictForBackend = API.ApiCreateDictionary.onOffPushClient(status:"FALSE" , notificationType: type).formatParameters()
            apiHandlingMultipleActions(ApiCollection.apiClientPush, dictForBkend: dictForBackend)
            
        }
    }
    
    
    func sendNotificationType(_ type:String , boolOn: Bool){
        runNotification(type, on:  boolOn)
    }
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionLogOut(_ sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { [weak self] (action) in
            self?.handleLogOutAndDeleteAccount(ApiCollection.apiClientLogOut)
            }))
        self.present(alertController, animated: true, completion: nil)
        
        
        
        
    }
    
    
    
    @IBAction func btnActionDeleteAccount(_ sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "Are you sure you want to delete your account? All your data will be erased.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { [weak self] (action) in
            self?.handleLogOutAndDeleteAccount(ApiCollection.apiClientDeleteAccount)
            
            }))
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnActionChangePassword(_ sender: UIButton) {
        guard let vc = changePasswordVC else {return}
        pushVC(vc)
    }
    
    
}
