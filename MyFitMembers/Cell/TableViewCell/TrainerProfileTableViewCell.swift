//
//  TrainerProfileTableViewCell.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/6/16.
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


protocol DatePressed{
   func stateButtonPressed()
}
class TrainerProfileTableViewCell: UITableViewCell , UITextFieldDelegate {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var labelEmailId: UITextField!
    
    @IBOutlet weak var labelGymName: UITextField!
    @IBOutlet weak var labelAddress: UITextField!
    @IBOutlet weak var labelPhoneNumber: UITextField!{
        didSet{
            labelPhoneNumber.delegate = self
        }
    }
    
    @IBOutlet weak var textFieldZipCode: UITextField!
    @IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var textFieldCity: UITextField!
    @IBOutlet weak var labelLastLogInDate: UILabel!
    @IBOutlet weak var labelRegisterationDate: UILabel!
    
    
    var delegate: DatePressed?
    
    
    //MARK::- OVERRIDE FUNCTIONS
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK::- Functions
    
    
    func setValue(_ data: AnyObject){
        guard let data = data as? TrainerProfile else {return}
        labelEmailId.text = data.emailAddress
        let gymName = data.gym?.name
        let names = gymName?.split(" ")
        var gym = ""
        
        if names?.count > 0{
            for name in names ?? []{
                gym = gym + " " + name.uppercaseFirst
            }
        }else{
            gym = data.gym?.name ?? ""
        }
        
        labelGymName.text = gym
        labelAddress.text = data.address
        labelPhoneNumber.text = data.phoneNumber
        
        let lastLoginDate = changeStringDateFormat(data.lastLogIn ?? "",fromFormat:"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",toFormat:"MM/dd/yyyy")
        
        let registerationDate = changeStringDateFormat(data.dateRegistered ?? "",fromFormat:"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",toFormat:"MM/dd/yyyy")
        
        labelLastLogInDate.text = lastLoginDate
        labelRegisterationDate.text = registerationDate
        textFieldCity.text = data.city
        textFieldZipCode.text = data.pinCode?.toString
        btnState.setTitle(data.state, for: UIControlState())
    }
    
    
    @IBAction func btnActionRegisteredDate(_ sender: UIButton) {
//        delegate?.datePressed()
    }
    
    @IBAction func btnActionState(_ sender: UIButton) {
        delegate?.stateButtonPressed()
    }
    
}

extension TrainerProfileTableViewCell{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
