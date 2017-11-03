//
//  ClientPersonalInfoTableViewCell.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/25/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
protocol StatePressed {
    func stateButtonPressed()
    func dateClicked()
}


class ClientPersonalInfoTableViewCell: UITableViewCell , UITextFieldDelegate  {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var labelName: UITextField!
    @IBOutlet weak var labelAddress: UITextField!
    @IBOutlet weak var labelPhoneNumber: UITextField!{
        didSet{
            labelPhoneNumber.delegate = self
        }
    }
    
    @IBOutlet weak var textFieldPinCode: UITextField!
    @IBOutlet weak var labelEmail: UITextField!
    @IBOutlet weak var labelRegisterationDate: UILabel!
    @IBOutlet weak var labelLastLogin: UILabel!
    @IBOutlet weak var labelAge: UITextField!
    
    @IBOutlet weak var textFieldCity: UITextField!
    
    @IBOutlet weak var btnState: UIButton!
    
    
    //MARK::- VARIABLES
    
    var delegate:StatePressed?
    var dateChooserView: DateChooser?
    
    //MARK::- OVERRIDE FUNCTIONS
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    //MARK::- FUNCTIONS
    
    func setValue(_ profileData: ClientPersonalInfo){
        labelName.text = profileData.name
        labelAddress.text = profileData.address
        labelPhoneNumber.text = profileData.phoneNumber
        labelEmail.text = profileData.emailAddress
        let registerDate = changeStringDateFormat(profileData.dateRegistered ?? "",fromFormat:"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",toFormat:"MM/dd/yyyy")
        labelRegisterationDate.text = registerDate
        let lognDate = changeStringDateFormat(profileData.lastLogIn ?? "",fromFormat:"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",toFormat:"MM/dd/yyyy")
        labelLastLogin.text = lognDate
        labelAge.text = profileData.age
        textFieldCity.text = profileData.city
        textFieldPinCode.text = profileData.pinCode?.toString
        btnState.setTitle(profileData.state, for: UIControlState())
    }
    
    @IBAction func btnActionState(_ sender: UIButton) {
        delegate?.stateButtonPressed()
    }
    
    @IBAction func btnActionDate(_ sender: UIButton) {
        delegate?.dateClicked()
    }
    
}


extension ClientPersonalInfoTableViewCell{
    
//MARK::- DELEGATE
    
//MARK::- TEXTFIELD DELEGATE
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
