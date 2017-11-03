//
//  LessonCollectionTableViewCell.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/7/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import AVFoundation

protocol DelegateShowVideo {
    func delegatePlayVideo(_ index:Int)
}

class LessonCollectionTableViewCell: UITableViewCell {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var labelLessonCount: UILabel!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelVideoLength: UILabel!
    
    @IBOutlet weak var labelLessonDescription: UILabel!
    
    
    @IBOutlet weak var clientCompleted: UILabel!
    @IBOutlet weak var labelLessonCompleted: UILabel!
    @IBOutlet weak var labelCompleted: UILabel!
    
    @IBOutlet weak var btnPlayVideo: UIButton!
    @IBOutlet weak var imageVideo: UIImageView!
    
    //MARK::- VARIABLES
    
    var delegate:DelegateShowVideo?
    
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
    
    func setValue(_ lessonData: Lesson , row: Int){
        let rowNum = row + 1
        labelLessonCount.text = "Lesson " + rowNum
            .toString
        labelName.text = lessonData.lessonName
        labelLessonDescription.text = lessonData.lessonDescription
        labelVideoLength.text = lessonData.lessonLength
        btnPlayVideo.tag = row
        if lessonData.isComplete == 0{
            labelLessonCompleted.isHidden = true
        }else{
            labelLessonCompleted.isHidden = false
        }
        guard let imageUrl = lessonData.videoImg?.userOriginalImage else {return}
        let imgUrl = ApiCollection.apiImageBaseUrl + imageUrl
        guard let url = URL(string: imgUrl) else {return}
        imageVideo.yy_setImage(with: url, options: .progressiveBlur)
        clientCompleted.text = "Clients Completed (" + (lessonData.client?.count.toString ?? "0") + "):"
        guard let urlForImage = lessonData.videoImg?.userOriginalImage else {return}
        guard let videoImageUrl = URL(string: ApiCollection.apiImageBaseUrl +  urlForImage ) else {return}
//        guard let videoImageUrl = NSURL(string: "https://www.youtube.com/watch?v=jgvLkIc_MMY" ) else {return}
        
//        let videoImage = thumbnailForVideoAtURL(videoImageUrl)
//        imageVideo.image = videoImage
        
    }
    
    fileprivate func thumbnailForVideoAtURL(_ url: URL) -> UIImage? {
        
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return nil
        }
    }
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionShowVideo(_ sender: UIButton) {
        delegate?.delegatePlayVideo(sender.tag)
    }
    
}
