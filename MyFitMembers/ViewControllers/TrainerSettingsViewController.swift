//
//  TrainerSettingsViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/11/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class TrainerSettingsViewController: UIViewController {
    
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var labelVersionNumber: UILabel!
    
    
    //MARK::- VARIABLES
    
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
        setUpSideBar(false,allowRighSwipe: false)
        let versionNumber = Bundle.applicationVersionNumber
        print(versionNumber)
        labelVersionNumber.text = "version " + versionNumber
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK::- FUNCTIONS
    
    
    func apiHandlingMultipleActions(_ api: String , dictForBkend: OptionalDictionary){
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
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionLogOut(_ sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { [weak self] (action) in
            self?.handleLogOutAndDeleteAccount(ApiCollection.apiTrainerLogOut)
            }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnActionSwitch(_ sender: UISwitch) {
        
        if sender.isOn{
            let dictForBackend = API.ApiCreateDictionary.onOffPush(status:"TRUE").formatParameters()
            apiHandlingMultipleActions(ApiCollection.apiTrainerPush, dictForBkend: dictForBackend)
            
        }else{
            let dictForBackend = API.ApiCreateDictionary.onOffPush(status:"FALSE").formatParameters()
            apiHandlingMultipleActions(ApiCollection.apiTrainerPush, dictForBkend: dictForBackend)
            
        }
    }
    
    
    @IBAction func btnActionDeleteAccount(_ sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "Are you sure you want to delete your account? All your data will be erased.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { [weak self] (action) in
            self?.handleLogOutAndDeleteAccount(ApiCollection.apiTrainerDeleteAccount)
            }))
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnActionChangePassword(_ sender: UIButton) {
        guard let vc = changePasswordVC else {return}
        pushVC(vc)
    }
    
    
}
