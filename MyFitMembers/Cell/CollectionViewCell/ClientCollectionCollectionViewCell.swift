//
//  ClientCollectionCollectionViewCell.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 9/23/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class ClientCollectionCollectionViewCell: UICollectionViewCell {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    
    //MARK::- VARIABLES
    
    
    //MARK::- FUNCTIONS
    func setValue(_ userImage:String?, userName:String? , row:Int){
        guard let userImage = userImage else {return}
        let userImageUrl = ApiCollection.apiImageBaseUrl + userImage
        guard let imageUrl = URL(string: userImageUrl) else {return}
        imageUser.yy_setImage(with: imageUrl, placeholder: UIImage(named: "ic_placeholder"))
//        imageUser.yy_setImageWithURL(imageUrl, options: .ProgressiveBlur)
        labelUserName.text = userName?.uppercaseFirst
        
    }
    
    //MARK::- ACTIONS
    
    
    
}
