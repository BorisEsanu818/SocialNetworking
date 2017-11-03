//
//  ClientGoalsViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 9/29/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ClientGoalsViewController: UIViewController , UITextViewDelegate{
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var textViewGoal: PlaceholderTextView!
    
    @IBOutlet weak var textViewReward: PlaceholderTextView!
    
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var textViewPunishment: PlaceholderTextView!
    
    //MARK::- VARIABLES
    
    var clientId: String?
    var clientCollection = StoryboardScene.Main.instantiateClientCollectionViewController()
    
    //MARK::- OVVERIDE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewGoal.delegate = self
        textViewReward.delegate = self
        textViewPunishment.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    //MARK::- FUNCTIONS
    
    
    
    //MARK::- DELEGATE
    
    
    
    //MARK::- ACTIONS
    
    
    @IBAction func btnActionComplete(_ sender: UIButton) {
        if btnComplete.titleLabel?.text == "SKIP"{
            self.clientCollection.boolClientFinallyAdded = true
            self.pushVC(self.clientCollection)
        }else{
            getData()
        }
        
    }
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        popVC()
    }
    
}
extension ClientGoalsViewController{
    
    //MARK::- API
    func sendGoals(){
        guard let clientId = clientId else {return}
        let dictForBackEnd = API.ApiCreateDictionary.clientGoals(clientId: clientId, goal: textViewGoal.text, reward: textViewReward.text, punishment: textViewPunishment.text).formatParameters()
        print(dictForBackEnd)
        
        ApiDetector.getDataOfURL(ApiCollection.apiClientGoals, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [unowned self] (data) in
                print(data)
                self.clientCollection.boolClientFinallyAdded = true
                self.pushVC(self.clientCollection)
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
        
    }
    
    func getData(){
        if checkValue(textViewGoal) && checkValue(textViewReward) && checkValue(textViewPunishment){
            sendGoals()
        }else{
            AlertView.callAlertView("", msg: "Missing Info", btnMsg: "OK", vc: self)
        }
    }
    
    func checkValue(_ textView: PlaceholderTextView)->Bool{
        if textView.text?.characters.count > 0{
            if textView.text?.trimmingCharacters(in: CharacterSet.whitespaces) != ""{
                return true
            }else {return false}
        }else {return false}
    }
    
    
    //MARK::- TEXTVIEW DELEGATE
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
        var bool1 = false
        var bool2 = false
        var bool3 = false
        if textViewGoal.text.characters.count > 0 && textView.text?.trimmingCharacters(in: CharacterSet.whitespaces) != ""{
            bool1 = true
        }else{
            bool1 = false
        }
        
        if textViewPunishment.text.characters.count > 0 && textView.text?.trimmingCharacters(in: CharacterSet.whitespaces) != ""{
            bool2 = true
        }else{
            bool2 = false
        }
        
        if textViewReward.text.characters.count > 0 && textView.text?.trimmingCharacters(in: CharacterSet.whitespaces) != ""{
            bool3 = true
        }else{
            bool2 = false
        }
        
        if bool1 || bool2 || bool3 {
            btnComplete.setTitle("COMPLETE", for: UIControlState())
        }else{
            btnComplete.setTitle("SKIP", for: UIControlState())
        }
        return true
    }
    
}
