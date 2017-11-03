//
//  AddWeighViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 07/11/16.
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


class AddWeighViewController: UIViewController {
    
    //MARK::- OUTLETS
    @IBOutlet weak var textFieldWeight: UITextField!
    
    @IBOutlet weak var labelUnit: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    //MARK::- VARIABLES
    
    var fitnessAssessmentVc: FitnessAssessmentViewController?
    var clientId: String?
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionSwitch(_ sender: UISwitch) {
        if sender.isOn{
            labelUnit.text = "kg"
        }else{
            labelUnit.text = "lbs"
        }
        
    }
    
    @IBAction func btnActionNext(_ sender: UIButton) {
        if btnNext.titleLabel?.text == "NEXT"{
            gatherData()
        }else{
            let fitnessAssessmentVc = StoryboardScene.Main.instantiateFitnessAssessmentViewController()
            fitnessAssessmentVc.clientId = clientId
            self.pushVC(fitnessAssessmentVc)
        }
        
    }
    
    @IBAction func btnActionTextField(_ sender: UITextField) {
        if sender.text?.characters.count > 0 && sender.text?.trimmingCharacters(in: CharacterSet.whitespaces) != ""{
            btnNext.setTitle("NEXT", for: UIControlState())
        }else{
            btnNext.setTitle("SKIP", for: UIControlState())
        }
    }
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        popVC()
    }
}


extension AddWeighViewController{
    
    //MARK::- API
    
    func gatherData(){
        if textFieldWeight.text?.characters.count > 0 && textFieldWeight.text?.trimmingCharacters(in: CharacterSet.whitespaces) != ""{
            addCustomMeasurement(textFieldWeight.text ?? "")
        }else{
            AlertView.callAlertView("", msg: "Missing info", btnMsg: "OK", vc: self)
        }
    }
    
    
    func addCustomMeasurement(_ weight: String){
        guard let clientId = clientId , let unit = labelUnit.text else {return}
        let dictForBackEnd = API.ApiCreateDictionary.addWeight(clientId: clientId, weight: weight , unit: unit).formatParameters()
        print(dictForBackEnd)
        ApiDetector.getDataOfURL(ApiCollection.apiAddWeight, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [unowned self] (data) in
                print(data)
                let fitnessAssessmentVc = StoryboardScene.Main.instantiateFitnessAssessmentViewController()
                fitnessAssessmentVc.clientId = clientId
                self.pushVC(fitnessAssessmentVc)
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
    
    
}
