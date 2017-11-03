//
//  DashBoardCollectionViewCell.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 9/22/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class DashBoardCollectionViewCell: UICollectionViewCell {
    
//MARK::- OUTLETS
    
    @IBOutlet weak var imageChoice: UIImageView!
    
    
//MARK::- FUNCTIONS
    
    func setImage(_ image:String){
        imageChoice?.image = UIImage(named: image)
    }
    
//MARK::- ACTIONS
    

    
}
