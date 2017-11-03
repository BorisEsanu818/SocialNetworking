//
//  FitnessAssessmentTableViewCell.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/10/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class FitnessAssessmentTableViewCell: UITableViewCell {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var imageAssessment: UIImageView!
    @IBOutlet weak var labelAssessmentName: UILabel!
    @IBOutlet weak var labelValue1: UILabel!
    @IBOutlet weak var labelValue2: UILabel!
    @IBOutlet weak var labelValue3: UILabel!
    
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
    
    
    func setValue(_ fitnessAssessment: AnyObject  , assessmentDate: String , row: Int , index: Int , dateArray:[String] , colors:[UIColor]){
        imageAssessment.tag = row
        guard let fitnessAssessments  = fitnessAssessment as? FitnessAssesment else {return}
        
        if row == 0{
            labelValue1.isHidden = false
            labelValue2.isHidden = false
            labelValue3.isHidden = false
            labelAssessmentName.text = ""
            if index == 0{
                labelValue1.isHidden = true
                labelValue2.text = dateArray[1]
                labelValue3.isHidden = true
                imageAssessment.isHidden = true
            }else{
                labelValue1.text = dateArray[0]
                labelValue2.text = dateArray[1]
                labelValue3.text = dateArray[2]
                imageAssessment.isHidden = true
            }
            
            
        }else{
            imageAssessment.isHidden = false
            labelValue1.isHidden = false
            labelValue2.isHidden = false
            labelValue3.isHidden = false
            guard let valAssessmentName  = fitnessAssessments.fitnessAssesment?[0].fitnessAssessments[row - 1].key else {return}
            labelAssessmentName.text = valAssessmentName
            if row == imageAssessment.tag{
                imageAssessment.backgroundColor = colors[row - 1]
            }
            
            print(index)
            print(row)
            print(fitnessAssessments.feedData)
            let fitnessArray = fitnessAssessments.feedData?[row - 1]
            print(fitnessArray)
            print(fitnessArray?[index])
            
            if fitnessArray?.count == 1{
                labelValue1.isHidden = true
                labelValue2.text = fitnessArray?[index]
                labelValue3.isHidden = true
                
            }else if fitnessArray?.count == 2{
                if index == 0{
                    labelValue1.text = ""
                    labelValue2.text = fitnessArray?[index]
                    labelValue3.isHidden = true
                }else{
                    labelValue1.text = fitnessArray?[index - 1]
                    labelValue2.text = fitnessArray?[index]
                    labelValue3.isHidden = true
                }
                
            }else{
                if index == 0 {
                    labelValue1.text = ""
                    labelValue2.text = fitnessArray?[index]
                    labelValue3.isHidden = true
                }else{
                    labelValue1.text = fitnessArray?[index - 1]
                    labelValue2.text = fitnessArray?[index]
                    labelValue3.text = fitnessArray?[index + 1]
                }
            }
        }
    }
    
    
    
    
}
