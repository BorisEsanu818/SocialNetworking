//
//  ClientInfoThreeViewController.swift
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


class ClientInfoThreeViewController: UIViewController, DelegateAddClientMeasurementsField , DelegateAddClientTableViewCellTextFieldEditting{
    
    //MARK::- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnNext: UIButton!
    
    //MARK::- VARIABLES
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]? = []
    var popUpAddClientMeasurementField: AddClientMeasurementsField?
    var weightInVc: AddWeighViewController?
    var boolSwitchOn = false
    var boolStandard = true
    var clientId: String?
    
    var objectMeasurement = [NSMutableDictionary()]
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        item = ["Chest" as AnyObject,"Biceps" as AnyObject,"Waist" as AnyObject,"Thigh" as AnyObject]
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
        popUpAddClientMeasurementField?.labelHeader.text = "Add Custom Measurement"
        popUpAddClientMeasurementField?.textFieldAddField.placeholderText = "Measurement Name"
    }
    
    func configureTableView(){
        
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.AddClientTableViewCell.rawValue , item: item, configureCellBlock: { [weak self] (cell, item, indexPath) in
            guard let cell = cell as? AddClientTableViewCell else {return}
            cell.delegate = self
            var measurement = ""
            guard let boolChk = self?.boolStandard else {return}
            if boolChk{
                measurement = "inches"
            }else{
                measurement = "CM"
            }
            cell.setValue(item?[indexPath.row] as? String ?? "", measurementType: measurement)
            }, configureDidSelect: { (indexPath) in
                
        })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        dataSourceTableView?.item = item ?? []
        dataSourceTableView?.cellHeight = UITableViewAutomaticDimension
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
    
    func delegateAddClientTableViewCellTextFieldEditting(_ showSkip: Bool){
        let totalItems = dataSourceTableView?.item ?? []
        if showSkip{
            for (index, rowItem)in totalItems.enumerated() {
                
                guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? AddClientTableViewCell else {return}
                let value = cell.textFieldValue.text
                if value?.characters.count > 0 && value?.trimmingCharacters(in: CharacterSet.whitespaces) != ""{
                    btnNext.setTitle("NEXT", for: UIControlState())
                    break
                }else{
                    btnNext.setTitle("SKIP", for: UIControlState())
                }
            }
            
            if totalItems.count == 0{
                btnNext.setTitle("SKIP", for: UIControlState())
            }
            
        }else{
            for (index, rowItem)in totalItems.enumerated() {
                
                guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? AddClientTableViewCell else {return}
                let value = cell.textFieldValue.text
                
                if value?.characters.count > 0 && value?.trimmingCharacters(in: CharacterSet.whitespaces) != ""{
                    btnNext.setTitle("NEXT", for: UIControlState())
                    break
                }else{
                    btnNext.setTitle("SKIP", for: UIControlState())
                }
            }
            if totalItems.count == 0{
                btnNext.setTitle("NEXT", for: UIControlState())
            }

            
        }
    }
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionAddCustomField(_ sender: UIButton) {
        popUpAddClientMeasurementField?.textFieldAddField.text = ""
        self.view.addSubview(popUpAddClientMeasurementField ?? UIView())
        showAnimate(popUpAddClientMeasurementField ?? UIView())
        popUpAddClientMeasurementField?.textFieldAddField.becomeFirstResponder()
    }
    
    
    @IBAction func btnActionNext(_ sender: UIButton) {
        if btnNext.titleLabel?.text == "NEXT"{
            gatherMeasurements()
        }else{
            let weightInVc = StoryboardScene.Main.instantiateAddWeighViewController()
            weightInVc.clientId = clientId
            self.pushVC(weightInVc)
        }
        
    }
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        popVC()
    }
    
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
    
    
    
}

extension ClientInfoThreeViewController{
    
    //MARK::- API
    
    func gatherMeasurements(){
        objectMeasurement.removeAll()
        var run = false
        let totalItems = dataSourceTableView?.item ?? []
        for (index, rowItem)in totalItems.enumerated() {
            let measurements  = NSMutableDictionary()
            guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? AddClientTableViewCell else {return}
         
            if cell.textFieldValue.text?.characters.count > 0 && cell.textFieldValue.text?.trimmingCharacters(in: CharacterSet.whitespaces) != ""{
                run = true
                guard let measuremntName = cell.labelType?.text else {return}
                measurements["key"] = measuremntName
                measurements["value"] = cell.textFieldValue.text
                measurements["unit"] = cell.labelType.text
                objectMeasurement.append(measurements)
            }
//            else{
//                run = false
//                AlertView.callAlertView("Missing Info", msg: "Please enter value for all the fields", btnMsg: "OK", vc: self)
//                break
//            }
            
            
            
        }
        print(objectMeasurement)
        if run{
          addCustomMeasurement()
        }else{
            
        }
        
        
    }
    
    func addCustomMeasurement(){
        guard let clientId = clientId else {return}
        
        let dictForBackEnd = API.ApiCreateDictionary.addClientMeasurement(clientId: clientId , measurements: objectMeasurement.toJson()).formatParameters()
        print(dictForBackEnd)
        
        ApiDetector.getDataOfURL(ApiCollection.apiAddClientMeasurement, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [unowned self] (data) in
                print(data)
                let weightInVc = StoryboardScene.Main.instantiateAddWeighViewController()
                weightInVc.clientId = clientId
                self.pushVC(weightInVc)
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
    
    
    
    
    
}
