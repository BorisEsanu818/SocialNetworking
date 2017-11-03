//
//  ChangePasswordViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 30/11/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ChangePasswordViewController: UIViewController {

//MARK::- OUTELTS
    @IBOutlet var textFieldPasswords: [UITextField]!
   
    
//MARK::- OVVERIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for textField in textFieldPasswords{
            textField.text = ""
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

//MARK::- CONSTANT ENUMS
    enum PasswordFields:Int{
        case oldPassword = 0
        case newPassword = 1
        case confirmedPassword = 2
    }
    
//MARK::- FUNCTIONS
    func validatePasswrd()->Bool{
        guard let txt = textFieldPasswords[0].text?.trimmingCharacters(in: CharacterSet.whitespaces) else {return false}
        if txt.characters.count > 0 {
            if textFieldPasswords[1].text?.characters.count > 0 && textFieldPasswords[1].text?.trimmingCharacters(in: CharacterSet.whitespaces) != ""{
                if textFieldPasswords[1].text == textFieldPasswords[2].text{
                    return true
                }else{
                    AlertView.callAlertView("", msg: "New password and confirm password should be same", btnMsg: "OK", vc: self)
                    return false
                }
            }else{
                return false
            }
        }else{
            AlertView.callAlertView("", msg: "Enter correct old password", btnMsg: "OK", vc: self)
           
            return false
        }
    }

    
   
    
//MARK::- ACTIONS
   
    @IBAction func btnActionConfirm(_ sender: UIButton) {
        setPasswords()
    }

    @IBAction func btnActionBack(_ sender: UIButton) {
        popVC()
    }
}

extension ChangePasswordViewController{
    
//MARK::- API
    
    func setPasswords(){
        if validatePasswrd(){
            guard let password = textFieldPasswords[PasswordFields.confirmedPassword.rawValue].text , let oldPassword = textFieldPasswords[PasswordFields.oldPassword.rawValue].text else {return}
            let dictForBackEnd = API.ApiCreateDictionary.changePassword(password: password , oldPassword:oldPassword).formatParameters()
            print(dictForBackEnd)
            guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return}
            var url = ""
            if isClient{
                url = ApiCollection.apiClientChangePassword
            }else{
                url = ApiCollection.apiTrainerChangePassword
            }
            ApiDetector.getDataOfURL(url, dictForBackend: dictForBackEnd, failure: { (data) in
                print(data)
                }, success: { [unowned self] (data) in
                    print(data)
                    AlertView.callAlertView("", msg: "Password changed successfully", btnMsg: "OK", vc: self)
                    for textField in self.textFieldPasswords{
                        textField.text = ""
                    }
                }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:], showLoader: true, loaderColor: Colorss.darkRed.toHex())
        }else{
            
        }
    }
    
}
