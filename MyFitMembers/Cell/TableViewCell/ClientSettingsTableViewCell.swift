//
//  ClientSettingsTableViewCell.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 23/11/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

protocol DelegateClientSettingsTableViewCellNotificationSwitchClicked {
    func sendNotificationType(_ type:String , boolOn: Bool)
}

class ClientSettingsTableViewCell: UITableViewCell {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var labelNotificationType: UILabel!
    @IBOutlet weak var switchNotofication: UISwitch!
    
    //MARK::- VARIABLES
    var delegate: DelegateClientSettingsTableViewCellNotificationSwitchClicked?
    let notificationTypes = ["message" ,"foodReminder"]
    
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
    
    func setData(_ row:Int , notificationName:String){
        switchNotofication.tag = row
        labelNotificationType.text = notificationName
    }
    
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionSwitch(_ sender: UISwitch) {
        delegate?.sendNotificationType(notificationTypes[sender.tag] , boolOn: sender.isOn)
    }
    
    
}
