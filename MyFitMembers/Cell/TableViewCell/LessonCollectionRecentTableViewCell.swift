//
//  LessonCollectionRecentTableViewCell.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/7/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import AVFoundation

protocol DelegateGoToQuiz {
    func quizClicked(_ lessonId: String)
}

class LessonCollectionRecentTableViewCell: UITableViewCell {

//MARK::- OUTLETS
    
    @IBOutlet weak var labelLessonNumber: UILabel!
    @IBOutlet weak var labelLessonName: UILabel!
    
    @IBOutlet weak var labelLesoonCompletedDate: UILabel!
    
    @IBOutlet weak var imageVideo: UIImageView!
    
    @IBOutlet weak var labelDescription: UILabel!
    
    @IBOutlet weak var labelVideoLength: UILabel!
    
    @IBOutlet weak var labelCompleted: UILabel!
    
//MARK::- VARIABLES
   
    var delegate:DelegateGoToQuiz?
    var lessonId: String?
    
    
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
    
    func setValue(_ lessonData: Lesson , row:Int){
        lessonId = lessonData.lessonId
        let rowNum = row + 1
        labelLessonNumber.text = "Lesson " + rowNum.toString
        labelLessonName.text = lessonData.lessonName
        labelDescription.text = lessonData.lessonDescription
        if lessonData.isComplete == 0{
            labelLesoonCompletedDate.isHidden = true
        }else{
            labelLesoonCompletedDate.isHidden = false
        }
        labelVideoLength.text = lessonData.lessonLength
        guard let imageUrl = lessonData.videoImg?.userOriginalImage else {return}
        let imgUrl = ApiCollection.apiImageBaseUrl + imageUrl
        guard let url = URL(string: imgUrl) else {return}
        imageVideo.yy_setImage(with: url, options: .progressiveBlur)
        labelCompleted.text = "Clients Completed (" + (lessonData.client?.count.toString ?? "0") + "):"
        guard let urlForImage = lessonData.videoImg?.userOriginalImage else {return}
        guard let videoImageUrl = URL(string: ApiCollection.apiImageBaseUrl +  urlForImage ) else {return}
//         guard let videoImageUrl = NSURL(string: "https://www.youtube.com/watch?v=jgvLkIc_MMY" ) else {return}
//        let videoImage = getThumbnailFromVideo()
//        let videoImage = generateThumbImage(videoImageUrl)
//        print(videoImageUrl)
//        imageVhttps://i.diawi.com/GB4Zdkideo.image = videoImage
    }
    
   
    
//MARK::- ACTIONS
    
    @IBAction func btnActionShowVideo(_ sender: UIButton) {
        guard let lessonId = lessonId else {return}
        delegate?.quizClicked(lessonId)
    }
    
    @IBAction func btnActionTakeTheQuiz(_ sender: UIButton) {
        guard let lessonId = lessonId else {return}
        delegate?.quizClicked(lessonId)
    }
    
}
