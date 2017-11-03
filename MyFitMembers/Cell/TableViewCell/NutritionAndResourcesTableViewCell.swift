//
//  NutritionAndResourcesTableViewCell.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 01/12/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class NutritionAndResourcesTableViewCell: UITableViewCell {
    
    //MARK::- OUTLETS

    @IBOutlet weak var label: UILabel!
    
    //MARK::- VARIABLES
    
    
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
    
    func setValues(_ data: Nutrition){
        label.text = data.name
    }
    
    //MARK::- ACTIONS
    
    
    
}
