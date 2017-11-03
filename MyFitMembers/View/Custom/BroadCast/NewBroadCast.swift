//
//  NewBroadCast.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 9/29/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

protocol BroadCastDone {
    func delegatebroadCastDone()
}
class NewBroadCast: UIView , DelegateRemoveBroadCastSendPopUp {
    
    //MARK::- Outlets
    
    @IBOutlet weak var textView: UITextView!
    //MARK::- VARIABLES
    var popUpBroadCast: BroadCastSendPopUp?
    var vc: BroadCastViewController?
    var delegate:BroadCastDone?
    
    //MARK::- Functions
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NewBroadCast", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {return UIView()}
        return view
    }
    
    func xibSetup() {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    func instantiateViewControllers(){
        popUpBroadCast = BroadCastSendPopUp(frame: CGRect(x: 0, y: 0, w: DeviceDimensions.width, h: DeviceDimensions.height))
        popUpBroadCast?.delegate = self
    }
    
    
    //MARK::- Ovveride Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        instantiateViewControllers()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
        
    }
    
    //MARK::- Delegate
    
    func delegateRemoveBroadCastSendPopUp(){
        removeAnimate(self)
        delegate?.delegatebroadCastDone()
    }
    
    //MARK::- Actions
    
    
    @IBAction func btnActionOk(_ sender: UIButton) {
        
        popUpBroadCast?.vc = vc
        self.addSubview(popUpBroadCast ?? UIView())
        if textView.text.characters.count > 0 && textView.text?.trimmingCharacters(in: CharacterSet.whitespaces) != ""{
            UserDefaults.standard.setValue(textView.text ?? "", forKey: "BroadCastMessage")
            
            showAnimate(popUpBroadCast ?? UIView())
        }else{
            guard let vc  = vc else {return}
            AlertView.callAlertView("", msg: "Empty Message", btnMsg: "OK", vc: vc)
        }
    }
    
}
