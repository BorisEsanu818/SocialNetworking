//
//  SignInViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 9/22/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//


import UIKit
import EZSwiftExtensions

var runOnce = true
class SignInViewController: UIViewController {
    
    //MARK::- OUTLETS
    @IBOutlet weak var textFieldEmailId: UITextField!{
        didSet{
            
            textFieldEmailId.attributedPlaceholder =  NSAttributedString(string: "Enter your email", attributes: [NSForegroundColorAttributeName: UIColor(red: 242/255, green: 47/255, blue:58/255, alpha: 1.0)])
            
        }
    }
    @IBOutlet weak var viewCollection: UIView!
    @IBOutlet weak var viewLogo: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var textFieldPassword: UITextField!{
        didSet{
            textFieldPassword.attributedPlaceholder =  NSAttributedString(string: "Enter your password", attributes: [NSForegroundColorAttributeName: UIColor(red: 242/255, green: 47/255, blue:58/255, alpha: 1.0)])
        }
    }
    @IBOutlet weak var btnLogIn: UIButton!
    
    @IBOutlet weak var viewCover: UIView!
    //MARK::- VARIABLES
    var dontHaveAccountPopUp: NoAccountPopUp?
    var clientDashVc: ClientDashBoardViewController?
    
    //MARK::- OVVERIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isHidden = true
        print(UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken)
        instantiateViewController()
        if UserDataSingleton.sharedInstance.loggedInUser?.userAccessToken != nil{
            guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return}
            if isClient{
                NotificationCenter.default.post(name: Notification.Name(rawValue: "ConfigureLeftDrawer"), object: nil)
                let clientDashVc = StoryboardScene.ClientStoryboard.instantiateClientDashBoardViewController()
                
                self.navigationController?.pushViewController(clientDashVc, animated: false)
            }else{
                NotificationCenter.default.post(name: Notification.Name(rawValue: "ConfigureLeftDrawer"), object: nil)
                let dashVc = StoryboardScene.Main.instantiateDashBoardViewController()
                self.navigationController?.pushViewController(dashVc, animated: false)
                
            }        }else{
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.isHidden = false
        if runOnce{
            logo.center = CGPoint(x: self.view.center.x,y: self.view.center.y)
            viewCollection.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.size.height )
            animateView()
            runOnce = false
        }else{
            runOnce = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK::- FUNCTIONS
    
    func instantiateViewController(){
        dontHaveAccountPopUp = NoAccountPopUp(frame: self.view.frame)
    }
    
    func animateView(){
        UIView.animate(withDuration: 0.35, delay: 0.2, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.logo.center = self.viewLogo.center
        }) { (completed) -> Void in
        }
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.viewCollection.transform = CGAffineTransform.identity
        }) 
    }
    
    //MARK::- DELEGATES
    
    
    //MARK:- ACTIONS
    
    @IBAction func btnActionSignIn(_ sender: UIButton) {
        let check = User.validateLoginFields(textFieldEmailId.text, password: textFieldPassword.text)
        if check{
            let emailId = textFieldEmailId.text?.lowercased()
            let dictForBackend = API.ApiCreateDictionary.login(email: emailId , password: textFieldPassword.text).formatParameters()
            print(dictForBackend)
            ApiDetector.getDataOfURL(ApiCollection.apiLogin, dictForBackend: dictForBackend, failure: { (error) in
                print(error)
                }, success: { [weak self] (data) in
                    guard let userData = data as? User else {return}
                    UserDataSingleton.sharedInstance.loggedInUser = userData
                    guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return}
                    if isClient{
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "ConfigureLeftDrawer"), object: nil)
                        let clientDashVc = StoryboardScene.ClientStoryboard.instantiateClientDashBoardViewController()
                        self?.pushVC(clientDashVc)
                    }else{
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "ConfigureLeftDrawer"), object: nil)
                        let dashVc = StoryboardScene.Main.instantiateDashBoardViewController()
                        self?.pushVC(dashVc)
                    }
                    AppDelegate.registerNotifications()
                }, method: .postWithImage, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: UIColor.white)
            
        }else{
            AlertView.callAlertView("", msg: "Please enter valid email id and password", btnMsg: "OK", vc: self)
        }
    }
    
    @IBAction func btnActionDontHaveAccount(_ sender: UIButton) {
        self.view.addSubview(dontHaveAccountPopUp ?? UIView())
        showAnimate(dontHaveAccountPopUp ?? UIView())
    }
    
}


func setUpSideBar(_ allowPan:Bool, allowRighSwipe: Bool){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    guard let navigationController = appDelegate.window?.rootViewController as? LeftNavigationViewController else {return}
    navigationController.sideMenu?.hideSideMenu()
    navigationController.sideMenu?.allowPanGesture = allowPan
    navigationController.sideMenu?.allowRightSwipe = allowRighSwipe
}
