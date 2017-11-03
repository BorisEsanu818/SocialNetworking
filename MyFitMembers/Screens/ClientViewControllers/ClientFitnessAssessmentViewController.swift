//
//  ClientFitnessAssessmentViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/18/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import EZSwiftExtensions
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


protocol AddNewFitnessToExistingChart {
    func addFitness()
}

class ClientFitnessAssessmentViewController: UIViewController , DelegateAddClientMeasurementsField {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelSeconds: UILabel!
    @IBOutlet weak var labelMinutes: UILabel!
    @IBOutlet weak var progressViewStopWatch: KDCircularProgress!
    @IBOutlet weak var labelStopWatchStatus: UILabel!
    
    @IBOutlet weak var btnAddCustomField: UIButton!
    
    //MARK::- VARIABLES
    var currentCount = 0.0
    let maxCount = 6000.0
    var boolStart = 0
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]? = []
    var popUpAddCustomFitnessField: AddFitnessAssessmentFieldPopUp?
    var clientGoalsVc: ClientGoalsViewController?
    var startTime = TimeInterval()
    var timer = Timer()
    var timer2 = Timer()
    var secondCounter = 0
    var minutess = 59
    var objectMeasurement = [NSMutableDictionary()]
    var clientId: String?
    var delegate: AddNewFitnessToExistingChart?
    var allowAddAssess:Bool?
    
    //MARK::- OVERRIDE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressViewStopWatch.angle = 0
        
        instantiateControllers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handleCustomFieldButton()
        print(self.item)
        configureTableView()
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        popUpAddCustomFitnessField?.removeFromSuperview()
    }
    
    //MARK::- FUNCTIONS
    
    func handleCustomFieldButton(){
        guard let allowAddAssess = allowAddAssess else {return}
        if allowAddAssess{
            btnAddCustomField.isHidden = false
        }else{
            btnAddCustomField.isHidden = true
        }
    }
    
    func instantiateControllers(){
        popUpAddCustomFitnessField = AddFitnessAssessmentFieldPopUp(frame: self.view.frame)
        popUpAddCustomFitnessField?.delegate = self
        popUpAddCustomFitnessField?.labelHeader.text = "Add Custom Fitness Test"
        clientGoalsVc = StoryboardScene.Main.instantiateClientGoalsViewController()
    }
    
    func newAngle() -> Float {
        return Float(360 * (currentCount / maxCount))
    }
    
    func updateTime() {
        ez.runThisInBackground {
            
            self.currentCount += 1
            let newAngleValue = self.newAngle()
            let currentTime = Foundation.Date.timeIntervalSinceReferenceDate
            
            var elapsedTime: TimeInterval = currentTime - self.startTime
            
            let minutes = UInt8(elapsedTime / 60.0)
            elapsedTime -= (TimeInterval(minutes) * 60)
            
            let seconds = UInt8(elapsedTime)
            elapsedTime -= TimeInterval(seconds)
            
            let fraction = UInt8(elapsedTime * 100)
            let strFraction = String(format: "%02d", fraction)
            ez.runThisInMainThread {
                
                
                if self.minutess == 60{
                    self.labelSeconds.text = ".00"
                    self.progressViewStopWatch.animateToAngle(newAngleValue, duration: 0.0, completion: nil)
                }else{
                    self.labelSeconds.text = ".\(strFraction)"
                    self.progressViewStopWatch.animateToAngle(newAngleValue, duration: 0.0, completion: nil)
                }
                
            }
            
        }
    }
    
    func updateClock(){
        
        self.minutess = self.minutess - 1
        
        ez.runThisInMainThread { [unowned self ] in
            
            if self.minutess < 10{
                self.labelMinutes.text = "00:0\(self.minutess)"
            }else{
                self.labelMinutes.text = "00:\(self.minutess)"
            }
            
            if self.minutess == -1{
                self.minutess = 60
                self.timer2.invalidate()
                self.timer.invalidate()
                self.timer.invalidate()
                self.progressViewStopWatch.animateToAngle(0, duration: 0.0, completion: nil)
                self.labelMinutes.text = "01:00"
                self.labelSeconds.text = ".00"
                self.labelStopWatchStatus.text = "RESET"
                self.boolStart = 2
                self.currentCount = 0
            }else{}
        }
    }
    
    func configureTableView(){
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.FitnessAssessmentFieldTableViewCell.rawValue , item: item, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? FitnessAssessmentFieldTableViewCell else {return}
            cell.setValue(item?[indexPath.row] as? String ?? "", measurementType: "Inch")
            }, configureDidSelect: { (indexPath) in
        })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        dataSourceTableView?.item = item ?? []
        dataSourceTableView?.cellHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }
    
    //MARK::- DELEGATE
    
    func delegateAddClientMeasurementsField(_ fieldName:String){
        tableView.beginUpdates()
        self.item?.append(fieldName as AnyObject)
        dataSourceTableView?.item = self.item ?? []
        guard let row = self.item?.count  else {return}
        tableView.insertRows(at: [IndexPath(row: row - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionAddCustomField(_ sender: UIButton) {
        guard let allowAddAssess = allowAddAssess else {return}
        if allowAddAssess{
            popUpAddCustomFitnessField?.textFieldAddField.becomeFirstResponder()
            popUpAddCustomFitnessField?.textFieldAddField.text = ""
            self.view.addSubview(popUpAddCustomFitnessField ?? UIView())
            showAnimate(popUpAddCustomFitnessField ?? UIView())
        }else{
            AlertView.callAlertView("", msg: "You are not allowed to add custom fields", btnMsg: "OK", vc: self)
        }
        
        
    }
    
    //MARK::- ACTIONS
    @IBAction func btnActionStartStopWatch(_ sender: UIButton) {
        if boolStart == 0{
            let aSelector : Selector = #selector(FitnessAssessmentViewController.updateTime)
            
            self.timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(FitnessAssessmentViewController.updateClock), userInfo: nil, repeats: true)
            self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            
            RunLoop.main.add(timer2, forMode: RunLoopMode.commonModes)
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
            self.startTime = Foundation.Date.timeIntervalSinceReferenceDate
            boolStart = 1
            labelStopWatchStatus.text = "STOP"
            self.labelMinutes.text = "00:60"
        }else if boolStart == 1{
            //            progressViewStopWatch.animateToAngle(0, duration: 0.0, completion: nil)
            timer.invalidate()
            timer2.invalidate()
            boolStart = 2
            labelStopWatchStatus.text = "RESET"
            currentCount = 0
            
        }else{
            timer.invalidate()
            timer2.invalidate()
            progressViewStopWatch.animateToAngle(0, duration: 0.0, completion: nil)
            labelMinutes.text = "01:00"
            labelSeconds.text = ".00"
            labelStopWatchStatus.text = "START"
            boolStart = 0
            self.minutess = 60
        }
    }
    
    @IBAction func btnActionNext(_ sender: UIButton) {
        gatherMeasurements()
    }
    
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        popVC()
    }
    
    
}

extension ClientFitnessAssessmentViewController{
    
    //MARK::- API
    
    func gatherMeasurements(){
        objectMeasurement.removeAll()
        var run = false
        let totalItems = dataSourceTableView?.item ?? []
        for (index, rowItem)in totalItems.enumerated() {
            var measurements  = NSMutableDictionary()
            guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? FitnessAssessmentFieldTableViewCell else {return}
            
            if cell.textFieldValue.text?.characters.count > 0 && cell.textFieldValue.text?.trimmingCharacters(in: CharacterSet.whitespaces) != ""{
                run = true
                guard let measuremntName = cell.labelType?.text else {return}
                measurements["key"] = measuremntName
                measurements["value"] = cell.textFieldValue.text
                objectMeasurement.append(measurements)
            }else{
                guard let allowAddAssess = allowAddAssess else {return}
                if allowAddAssess{
                    
                }else{
                    run = false
                    AlertView.callAlertView("Missing Info", msg: "Please enter value for all the fields", btnMsg: "OK", vc: self)
                }
                
                
                break
            }
        }
        print(objectMeasurement)
        if run{
            addCustomMeasurement()
        }else{
            
        }
        
        
    }
    
    func addCustomMeasurement(){
        
        guard let jsonArray = objectMeasurement.toJson() else {return}
        let dictForBackEnd = API.ApiCreateDictionary.clientAddFitnessAssessment(assessments: jsonArray).formatParameters()
        print(dictForBackEnd)
        
        print(dictForBackEnd)
        ApiDetector.getDataOfURL(ApiCollection.apiClientAddAssessmentByClient, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [unowned self] (data) in
                print(data)
                self.getFitnessAssessment()
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
    
    
    func getFitnessAssessment(){
        let dictForBackEnd = API.ApiCreateDictionary.clientListing().formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiWeeklyAssessmentOfClient, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                let fitnessAssessmentData = data as? FitnessAssesment
                UserDataSingleton.sharedInstance.fitnessAssesment = fitnessAssessmentData
                self?.delegate?.addFitness()
                //                self?.popVC()
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
}

