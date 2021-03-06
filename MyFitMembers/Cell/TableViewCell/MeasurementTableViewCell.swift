//
//  MeasurementTableViewCell.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 01/11/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class MeasurementTableViewCell: UITableViewCell {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var imageAssessment: UIImageView!
    @IBOutlet weak var labelAssessmentName: UILabel!
    @IBOutlet weak var labelValue1: UILabel!
    @IBOutlet weak var labelValue2: UILabel!
    @IBOutlet weak var labelValue3: UILabel!
    
    //MARK::- VARIABLES
    
    
    open var colors: [UIColor] = [
        UIColor(red: 238/255, green: 40/255, blue: 62/255, alpha: 1),
        UIColor(red: 238/255, green: 207/255, blue: 40/255, alpha: 1),
        UIColor(red: 40/255, green: 157/255, blue: 238/255, alpha: 1),
        UIColor(red: 88/255, green: 238/255, blue: 40/255, alpha: 1),
        UIColor(red: 0.580392, green: 0.403922, blue: 0.741176, alpha: 1),
        UIColor(red: 0.54902, green: 0.337255, blue: 0.294118, alpha: 1),
        UIColor(red: 0.890196, green: 0.466667, blue: 0.760784, alpha: 1),
        UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1),
        UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1),
        UIColor(red: 0.0901961, green: 0.745098, blue: 0.811765, alpha: 1)
    ]
    
    
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
    
    
    func setValue(_ fitnessAssessment: AnyObject  , assessmentDate: String , row: Int , index: Int , dateArray:[String]){
        guard let fitnessAssessments  = fitnessAssessment as? FitnessAssesment1 else {return}
        
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
                //            }else if index == dateArray.count{
                //                labelValue1.hidden = true
                //                labelValue2.text = dateArray[dateArray.count]
                //                labelValue3.hidden = true
                //                imageAssessment.hidden = true
            }else{
                labelValue1.text = dateArray[0]
                labelValue2.text = dateArray[1]
                labelValue3.text = dateArray[2]
                imageAssessment.isHidden = true
            }
            
            
        }else{
            labelValue1.isHidden = false
            labelValue2.isHidden = false
            labelValue3.isHidden = false
            imageAssessment.isHidden = false
            guard let valAssessmentName  = fitnessAssessments.fitnessAssesment1?[0].fitnessAssessments1[row - 1].key else {return}
            labelAssessmentName.text = valAssessmentName
            imageAssessment.backgroundColor = colors[row - 1]
            print(index)
            print(row)
            print(fitnessAssessments.feedData1)
            let fitnessArray = fitnessAssessments.feedData1?[row - 1]
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
