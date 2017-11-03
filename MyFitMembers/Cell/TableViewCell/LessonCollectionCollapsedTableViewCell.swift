//
//  LessonCollectionCollapsedTableViewCell.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/7/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit


class LessonCollectionCollapsedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelLessonCount: UILabel!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var imageLessonStatus: UIImageView!
    
    @IBOutlet weak var labelVideoLength: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setValue(_ lesson: AnyObject , row: Int){
        guard let data = lesson as? Lesson else {return}
        let count = row + 1
        
        labelLessonCount.text = "Lesson " + count.toString
        labelName.text = data.lessonName
        labelVideoLength.text = data.lessonDescription
        labelVideoLength.text = data.videoLength
        if data.isComplete == 0 && data.isOpen == 0{
            imageLessonStatus.isHidden = false
            imageLessonStatus.image = UIImage(named: "ic_lock_1")
        }else if data.isComplete == 1 && data.isOpen == 1{
            imageLessonStatus.isHidden = false
            imageLessonStatus.image = UIImage(named: "ic_tick")
        }else if data.isComplete == 0 && data.isOpen == 1{
            imageLessonStatus.isHidden = false
            imageLessonStatus.image = UIImage(named: "ic_lock_0")
        }else{
            imageLessonStatus.isHidden = false
            imageLessonStatus.image = UIImage(named: "ic_lock_0")
        }
    }
    
    
    
}
