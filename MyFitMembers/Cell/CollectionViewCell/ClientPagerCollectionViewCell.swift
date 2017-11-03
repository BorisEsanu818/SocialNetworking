//
//  ClientPagerCollectionViewCell.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/14/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
var selectedRow:Int? = 0
class ClientPagerCollectionViewCell: UICollectionViewCell {
    
//MARK::- OUTLETS
    
    @IBOutlet weak var labelControllerName: UILabel!
    
    @IBOutlet weak var labelFloating: UILabel!
//MARK::- VARIABLES
    
//MARK::- FUNCTIONS
    
    func setValue(_ controllerName:AnyObject, row:Int){
        print(selectedRow)
        if row == selectedRow{
            labelFloating.isHidden = false
        }else{
            labelFloating.isHidden = true
        }
        labelControllerName.text = String(describing: controllerName)
        self.tag = row
    }
    
}
