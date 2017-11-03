//
//  MessageViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 9/23/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController , DelegateDeleteChat {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelNODataFound: UILabel!
    
    //MARK::- VARIABLES
    
    var dataSourceTableView: MessageTableViewDataSource?
    var item:[AnyObject]? = []
    var fromPush = false
    var clientId: String?
    var clientName:String?
    var image:String?
    
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if fromPush{
            guard let id = clientId , let name = clientName , let clientImage = image else {return}
            moveToChatScreen(id , image: clientImage, name: name)
            fromPush = false
        }else{
            fromPush = false
            getRecentChats()
            setUpSideBar(false,allowRighSwipe: false)
        }
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK::- FUNCTIONS
    
    func moveToChatScreen(_ id:String , image:String , name:String){
        let chatVc = StoryboardScene.Main.instantiateChatViewController()
        chatVc.clientId = id
        chatVc.userName = name
        chatVc.otherUserImage = image
        self.navigationController?.pushViewController(chatVc, animated: false)
    }
    
    
    func configureTableView(){
        dataSourceTableView = MessageTableViewDataSource(tableView: tableView, cell: CellIdentifiers.MessageTableViewCell.rawValue , item: item, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? MessageTableViewCell else {return}
            guard let item = item as? [Message] else {return}
            cell.setData(item[indexPath.row])
            }, configureDidSelect: { [weak self] (indexPath) in
                guard let item = self?.item as? [Message] else {return}
                let chatVc = StoryboardScene.Main.instantiateChatViewController()
                chatVc.clientId = item[indexPath.row].userId
                chatVc.otherUserImage = item[indexPath.row].userImage?.userOriginalImage
                chatVc.userName = item[indexPath.row].userName
                self?.pushVC(chatVc)
            })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        dataSourceTableView?.headerHight = 0.0
        dataSourceTableView?.footerHeight = 0.0
        dataSourceTableView?.cellHeight = UITableViewAutomaticDimension
        dataSourceTableView?.delegate = self
        tableView.reloadData()
    }
    
    //MARK::- DELEGATE
    
    func deleteChat(_ row:Int){
        guard let item = item as? [Message] else {return}
        let dicrForBackEnd = API.ApiCreateDictionary.deleteChat(clientId: item[row].userId ?? "").formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiDeleteChat, dictForBackend: dicrForBackEnd, failure: { (data) in
            print(data)
            }, success: { (data) in
                print(data)
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:], showLoader: false, loaderColor: Colorss.darkRed.toHex())
    }
    
    
    //MARK::- ACTIONS
    
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        popVC()
    }
}

extension MessageViewController{
    
    //MARK::- API
    
    func getRecentChats(){
        
        let dictForBackEnd = API.ApiCreateDictionary.clientListing().formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiChatListing, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                guard let messageArray = data as? [Message] else {return}
                self?.item = messageArray
                if messageArray.count == 0{
                    self?.labelNODataFound.isHidden = false
                }else{
                    self?.labelNODataFound.isHidden = true
                }
                self?.configureTableView()
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
}
