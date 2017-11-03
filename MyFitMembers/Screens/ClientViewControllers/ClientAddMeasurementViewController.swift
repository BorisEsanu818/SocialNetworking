//
//  ClientAddMeasurementViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/18/16.
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


protocol BackPressed {
    func backPressed()
}
class ClientAddMeasurementViewController: UIViewController, DelegateAddClientMeasurementsField{
    
    //MARK::- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewTableViewHeader: UIView!
    @IBOutlet weak var btnAddCustomField: UIButton!
    
    
    
    //MARK::- VARIABLES
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]? = []
    var popUpAddClientMeasurementField: AddClientMeasurementsField?
    var fitnessAssessmentVc: FitnessAssessmentViewController?
    var objectMeasurement = [NSMutableDictionary()]
    var boolSwitchOn = false
    var boolStandard: Bool?
    var delegate: BackPressed?
    var allowAddMeasurement:Bool?
    var measurementUnit: String?
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instantiateControllers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        configureTableView()
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        popUpAddClientMeasurementField?.removeFromSuperview()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLayoutSubviews() {
        handleCustomFieldButton()
    }
    
    //MARK::- FUCTIONS
    
    func showShadow(_ btn: UIView){
        btn.layer.shadowRadius = 2.0
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 1.0
        btn.layer.masksToBounds = false
    }
    
    
    func instantiateControllers(){
        popUpAddClientMeasurementField = AddClientMeasurementsField(frame: self.view.frame)
        popUpAddClientMeasurementField?.delegate = self
        fitnessAssessmentVc = StoryboardScene.Main.instantiateFitnessAssessmentViewController()
        popUpAddClientMeasurementField?.labelHeader.text = "Add Custom Measurement"
        popUpAddClientMeasurementField?.textFieldAddField.placeholderText = "Measurement Name"
    }
    
    func configureTableView(){
        
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.AddClientTableViewCell.rawValue , item: item, configureCellBlock: { [weak self] (cell, item, indexPath) in
            guard let cell = cell as? AddClientTableViewCell else {return}
            var measurement =  ""
            
            guard let allowAddMeasurement = self?.allowAddMeasurement else {return}
            if allowAddMeasurement{
                guard let boolChk = self?.boolStandard else {return}
                if boolChk{
                    measurement = "inches"
                }else{
                    measurement = "CM"
                }
            }else{
                measurement = self?.measurementUnit ?? ""
            }
            cell.setValue(item?[indexPath.row] as? String ?? "", measurementType: measurement)
            }, configureDidSelect: { (indexPath) in
                
        })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        dataSourceTableView?.item = item ?? []
        dataSourceTableView?.cellHeight = UITableViewAutomaticDimension
    }
    
    func handleCustomFieldButton(){
        guard let allowAddMeasurement = allowAddMeasurement else {return}
        if allowAddMeasurement{
            btnAddCustomField.isHidden = false
            viewTableViewHeader?.frame = CGRect(x: 0, y: 0, width: DeviceDimensions.width,height: self.viewTableViewHeader.frame.height)
            tableView?.tableHeaderView = viewTableViewHeader
            
        }else{
            btnAddCustomField.isHidden = true
            viewTableViewHeader?.frame = CGRect(x: 0, y: 0, width: DeviceDimensions.width,height: 0)
            tableView?.tableHeaderView = viewTableViewHeader
        }
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
    
    @IBAction func btnActionSwitch(_ sender: UISwitch) {
        
        
        if boolSwitchOn{
            boolStandard = true
            sender.setOn(false, animated: true)
            boolSwitchOn.toggle()
        }else{
            sender.setOn(true, animated: true)
            boolStandard = false
            boolSwitchOn.toggle()
        }
        tableView.reloadData()
        
    }
    
    @IBAction func btnActionAddCustomField(_ sender: UIButton) {
        guard let allowAddMeasurement = allowAddMeasurement else {return}
        if allowAddMeasurement{
            popUpAddClientMeasurementField?.textFieldAddField.becomeFirstResponder()
            popUpAddClientMeasurementField?.textFieldAddField.text = ""
            self.view.addSubview(popUpAddClientMeasurementField ?? UIView())
            showAnimate(popUpAddClientMeasurementField ?? UIView())
        }else{
            AlertView.callAlertView("", msg: "You are not allowed to add custom fields", btnMsg: "OK", vc: self)
        }
        
    }
    
    
    @IBAction func btnActionNext(_ sender: UIButton) {
        gatherMeasurements()
    }
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        popVC()
    }
    
}

extension ClientAddMeasurementViewController{
    
    //MARK::- API
    
    func gatherMeasurements(){
        var run = false
        objectMeasurement.removeAll()
        let totalItems = dataSourceTableView?.item ?? []
        for (index, _)in totalItems.enumerated() {
            
            var measurements  = NSMutableDictionary()
            guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? AddClientTableViewCell else {return}
            
            if cell.textFieldValue.text?.characters.count > 0 && cell.textFieldValue.text?.trimmingCharacters(in: CharacterSet.whitespaces) != ""{
                run = true
                guard let measuremntName = cell.labelType?.text else {return}
                measurements["key"] = measuremntName
                measurements["value"] = cell.textFieldValue.text
                measurements["unit"] = cell.labelMeasurement.text
                objectMeasurement.append(measurements)
            }else{
                guard let allowAddMeasurement = allowAddMeasurement else {return}
                if allowAddMeasurement{
                    
                }else{
                    run = false
                    AlertView.callAlertView("Missing Info", msg: "Please enter value for all the fields", btnMsg: "OK", vc: self)
                }
            }
            
            //            let measurements  = NSMutableDictionary()
            //            guard let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? AddClientTableViewCell else {return}
            //            guard let allowAddMeasurement = allowAddMeasurement else {return}
            //            if allowAddMeasurement{
            //
            //            }else{
            //                guard let _ = cell.textFieldValue.text else {
            //                    AlertView.callAlertView("Missing Info", msg: "Please enter value for all the fields", btnMsg: "OK", vc: self)
            //                    return
            //                }
            //            }
            //
            //            guard let measuremntName = cell.labelType?.text else {return}
            //            measurements["key"] = measuremntName
            //            measurements["value"] = cell.textFieldValue.text
            //            measurements["unit"] = cell.labelMeasurement.text
            //            objectMeasurement.append(measurements)
        }
        print(objectMeasurement)
        if run{
            addCustomMeasurement()
        }else{
            
        }
        
    }
    
    func addCustomMeasurement(){
        guard let jsonArray = objectMeasurement.toJson() else {return}
        let dictForBackEnd = API.ApiCreateDictionary.clientAddFitnessMeasurements(measurements: jsonArray).formatParameters()
        print(dictForBackEnd)
        ApiDetector.getDataOfURL(ApiCollection.apiClientAddMeasurementByClient, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [unowned self] (data) in
                print(data)
                self.getClientMeasurements()
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
    
    func getClientMeasurements(){
        let dictForBackEnd = API.ApiCreateDictionary.clientListing().formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiWeeklyMeasurementOfClient, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                let fitnessAssessmentData1 = data as? FitnessAssesment1
                UserDataSingleton.sharedInstance.fitnessAssesment1 = fitnessAssessmentData1
                //                self?.popVC()
                self?.delegate?.backPressed()
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
}
