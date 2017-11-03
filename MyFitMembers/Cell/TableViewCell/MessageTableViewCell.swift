//
//  MessageTableViewCell.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 9/23/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var imageUser: UIImageView!{
        didSet{
            imageUser.layer.cornerRadius = imageUser.frame.height/2
        }
    }
    
    @IBOutlet weak var labelMessageTime: UILabel!
    @IBOutlet weak var labelUserStatus: UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelMessageCount: UILabel!{
        didSet{
            labelMessageCount.layer.cornerRadius = labelMessageCount.frame.height/2
        }
    }
    
    //MARK::- VARIABLES
    var userId: String?
    
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
    
    func setData(_ message: Message){
        labelUserName.text = message.userName
        
        let messageDate = changeStringDateFormat1(message.messageTime ?? "",fromFormat:"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",toFormat:"MM/dd/yyyy")
        let messageDateFormatted = messageDate.toLocalTime()
        let messageTyme =  messageDateFormatted.changeFormatOnly("h:mm a", date: messageDateFormatted)
        
        labelMessageTime.text = messageTyme
        guard let count = message.count else {return}
        if count == 0{
            labelMessageCount.isHidden = true
        }else{
            labelMessageCount.isHidden = false
        }
        labelMessageCount.text = message.count?.toString
        labelUserStatus.text = message.message
        guard let imgUrl = message.userImage?.userOriginalImage else {return}
        if imgUrl == ""{
            
        }else{
            guard let imageUrl = URL(string: ApiCollection.apiImageBaseUrl +  imgUrl) else {return}
            print(imageUrl)
            imageUser.yy_setImage(with: imageUrl, options: .progressiveBlur)
        }
        
    }
    
    //MARK::- ACTIONS
    
    
}
