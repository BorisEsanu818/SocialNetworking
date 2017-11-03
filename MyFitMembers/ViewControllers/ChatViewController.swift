//
//  ChatViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 9/26/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import IQKeyboardManager

var boolEnterBackGround = false
class ChatViewController: UIViewController  , UITextViewDelegate{
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var viewBottom: UIView!{
        didSet{
            viewBottom.layer.shadowRadius = 2.0
            viewBottom.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
            viewBottom.layer.shadowColor = UIColor.black.cgColor
            viewBottom.layer.shadowOpacity = 1.0
            viewBottom.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var labelNoMessageFound: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintHeightViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var constraintBottomTextView: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    
    
    //MARK::- VARIABLES
    var tableViewDataSource: DataSourceTableViewMoreCells?
    var item = [MessageListing]()
    var clientId:String?
    var kbHeight : CGFloat = 216.0
    var tabbarHeight : CGFloat = 0.0
    var placeholderLabel = UILabel()
    var timer = Timer()
    var userName: String?
    var otherUserImage:String?
    var lastTime: String?
    var name: String?
    
    //MARK::- OVVERIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTouch()
        chkNetworkIsAvailable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        boolPopSelf = false
        setupChatTexView()
        setUpSideBar(false,allowRighSwipe: false)
        getRecentChats(true)
        setUpKeyboardNotifications()
        IQKeyboardManager.shared().isEnabled = false
        labelUserName.text = userName ?? ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        IQKeyboardManager.shared().isEnabled = true
        timer.invalidate()
    }
    
    
    //MARK::- FUNCTIONS
    
    
    
    func configureTableView(){
        tableViewDataSource = DataSourceTableViewMoreCells(tableView: tableView, cell: CellIdentifiers.UserChatTableViewCell.rawValue, item: item, configureCellBlock: { (cell, item, indexPath) in
            
            }, configureDidSelect: { (indexPath) in
                
        })
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return}
        
        if isClient{
            let trainerDetail = UserDefaults.standard.rm_customObject(forKey: "TrainerChatInfo") as? TrainerInfo
            
            self.labelUserName.text = trainerDetail?.trainerName
            
            self.otherUserImage = trainerDetail?.userImage?.userOriginalImage
            tableViewDataSource?.otherUserImage = self.otherUserImage
            tableViewDataSource?.userImg = UserDataSingleton.sharedInstance.loggedInUser?.userImage?.userOriginalImage
        }else{
            tableViewDataSource?.otherUserImage = otherUserImage
            tableViewDataSource?.userImg = UserDataSingleton.sharedInstance.loggedInUser?.userImage?.userOriginalImage
            
        }
        print(tableViewDataSource?.otherUserImage)
        print(tableViewDataSource?.userImg)
        tableView.delegate = tableViewDataSource
        tableView.dataSource = tableViewDataSource
        tableView.reloadData()
    }
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        dismissKeyboard()
        popVC()
    }
    
    
    @IBAction func btnActionSend(_ sender: UIButton) {
        labelNoMessageFound.isHidden = true
        if isConnectedToNetwork(){
            if textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" {
                guard let clientId = clientId else {return}
                let messageToAppend = MessageListing()
                messageToAppend.message = textView.text
                let date = Foundation.Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                formatter.timeZone =  TimeZone(secondsFromGMT: 0)
                messageToAppend.messageCreatedAt = formatter.string(from: date)
                print("dateee",messageToAppend.messageCreatedAt)
                messageToAppend.messageFrom = UserDataSingleton.sharedInstance.loggedInUser?.userId
                messageToAppend.messageTo = clientId
                appendMessage(messageToAppend)
                UIView.animate(withDuration: 0.1, animations: { [weak self] in
                    self?.constraintHeightViewBottom.constant = 48
                    self?.view.layoutIfNeeded()
                    self?.view.updateConstraints()
                    self?.placeholderLabel.isHidden = !(self?.textView.text == "")
                    
                    })
                print(textView.text)
                sendMessage(messageToAppend.message ?? "")
            }else{
                
            }
        }else{
            
            
            
        }
        
    }
    
}

extension ChatViewController{
    
    func updateArray(_ messageArray: [MessageListing]){
        for messageToAppend in messageArray{
            appendMessage(messageToAppend)
        }
    }
    
    func appendMessage(_ messageToAppend:MessageListing){
        self.item.append(messageToAppend)
        self.tableViewDataSource?.messages.append(messageToAppend)
        tableView.beginUpdates()
        tableView?.insertRows(at: [IndexPath(row: (self.tableViewDataSource?.messages.count ?? 1) - 1, section: 0)], with:UITableViewRowAnimation.none)
        tableView.endUpdates()
        textView.text = ""
        print(messageToAppend.messageCreatedAt)
        scrollToBottom()
        print(self.item)
        print(self.tableViewDataSource?.messages)
    }
    
    func getRecentChats(_ showLoadr: Bool){
        guard let clientId = clientId else {return}
        var dictForBackEnd: OptionalDictionary?
        var url = ""
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return}
        if isClient{
            url = ApiCollection.apiClientChatMessages
            dictForBackEnd = API.ApiCreateDictionary.clientMessagesListing(userId: clientId).formatParameters()
            print(dictForBackEnd)
        }else{
            url = ApiCollection.apiChatMessages
            dictForBackEnd = API.ApiCreateDictionary.trainerMessagesListing(userId: clientId).formatParameters()
            print(dictForBackEnd)
        }
        
        ApiDetector.getDataOfURL(url, dictForBackend: dictForBackEnd ?? [:], failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                guard let messageArray = data as? [MessageListing] else {return}
                if messageArray.count == 0{
                    self?.labelNoMessageFound.isHidden = false
                    self?.getRecentChats(false)
                }else{
                    self?.polling()
                    self?.labelNoMessageFound.isHidden = true
                }
                self?.lastTime = messageArray.last?.messageCreatedAt
                
                self?.item = messageArray
                self?.configureTableView()
                self?.scrollToBottom()
                
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: showLoadr, loaderColor: Colorss.darkRed.toHex())
    }
    
    
    func sendMessage(_ messageText: String){
        var dictForBackEnd: OptionalDictionary?
        guard let clientId = clientId else {return}
        
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return}
        var url = ""
        
        if isClient{
            url = ApiCollection.apiClientSendMessage
            dictForBackEnd = API.ApiCreateDictionary.cliemtSendMessage(otherUserId: clientId, message: messageText).formatParameters()
            
        }else{
            url = ApiCollection.apiSendMessage
            dictForBackEnd = API.ApiCreateDictionary.sendMessage(otherUserId: clientId, message: messageText).formatParameters()
        }
        print(dictForBackEnd)
        resendMessage(dictForBackEnd , url: url)
    }
    
    func resendMessage(_ dictForBackEnd: OptionalDictionary? , url: String){
        ApiDetector.getDataOfURL(url, dictForBackend: dictForBackEnd ?? [:], failure: { [weak self] (data) in
            print(data)
            self?.resendMessage(dictForBackEnd , url: url)
            }, success: { [weak self] (data) in
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: false, loaderColor: Colorss.darkRed.toHex())
    }
    
    func scrollToBottom(){
        if self.item.count > 0{
            ez.runThisAfterDelay(seconds: 0.1, after: {
                let itemCount = self.item.count
                print(itemCount)
                if itemCount > 1{
                    self.tableView?.scrollToRow(at: IndexPath(row: itemCount - 1, section: 0), at: .top, animated: true)
                }else{
                    self.tableView?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
                
            })
        }
    }
    
    func polling(){
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(ChatViewController.pollMessages), userInfo: nil, repeats: true)
    }
    
    func pollMessages(){
        let time = lastTime ?? ""
        guard let clientId = clientId else {return}
        var dictForBackEnd: OptionalDictionary?
        var url = ""
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return}
        if isClient{
            url = ApiCollection.apiClientChatMessages
            dictForBackEnd = API.ApiCreateDictionary.clientPollMessages(otherUserId: clientId, messageTime: time).formatParameters()
        }else{
            url = ApiCollection.apiChatMessages
            dictForBackEnd = API.ApiCreateDictionary.pollMessages(otherUserId: clientId, messageTime: time).formatParameters()
        }
        
        print(dictForBackEnd)
        if isConnectedToNetwork(){
            
            ApiDetector.getDataOfURL(url , dictForBackend: dictForBackEnd ?? [:], failure: { (data) in
                print(data)
                }, success: { [weak self] (data) in
                    guard let messageArray = data as? [MessageListing] else {return}
                    
                    if messageArray.count > 0{
                        self?.lastTime = messageArray.last?.messageCreatedAt
                        self?.updateArray(messageArray)
                    }else{
                        
                    }
                    
                }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: false, loaderColor: Colorss.darkRed.toHex())
        }else{
        }
    }
    
}


extension ChatViewController{
    
    func setUpKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: self.view?.window)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: self.view?.window)
    }
    
    func keyboardWillShow(_ n : Notification){
        if let userInfo = n.userInfo{
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue)
            let rect = keyboardFrame.cgRectValue
            kbHeight = CGFloat(rect.height) - tabbarHeight
            self.setOffset(hide: false)
        }
        
    }
    func keyboardWillHide (_ n : Notification){
        self.setOffset(hide: true)
    }
    
    
    func setOffset (hide : Bool){
        if (hide)
        {
            self.constraintBottomTextView?.constant = 0
            UIView.animate(withDuration: 0, animations: { () -> Void in
                self.view.layoutIfNeeded()
                }, completion: { (animated) -> Void in
            })
        }
        else
        {
            self.constraintBottomTextView?.constant = kbHeight
            UIView.animate(withDuration: 0, animations: { () -> Void in
                self.view.layoutIfNeeded()
                }, completion: { (animated) -> Void in
                    self.scrollToLastMessage(animated: false)
            })
        }
    }
    
    func hideKeyboardOnTouch(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func scrollToLastMessage(animated : Bool){
        
        DispatchQueue.main.async { () -> Void in
            let bottomOffset = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.bounds.size.height)
            if bottomOffset.y > 0{
                self.tableView.setContentOffset(bottomOffset, animated: animated)
            }
        }
    }
    
    func chkNetworkIsAvailable(){
        ez.runThisEvery(seconds: 3.0, startAfterSeconds: 0.0) { [weak self] (timer) in
            let btnView = UIView(frame: self?.btnSend?.frame ?? CGRect(x: 0.0, y: 0.0, w: 0.0, h: 0.0))
            if isConnectedToNetwork(){
                self?.btnSend.isEnabled = true
                self?.btnSend.addSubview(btnView)
            }else{
                self?.btnSend.isEnabled = false
                btnView.removeFromSuperview()
            }
        }
    }
    
    
}


extension ChatViewController{
    
    //MARK::- TEXTVIEW SETUP
    
    func textViewDidChange(_ textView: UITextView) {
        
        
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        let cursorPosition = textView.caretRect(for: textView.selectedTextRange!.start).origin
        let currentLine = Int(cursorPosition.y / textView.font!.lineHeight)
        print("currentline",currentLine)
        switch currentLine {
        case 1, 2, 3, 4:
            UIView.animate(withDuration: 0.3, animations: {  [weak self] in
                self?.constraintHeightViewBottom.constant = textView.contentSize.height + 8
                print("constraintHeightBottomView",self?.constraintHeightViewBottom.constant)
                self?.view.layoutIfNeeded()
                self?.view.updateConstraints()
            }) 
            
        case 0:
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.constraintHeightViewBottom.constant = 48
                self?.textView.layoutIfNeeded()
                self?.view.updateConstraints()
                })
            
            
        default: break
        }
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    func setupChatTexView() {
        textView.inputAccessoryView = UIView()
        textView.delegate = self
        placeholderLabel.text = "Write a message..."
        placeholderLabel.font = UIFont(name: "AvenirNext-Medium", size: 14.0)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: textView.font!.pointSize/2)
        placeholderLabel.textColor = UIColor(colorLiteralRed: 178/255, green: 178/255, blue: 178/255, alpha: 1.0)
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
}
