//
//  AddClientPopUp.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 9/27/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

protocol DelegateAddClientPopUp {
    func delegateAddClientPopUp()
}

class AddClientPopUp: UIView {

//MARK::- OUTLETS
    
//MARK::- VARIABLES
    var delegate:DelegateAddClientPopUp?
    
    
//MARK::- Functions
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AddClientPopUp", bundle: bundle)
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
    
    
    @IBAction func btnActionOk(_ sender: UIButton) {
        delegate?.delegateAddClientPopUp()
    }

}
