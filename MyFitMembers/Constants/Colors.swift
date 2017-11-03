//
//  Colors.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/22/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

enum Colorss {
    case lightRed
    case darkRed
    case greyColor
    case calendarGreyColor
    case pagerBlackShade
    case lineChartBackgroundColor
    case dotBlueColor
    case linChartGreyColor
    case stateGreyColor
    
    func toHex() -> UIColor {
        switch self {
        case .lightRed:
            return hexStringToUIColor("#FA8E98")
        case .darkRed:
            return hexStringToUIColor("#EC2A3C")
            
        case .greyColor:
            return hexStringToUIColor("#D9D9D9")
            
        case .calendarGreyColor:
            return hexStringToUIColor("#4A4A4A")
            
        case .pagerBlackShade:
            return hexStringToUIColor("#4A4A4A")
            
        case .lineChartBackgroundColor:
            return hexStringToUIColor("#F2F2F2")
            
        case .dotBlueColor:
            return hexStringToUIColor("#00AAFB")
            
        case .linChartGreyColor:
            return hexStringToUIColor("#DBDBDB")
            
        case .stateGreyColor:
            return hexStringToUIColor("#232628")
            
            
        }
    }
    func toHex(_ mark : String) -> UIColor {
        switch self {
        case .lightRed:
            return hexStringToUIColor("#FA8E98")
        case .darkRed:
            return hexStringToUIColor("#EC2A3C")
            
        case .greyColor:
            return hexStringToUIColor("#D9D9D9")
            
        case .calendarGreyColor:
            return hexStringToUIColor("#4A4A4A")
            
        case .pagerBlackShade:
            return hexStringToUIColor("#4A4A4A")
            
        case .lineChartBackgroundColor:
            return hexStringToUIColor("#F2F2F2")
            
        case .dotBlueColor:
            return hexStringToUIColor("#00AAFB")
            
        case .linChartGreyColor:
            return hexStringToUIColor("#DBDBDB")
            
        case .stateGreyColor:
            return hexStringToUIColor("#232628")
            
            
        }
    }
}

func hexStringToUIColor (_ hex:String) -> UIColor {
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
