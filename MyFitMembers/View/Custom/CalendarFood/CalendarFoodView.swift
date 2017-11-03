//
//  CalendarFoodView.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/13/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class CalendarFoodView: UIView {
    
    //MARK::- OUTLETS
    
    
    //MARK::- VARIABLES
    @IBOutlet weak var labelBreakfast: UILabel!
    
    @IBOutlet weak var labelLunch: UILabel!
    
    @IBOutlet weak var labelDinner: UILabel!
    
    @IBOutlet weak var labelMorningSnacks: UILabel!
    
    @IBOutlet weak var labelEveningSnacks: UILabel!
    
    
    //MARK::- Functions
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CalendarFoodView", bundle: bundle)
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
        hideAllLabels()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
        hideAllLabels()
    }
    
    func hideAllLabels(){
        labelBreakfast.isHidden = true
        labelLunch.isHidden = true
        labelDinner.isHidden = true
        labelMorningSnacks.isHidden = true
        labelEveningSnacks.isHidden = true
    }
    
    func updateColor(_ red: Bool){
        if red{
            labelBreakfast.backgroundColor = Colorss.darkRed.toHex()
            labelLunch.backgroundColor = Colorss.darkRed.toHex()
            labelDinner.backgroundColor = Colorss.darkRed.toHex()
            labelMorningSnacks.backgroundColor = Colorss.darkRed.toHex()
            labelEveningSnacks.backgroundColor = Colorss.darkRed.toHex()
        }else{
            labelBreakfast.backgroundColor = Colorss.dotBlueColor.toHex()
            labelLunch.backgroundColor = Colorss.dotBlueColor.toHex()
            labelDinner.backgroundColor = Colorss.dotBlueColor.toHex()
            labelMorningSnacks.backgroundColor = Colorss.dotBlueColor.toHex()
            labelEveningSnacks.backgroundColor = Colorss.dotBlueColor.toHex()

        }
        
    }
    
    
    //MARK::- Actions
    
    
}
