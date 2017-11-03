//
//  DayCollectionCell.swift
//  Calendar
//
//  Created by Boris Esanu on 02/06/15.
//  Copyright (c) 2015 Lancy. All rights reserved.
//

import UIKit

class DayCollectionCell: UICollectionViewCell {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var markedView: UIView!{
        didSet{
            if isSelfie{
                markedView.backgroundColor = Colorss.darkRed.toHex()
            }else{
                markedView.backgroundColor = UIColor.white
            }
        }
    }
    @IBOutlet weak var constraintBottomLabel: NSLayoutConstraint!
    @IBOutlet weak var imageSelfie: UIImageView!{
        didSet{
            imageSelfie.layer.cornerRadius = imageSelfie.frame.width/2
        }
    }
    @IBOutlet weak var viewFoodInfo: UIView!
    
    @IBOutlet weak var labelBreakFast: UILabel!
    
    @IBOutlet weak var labelLunch: UILabel!
    @IBOutlet weak var labelDinner: UILabel!
    
    @IBOutlet weak var labelEveningSnacks: UILabel!
    @IBOutlet weak var labelNoonSnacks: UILabel!
    
    //MARK::- VARIABLES
    var date: Date? {
        didSet {
            if date != nil {
                label.text = "\(date!.day)"
            } else {
                label.text = ""
            }
        }
    }
    var disabled: Bool = false {
        didSet {
            if disabled {
                alpha = 0.0
            } else {
                alpha = 1.0
            }
        }
    }
    var mark: Bool = false {
        didSet {
            if mark {
                markedView?.isHidden = false
                if isSelfie{
                    label.textColor = UIColor.white
                }else{
                    label.textColor = Colorss.calendarGreyColor.toHex()
                    labelLunch.backgroundColor = Colorss.darkRed.toHex()
                    labelDinner.backgroundColor = Colorss.darkRed.toHex()
                    labelBreakFast.backgroundColor = Colorss.darkRed.toHex()
                    labelNoonSnacks.backgroundColor = Colorss.darkRed.toHex()
                    labelEveningSnacks.backgroundColor = Colorss.darkRed.toHex()
                }
            } else {
                if isSelfie{
                    markedView!.isHidden = true
                    label.textColor = Colorss.calendarGreyColor.toHex()
                }else{
                    markedView!.isHidden = true
                    label.textColor = Colorss.calendarGreyColor.toHex()
                    label.textColor = Colorss.calendarGreyColor.toHex()
                    labelLunch.backgroundColor = Colorss.dotBlueColor.toHex()
                    labelDinner.backgroundColor = Colorss.dotBlueColor.toHex()
                    labelBreakFast.backgroundColor = Colorss.dotBlueColor.toHex()
                    labelNoonSnacks.backgroundColor = Colorss.dotBlueColor.toHex()
                    labelEveningSnacks.backgroundColor = Colorss.dotBlueColor.toHex()
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
