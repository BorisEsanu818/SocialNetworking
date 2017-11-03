//
//  FoodPicsTableViewCell.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/10/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class FoodPicsTableViewCell: UITableViewCell {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var imageFood: UIImageView!
    
    @IBOutlet weak var labelTyme: UILabel!
    @IBOutlet weak var labelFoodType: UILabel!
    
    //MARK::- OVERRIDE FUNCTIONS
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK::- FUNCTIONS
    
    func setData(_ foodData:FoodPics){
        guard let image  = foodData.userImage?.userOriginalImage else {return}
        let imgUrl = ApiCollection.apiImageBaseUrl + image
        
        guard let imageUrlX = URL(string: imgUrl) else {return}
        
        imageFood.yy_setImage(with: imageUrlX, options: .progressiveBlur)
        
        let foodTime = changeStringDateFormat1(foodData.foodPicDate ?? "",fromFormat:"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",toFormat:"hh:mm a")
        let foddDateFormatted = foodTime.toLocalTime()
        let foodFormattedTime =  foddDateFormatted.changeFormatOnly("hh:mm a", date: foddDateFormatted)
        labelTyme.text = foodFormattedTime
        labelFoodType.text = foodData.foodType
    }
    
    
    //MARK::- ACTIONS
    
    
    
}
