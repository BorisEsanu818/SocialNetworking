//
//  WeighInView.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/17/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class WeighInView: UIView {

    @IBOutlet weak var labelWeight: UILabel!
    
//    var weight: String?
    
    //MARK::- Functions
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "WeighInView", bundle: bundle)
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
//        labelWeight.text = weight ?? ""
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
//        labelWeight.text = weight ?? ""
    }
    
    //MARK::- Actions
    
    

}
