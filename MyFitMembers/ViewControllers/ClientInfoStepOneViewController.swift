//
//  ClientInfoStepOneViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 9/29/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import RMMapper
import IQKeyboardManager
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


class ClientInfoStepOneViewController: UIViewController, UITextFieldDelegate , DelegateSelectedState , SetDate {
    
    //MARK::- OUTLETS
    
    @IBOutlet var textFieldInfo: [UITextField]!
    
    @IBOutlet weak var viewNextOverLay: UIView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var textViewAddress: UITextField!
    
    @IBOutlet weak var btnDateOfBirth: UIButton!
    
    @IBOutlet weak var btnState: UIButton!
    
    @IBOutlet weak var textfieldPhoneNum: UITextField!
    //MARK::- VARIABLES
    
    var dateChooserView: DateChooser?
    var clientInfoStepTwoVc: ClientInfoStepTwoViewController?
    var validData = false
    var statePopPresent = false
    var statePopUp: CountryNameTableView?
    var country: [String]? = [
        "Alabama",
        "Alaska",
        "American Samoa",
        "Arizona",
        "Arkansas",
        "California",
        "Colorado",
        "Connecticut",
        "Delaware",
        "District Of Columbia",
        "Federated States Of Micronesia",
        "Florida",
        "Georgia",
        "Guam",
        "Hawaii",
        "Idaho",
        "Illinois",
        "Indiana",
        "Iowa",
        "Kansas",
        "Kentucky",
        "Louisiana",
        "Maine",
        "Marshall Islands",
        "Maryland",
        "Massachusetts",
        "Michigan",
        "Minnesota",
        "Mississippi",
        "Missouri",
        "Montana",
        "Nebraska",
        "Nevada",
        "New Hampshire",
        "New Jersey",
        "New Mexico",
        "New York",
        "North Carolina",
        "North Dakota",
        "Northern Mariana Islands",
        "Ohio",
        "Oklahoma",
        "Oregon",
        "Palau",
        "Pennsylvania",
        "Puerto Rico",
        "Rhode Island",
        "South Carolina",
        "South Dakota",
        "Tennessee",
        "Texas",
        "Utah",
        "Vermont",
        "Virgin Islands",
        "Virginia",
        "Washington",
        "West Virginia",
        "Wisconsin",
        "Wyoming"
    ]
    var boolAllowedNext = false
    var boolStateSelected = false
    var boolDateOfBirthSelected = false
    
    
    //MARK::- OVVERIDE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfieldPhoneNum.delegate = self
        instantiateViewControllers()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpSideBar(false,allowRighSwipe: false)
        setDelegate()
        btnNext.isEnabled = false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if statePopPresent{
            statePopUp?.removeFromSuperview()
        }else{}
        removeAnimate(dateChooserView ?? UIView())
        self.view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    
    //MARK::- FUNCTIONS
    
    func instantiateViewControllers(){
        dateChooserView = DateChooser(frame: CGRect(x: 0, y: 0, width: DeviceDimensions.width, height: DeviceDimensions.height))
        dateChooserView?.delegate = self
    }
    
    
    func setDelegate(){
        for textField in textFieldInfo{
            textField.delegate = self
        }
    }
    
    
    //MARK::- DELEGATE
    
    func setDate(_ date:String){
        boolDateOfBirthSelected = true
        btnDateOfBirth.setTitleColor(UIColor.black, for: UIControlState())
        btnDateOfBirth.setTitle(date, for: UIControlState())
        if boolAllowedNext && boolStateSelected && boolDateOfBirthSelected{
            viewNextOverLay.isHidden = true
            btnNext.isEnabled = true
           
        }else{
            viewNextOverLay.isHidden = false
            btnNext.isEnabled = false
        }
    }
    
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionNext(_ sender: UIButton) {
        sendUserInfo()
        UserDefaults.standard.setValue(nil, forKey: "ImageSelected")
    }
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        boolPopSelf = false
        popVC()
    }
    
    @IBAction func btnActionDateOfBirth(_ sender: UIButton) {
        view.endEditing(true)
        showAnimate(dateChooserView ?? UIView() )
        self.view.addSubview(dateChooserView ?? UIView())
    }
    
    @IBAction func btnActionShowStates(_ sender: UIButton) {
        view.endEditing(true)
        let alertcontroller =   UIAlertController.showActionSheetController(title: "State", buttons: country ?? [""], success: { [unowned self]
            (state) -> () in
            self.btnState.setTitleColor(UIColor.black, for: UIControlState())
            self.btnState.setTitle(state, for: UIControlState())
            self.boolStateSelected = true
            if self.boolAllowedNext && self.boolStateSelected && self.boolDateOfBirthSelected{
                self.viewNextOverLay.isHidden = true
                self.btnNext.isEnabled = true
            }else{
                self.viewNextOverLay.isHidden = false
                self.btnNext.isEnabled = false
            }
            })
        present(alertcontroller, animated: true, completion: nil)
    }
}

extension ClientInfoStepOneViewController{
    
    //MARK::- GATHER DATA
    
    func sendUserInfo(){
        if btnState.titleLabel?.text?.trimmingCharacters(in: CharacterSet.whitespaces) != "" && btnState.titleLabel?.text?.characters.count > 0 && textViewAddress.text?.characters.count > 0 &&  textViewAddress?.text?.trimmingCharacters(in: CharacterSet.whitespaces) != ""{
            validData = true
        }else{
            AlertView.callAlertView("", msg: "Please fill in all the input fields.", btnMsg: "OK", vc: self)
            return
        }
        
        for textField in textFieldInfo{
            if textField.text?.characters.count > 0{
                if textField.text?.trimmingCharacters(in: CharacterSet.whitespaces) != ""{
                    
                    validData = true
                }else{
                    validData = false
                    break
                }
            }else{
                validData = false
                break
            }
        }
        
        if User.isValidEmail(textFieldInfo[2].text ?? ""){
            
            if validData{
                
                let firstName = textFieldInfo[0].text?.lowercased()
                let lastName = textFieldInfo[1].text?.uppercaseFirst
                let phoneNum = textfieldPhoneNum.text
                let email = textFieldInfo[2].text
                let city = textFieldInfo[3].text
                let zipCopde = textFieldInfo[4].text
                let address = textViewAddress.text
                let age = btnDateOfBirth.titleLabel?.text
                guard let state = btnState.titleLabel?.text else {return}
                
                
                let dictForBackEnd = API.ApiCreateDictionary.clientInfo(firstName: firstName, lastName: lastName, info: "info", countryCode: "+1", phoneNumber: phoneNum, email: email, addressLine: address, city: city, state: state, pinCode: zipCopde , age: age).formatParameters()
                print(dictForBackEnd)
                UserDefaults.standard.rm_setCustomObject(dictForBackEnd, forKey: "AddNewUserInformation")
                
                let clientInfoStepTwoVc = StoryboardScene.Main.instantiateClientInfoStepTwoViewController()
                pushVC(clientInfoStepTwoVc)
            }else{
                AlertView.callAlertView("", msg: "Please fill in all the input fields.", btnMsg: "OK", vc: self)
                
            }
        }else{
            AlertView.callAlertView("", msg: "Enter valid email address", btnMsg: "OK", vc: self)
        }
    }
}

extension ClientInfoStepOneViewController{
    
    //MARK::- DelegateSelectedState
    
    func delegateSelectedState(_ state: String){
        btnState.setTitleColor(UIColor.black, for: UIControlState())
        removeAnimate(statePopUp ?? UIView())
        btnState.setTitle(state, for: UIControlState())
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
       
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textfieldPhoneNum{
        let length = Int(getLength(textField.text!))
        if length == 10 {
            if range.length == 0 {
                return false
            }
        }
        if length == 3 {
            let num = formatNumber(textField.text!)
            textField.text = "(\(num)) "
            if range.length > 0 {
                textField.text = "\(num.substring(to: num.characters.index(num.startIndex, offsetBy: 3)))"
            }
        }
        else if length == 6 {
            let num = formatNumber(textField.text!)
            textField.text = "(\(num.substring(to: num.characters.index(num.startIndex, offsetBy: 3)))) \(num.substring(from: num.characters.index(num.startIndex, offsetBy: 3)))-"
            if range.length > 0 {
                textField.text = "(\(num.substring(to: num.characters.index(num.startIndex, offsetBy: 3)))) \(num.substring(from: num.characters.index(num.startIndex, offsetBy: 3)))"
            }
        }
        }
        
        for textField in textFieldInfo{
            if textField.text?.trimmingCharacters(in: CharacterSet.whitespaces) != "" && textField.text?.characters.count > 0{
                boolAllowedNext = true
            }else{
                boolAllowedNext = false
                break
            }
        }
        if boolAllowedNext && boolStateSelected && boolDateOfBirthSelected{
            viewNextOverLay.isHidden = true
            btnNext.isEnabled = true
        }else{
            viewNextOverLay.isHidden = false
            btnNext.isEnabled = false
        }
        
        return true
    }
    
    
    func formatNumber( _ mobileNumber: String) -> String {
        var mobileNumber = mobileNumber.replacingOccurrences(of: "(", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: ")", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: " ", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "-", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "+", with: "")
        print("\(mobileNumber)")
        let length = mobileNumber.characters.count
        if length > 10 {
            mobileNumber = mobileNumber.substring(from: mobileNumber.characters.index(mobileNumber.startIndex, offsetBy: length - 10))
            print("\(mobileNumber)")
        }
        return mobileNumber
    }
    
    func getLength(_ mobileNumber: String) -> Int {
        var mobileNumber = mobileNumber.replacingOccurrences(of: "(", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: ")", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: " ", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "-", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "+", with: "")
        let length = Int(mobileNumber.length)
        return length
    }
    
}

