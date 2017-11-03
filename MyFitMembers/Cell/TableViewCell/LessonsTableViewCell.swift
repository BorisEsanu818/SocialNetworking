//
//  LessonsTableViewCell.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/7/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
var btnSelected :[Int]? = []
class LessonsTableViewCell: UITableViewCell {
    
    //MARK::- OUTLETS
    
    
    @IBOutlet var btnRadioCollection: [UIButton]!
    @IBOutlet weak var labelQuestions: UILabel!
    @IBOutlet weak var labelQuestionNumber: UILabel!
    @IBOutlet weak var labelOption1: UILabel!
    @IBOutlet weak var labelOption2: UILabel!
    @IBOutlet weak var labelOption3: UILabel!
    @IBOutlet weak var labelOption4: UILabel!
    @IBOutlet weak var labelHint: UILabel!
    
    @IBOutlet weak var btnRadioButton1: UIButton!
    @IBOutlet weak var btnRadioButton2: UIButton!
    @IBOutlet weak var btnRadioButton3: UIButton!
    @IBOutlet weak var btnRadioButton4: UIButton!
    
    //MARK::- VARIABLES
    
    var boolRadioBtn1Selected = false
    var boolRadioBtn2Selected = false
    var boolRadioBtn3Selected = false
    var boolRadioBtn4Selected = false
    var onIsSelecetd = false
    var lessonArray:[QuizQuestions] = []
    var lessonRow: Int = 0
    var counter = 0
    
    var runOnce = true
    
    
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
    
    func setValue(_ lessons: [QuizQuestions] , row: Int){
        lessonRow = row
        lessonArray = lessons
        let lesson = lessons[row]
        let number = row + 1
        labelQuestionNumber.text = number.toString + "."
        labelQuestions.text = lesson.questionText
        labelHint.text = "Hint: " + (lesson.hint ?? "")
        guard let totalAnswers = lesson.lessonAns?.count else {return}
        btnRadioCollection[0].isHidden = false
        btnRadioCollection[1].isHidden = false
        btnRadioCollection[2].isHidden = false
        btnRadioCollection[3].isHidden = false
        
        btnRadioButton1.tag = row
        btnRadioButton2.tag = row
        btnRadioButton3.tag = row
        btnRadioButton4.tag = row
        
        let chk = UserDefaults.standard.value(forKey: "runAble") ?? true as Bool
        if row == 0 && (chk as AnyObject).boolValue == true{
            UserDefaults.standard.setValue(false, forKey: "runAble")
            btnSelected = []
            for elemnt in lessons{
                btnSelected?.append(5)
            }
        }else{
            
        }
        print(btnSelected)
        
        let selectedRow = btnSelected?[row] ?? 5
        
        switch selectedRow{
            
        case 1:
            btnRadioButton1.setImage(Asset.Ic_radio_btn_fill.image, for: UIControlState())
            btnRadioButton2.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioButton3.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioButton4.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
        case 2:
            btnRadioButton1.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioButton2.setImage(Asset.Ic_radio_btn_fill.image, for: UIControlState())
            btnRadioButton3.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioButton4.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
        case 3:
            btnRadioButton1.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioButton2.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioButton3.setImage(Asset.Ic_radio_btn_fill.image, for: UIControlState())
            btnRadioButton4.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            
        case 4:
            btnRadioButton1.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioButton2.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioButton3.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioButton4.setImage(Asset.Ic_radio_btn_fill.image, for: UIControlState())
            
        default:
            btnRadioButton1.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioButton2.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioButton3.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioButton4.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            
        }
        
        switch totalAnswers {
        case 1:
            labelOption1.text = lesson.lessonAns?[0].answer
            labelOption3.isHidden = true
            labelOption4.isHidden = true
            labelOption2.isHidden = true
            btnRadioCollection[1].isHidden = true
            btnRadioCollection[2].isHidden = true
            btnRadioCollection[3].isHidden = true
        case 2:
            labelOption1.text = lesson.lessonAns?[0].answer
            labelOption2.text = lesson.lessonAns?[1].answer
            btnRadioCollection[2].isHidden = true
            btnRadioCollection[3].isHidden = true
            labelOption3.isHidden = true
            labelOption4.isHidden = true
        case 3:
            labelOption1.text = lesson.lessonAns?[0].answer
            labelOption2.text = lesson.lessonAns?[1].answer
            labelOption3.text = lesson.lessonAns?[2].answer
            labelOption4.isHidden = true
            btnRadioCollection[3].isHidden = true
        case 4:
            labelOption1.text = lesson.lessonAns?[0].answer
            labelOption2.text = lesson.lessonAns?[1].answer
            labelOption3.text = lesson.lessonAns?[2].answer
            labelOption4.text = lesson.lessonAns?[3].answer
        default:
            labelOption1.text = ""
            labelOption2.text = ""
            labelOption3.text = ""
            labelOption4.text = ""
            
        }
        
    }
    
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionRadioButtonFirst(_ sender: UIButton) {
        var arrayMarks = UserDefaults.standard.value(forKey: "Marks") as? Array<Int>
        if boolRadioBtn1Selected{
            boolRadioBtn1Selected = false
            sender.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
        }else{
            boolRadioBtn4Selected = false
            boolRadioBtn3Selected = false
            boolRadioBtn2Selected = false
            boolRadioBtn1Selected = true
            btnSelected?[sender.tag] = 1
            sender.setImage(Asset.Ic_radio_btn_fill.image, for: UIControlState())
            btnRadioCollection[1].setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioCollection[2].setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioCollection[3].setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
        }
        print(sender.tag)
        print(lessonArray[lessonRow].lessonAns?[0].isCorrect)
        print(lessonArray[lessonRow].lessonAns?[0].answer)
        guard let isCorrectChk = lessonArray[lessonRow].lessonAns?[0].isCorrect else {return}
        if isCorrectChk == "true"{
            print(sender.tag)
            arrayMarks?[sender.tag] = 1
            //            arrayMarks?.insert(1, atIndex: sender.tag)
            
        }else{
            arrayMarks?[sender.tag] = 0
            //            arrayMarks?.insert(0, atIndex: sender.tag)
        }
        
        print(arrayMarks)
        UserDefaults.standard.setValue(arrayMarks, forKey: "Marks")
    }
    
    @IBAction func btnActionRadioButtonSecond(_ sender: UIButton) {
        var arrayMarks = UserDefaults.standard.value(forKey: "Marks") as? Array<Int>
        if boolRadioBtn2Selected{
            boolRadioBtn2Selected = false
            sender.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
        }else{
            boolRadioBtn4Selected = false
            boolRadioBtn3Selected = false
            boolRadioBtn1Selected = false
            
            boolRadioBtn2Selected = true
            btnSelected?[sender.tag] = 2
            sender.setImage(Asset.Ic_radio_btn_fill.image, for: UIControlState())
            btnRadioCollection[0].setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioCollection[2].setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioCollection[3].setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
        }
        
        guard let isCorrectChk = lessonArray[lessonRow].lessonAns?[1].isCorrect else {return}
        print(sender.tag)
        print(lessonArray[lessonRow].lessonAns?[1].isCorrect)
        print(lessonArray[lessonRow].lessonAns?[1].answer)
        if isCorrectChk == "true"{
            arrayMarks?[sender.tag] = 1
            //            arrayMarks?.insert(1, atIndex: sender.tag)
        }else{
            arrayMarks?[sender.tag] = 0
            //            arrayMarks?.insert(0, atIndex: sender.tag)
        }
        print(arrayMarks)
        UserDefaults.standard.setValue(arrayMarks, forKey: "Marks")
    }
    
    @IBAction func btnActionRadioButtonThird(_ sender: UIButton) {
        var arrayMarks = UserDefaults.standard.value(forKey: "Marks") as? Array<Int>
        if boolRadioBtn3Selected{
            boolRadioBtn3Selected = false
            sender.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
        }else{
            boolRadioBtn4Selected = false
            boolRadioBtn2Selected = false
            boolRadioBtn1Selected = false
            
            boolRadioBtn3Selected = true
            
            btnSelected?[sender.tag] = 3
            
            
            sender.setImage(Asset.Ic_radio_btn_fill.image, for: UIControlState())
            btnRadioCollection[0].setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioCollection[3].setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioCollection[1].setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
        }
        
        guard let isCorrectChk = lessonArray[lessonRow].lessonAns?[2].isCorrect else {return}
        print(sender.tag)
        print(lessonArray[lessonRow].lessonAns?[2].isCorrect)
        print(lessonArray[lessonRow].lessonAns?[2].answer)
        if isCorrectChk == "true"{
            arrayMarks?[sender.tag] = 1
            //           arrayMarks?.insert(1, atIndex: sender.tag)
        }else{
            arrayMarks?[sender.tag] = 0
            //           arrayMarks?.insert(0, atIndex: sender.tag)
        }
        print(arrayMarks)
        UserDefaults.standard.setValue(arrayMarks, forKey: "Marks")
    }
    
    
    @IBAction func btnActionRadioButtonFourth(_ sender: UIButton) {
        var arrayMarks = UserDefaults.standard.value(forKey: "Marks") as? Array<Int>
        if boolRadioBtn4Selected{
            boolRadioBtn4Selected = false
            sender.setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
        }else{
            boolRadioBtn4Selected = true
            sender.setImage(Asset.Ic_radio_btn_fill.image, for: UIControlState())
            boolRadioBtn3Selected = false
            boolRadioBtn2Selected = false
            boolRadioBtn1Selected = false
            
            btnSelected?[sender.tag] = 4
            
            btnRadioCollection[0].setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioCollection[2].setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
            btnRadioCollection[1].setImage(Asset.Ic_radio_btn_blank.image, for: UIControlState())
        }
        
        guard let isCorrectChk = lessonArray[lessonRow].lessonAns?[3].isCorrect else {return}
        print(sender.tag)
        print(lessonArray[lessonRow].lessonAns?[3].isCorrect)
        print(lessonArray[lessonRow].lessonAns?[3].answer)
        if isCorrectChk == "true"{
            arrayMarks?[sender.tag] = 1
            //            arrayMarks?.insert(1, atIndex: sender.tag)
        }else{
            arrayMarks?[sender.tag] = 0
            //            arrayMarks?.insert(0, atIndex: sender.tag)
        }
        print(arrayMarks)
        UserDefaults.standard.setValue(arrayMarks, forKey: "Marks")
    }
    
}
