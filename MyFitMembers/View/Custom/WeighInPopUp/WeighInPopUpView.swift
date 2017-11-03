//
//  WeighInPopUpView.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/25/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
protocol DelegateAddWeighIn {
    func delegateAddWeighIn(_ weigh:String , unit:String)
}
class WeighInPopUpView: UIView {
    
    //MARK::- Outlets
    
    @IBOutlet weak var labelUnit: UILabel!
    @IBOutlet weak var textFieldAddField: UITextField!
    
    @IBOutlet weak var viewCustomisation: UIView!
    @IBOutlet weak var constraintHeightViewCustomisation: NSLayoutConstraint!
    
    
    //MARK::- VARIABLES
    var delegate:DelegateAddWeighIn?
    
    //MARK::- Functions
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "WeighInPopUpView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {return UIView()}
        return view
    }
    
    func xibSetup() {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    //MARK::- Ovveride Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
        
    }
    
    //MARK::- Actions
    
    @IBAction func btnActionSwitch(_ sender: UISwitch) {
        if sender.isOn{
            labelUnit.text = "kg"
        }else{
            labelUnit.text = "lbs"
        }
        
    }
    
    @IBAction func btnActionOk(_ sender: UIButton) {
        guard let fieldName = textFieldAddField.text , let unit = labelUnit.text else {return}
        if fieldName.characters.count > 0 && fieldName.trimmingCharacters(in: CharacterSet.whitespaces) != ""{
            delegate?.delegateAddWeighIn(fieldName , unit: unit)
            self.removeFromSuperview()
        }else{
            self.removeFromSuperview()
        }
        
    }
    
}
