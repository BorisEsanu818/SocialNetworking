//
//  AddFoodPicView.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/19/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

protocol DelegateAddFoodPicViewFoodSelected {
    func delegateAddFoodPicViewFoodSelected(_ foodPic:String)
}


class AddFoodPicView: UIView {
    
    
    //MARK::- VARIABLES
    
    var delegate: DelegateAddFoodPicViewFoodSelected?
    
    //MARK::- Functions
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AddFoodPicView", bundle: bundle)
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
    
    @IBAction func btnActionBreakFast(_ sender: UIButton) {
        delegate?.delegateAddFoodPicViewFoodSelected("BREAKFAST")
    }
    
    @IBAction func btnActionLunch(_ sender: UIButton) {
        delegate?.delegateAddFoodPicViewFoodSelected("LUNCH")
        
    }
    
    @IBAction func btnActionDinner(_ sender: UIButton) {
        delegate?.delegateAddFoodPicViewFoodSelected("DINNER")
    }
    
    @IBAction func btnActionMorningSnacks(_ sender: UIButton) {
        delegate?.delegateAddFoodPicViewFoodSelected("AFTERNOONSNACK")
    }
    
    @IBAction func btnActionEveningSnacks(_ sender: UIButton) {
        delegate?.delegateAddFoodPicViewFoodSelected("EVENINGSNACK")
    }
    
    
    
}
