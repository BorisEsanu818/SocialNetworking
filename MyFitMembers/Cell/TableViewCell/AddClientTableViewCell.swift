//
//  AddClientTableViewCell.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 9/24/16.
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


protocol DelegateAddClientTableViewCellTextFieldEditting {
    func delegateAddClientTableViewCellTextFieldEditting(_ showSkip: Bool)
}

class AddClientTableViewCell: UITableViewCell  , UITextFieldDelegate{

//MARK::- Outlets
    
    @IBOutlet weak var labelType: UILabel!
    
    @IBOutlet weak var textFieldValue: UITextField!
    @IBOutlet weak var labelMeasurement: UILabel!
    
    
//MARK::- VARIABLES
    
    var delegate: DelegateAddClientTableViewCellTextFieldEditting?
    
//MARK::- Ovveride functions
    override func awakeFromNib() {
        super.awakeFromNib()
        textFieldValue.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        textFieldValue.delegate = self
        // Configure the view for the selected state
    }
    
    
//MARK::- Functions
    
    func setValue(_ type:String,measurementType:String){
        labelType.text = type
        labelMeasurement.text = measurementType
    }
    
//MARK::- Actions
    
    @IBAction func btnActionTextField(_ sender: UITextField) {
        if sender.text?.characters.count > 0 && sender.text?.trimmingCharacters(in: CharacterSet.whitespaces) != ""{
            delegate?.delegateAddClientTableViewCellTextFieldEditting(false)
        }else{
            delegate?.delegateAddClientTableViewCellTextFieldEditting(true)
        }
    }
    
    
    

}
