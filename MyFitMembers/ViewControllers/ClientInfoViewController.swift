//
//  ClientInfoViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/5/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import XLPagerTabStrip
protocol DelegateClientInfoViewControllerDelete {
    func delegateClientInfoViewControllerDelete()
}

var boolPopSelf = false
var clientDeleted = false
class ClientInfoViewController: UIViewController {
    
    //MARK::- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageClient: UIImageView!{
        didSet{
            imageClient.layer.cornerRadius = imageClient.frame.height/2
        }
    }
    @IBOutlet weak var labelClientName: UILabel!
    
    
    
    //MARK::- VARIABLES
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]? = []
    var clientPagerVc: ClientPagerViewController?
    var clientName: String?
    var clientImageUrl :String?
    var clientId: String?
    var delegate: DelegateClientInfoViewControllerDelete?
    
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateControllers()
        boolPopSelf = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.setValue(clientId, forKey: "CurrentClientId")
        setInitiallyClientInfo()
        imageSetUp()
        setUpSideBar(false,allowRighSwipe: false)
        if boolPopSelf{
            getWeighIn()
        }else{}
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    //MARK::- FUCTIONS
    
    func imageSetUp(){
        print(clientImageUrl)
        guard let clientImageUrl = clientImageUrl else {return}
        let imageUrl = ApiCollection.apiImageBaseUrl + clientImageUrl
        guard let clientCreatedImageUrl = URL(string: imageUrl) else {return}
        imageClient.yy_setImage(with: clientCreatedImageUrl, placeholder: UIImage(named: "ic_placeholder"))
        //        imageClient.yy_setImageWithURL(clientCreatedImageUrl, options: .Progressive)
    }
    
    func setInitiallyClientInfo(){
        labelClientName.text = clientName
        guard let clientImageUrl = clientImageUrl else {return}
        let imageUrl = ApiCollection.baseUrl + clientImageUrl
        imageClient.yy_imageURL = URL(string: imageUrl)
        
    }
    
    func showShadow(_ btn: UIView){
        btn.layer.shadowRadius = 2.0
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 1.0
        btn.layer.masksToBounds = false
    }
    
    
    func instantiateControllers(){
        
    }
    
    func configureTableView(){
        
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.ClientInfoTableViewCell.rawValue , item: item, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? ClientInfoTableViewCell else {return}
            guard let infoType = item?[indexPath.row] as? String else {return}
            cell.setValue(infoType)
            }, configureDidSelect: { [weak self] (indexPath) in
                let clientPagerVc = StoryboardScene.Main.instantiateClientPagerViewController()
                clientPagerVc.name = self?.clientName
                clientPagerVc.selectedViewControllerIndex = indexPath.row
                self?.pushVC(clientPagerVc)
            })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        dataSourceTableView?.item = item ?? []
        dataSourceTableView?.cellHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }
    
    
    func showAlertOfNotification(_ title:String, message:String , button1Title:String, button2Title: String){
        let alertController = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: button1Title, style: UIAlertActionStyle.default) { [weak self]
            UIAlertAction in
            self?.deleteClient()
        }
        let cancelAction = UIAlertAction(title: button2Title, style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        boolPopSelf = false
        popVC()
    }
    
    @IBAction func btnActionDeleteClient(_ sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "Are you sure you want to delete this person? All data will be erased.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { [weak self] (action) in
            self?.deleteClient()
            }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnActionGoToChatScreen(_ sender: UIButton) {
        
        let chatVc = StoryboardScene.Main.instantiateChatViewController()
        chatVc.clientId = clientId
        chatVc.userName = clientName
        chatVc.otherUserImage = clientImageUrl
        self.pushVC(chatVc)
        
    }
    
    
}

extension ClientInfoViewController{
    
    //MARK::- API
    
    func getDataOfClientDetails(){
        guard let clientId = clientId else {return}
        let dictForBackEnd = API.ApiCreateDictionary.deleteClient(clientId: clientId).formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiClientDescription, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                guard let clientDescriptionData  = data as? ClientInfo else {return}
                UserDefaults.standard.setValue(clientDescriptionData.clientId, forKey: "CurrentClientId")
                guard let foodPic = clientDescriptionData.totalFoodPics  ,  let weigh = clientDescriptionData.totalWeighIn , let fitnessAssesmnt = clientDescriptionData.totalFitnesAssessments , let measure = clientDescriptionData.totalMeasurements , let selfie = clientDescriptionData.totalSelfies else {return}
                
                self?.item = ["Food Pics (\(foodPic))",
                    "Weigh-In (\(weigh))","Fitness Assessments (\(fitnessAssesmnt))","Measurements (\(measure))","Selfies (\(selfie))"]
                
                self?.configureTableView()
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
    
    func getWeighIn(){
        guard let clientId = UserDefaults.standard.value(forKey: "CurrentClientId") as? String else {return}
        let dictForBackEnd = API.ApiCreateDictionary.deleteClient(clientId: clientId).formatParameters()
        
        ApiDetector.getDataOfURL(ApiCollection.apiWeighIn, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                
                guard let weighInData = data as? [WeighIn] else {return}
                if weighInData.count > 0{
                    var dateArray = [String]()
                    var pointData = [CGFloat]()
                    var unitArray = [String]()
                    dateArray.removeAll()
                    pointData.removeAll()
                    unitArray.removeAll()
                    for values in weighInData{
                        let pt = values.weigh?.toInt()?.toCGFloat
                        let date = values.weighPicDate
                        guard let point = pt else {return}
                        pointData.append(point)
                        let time = changeStringDateFormat(date ?? "",fromFormat:"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",toFormat:"MM/dd")
                        dateArray.append(time ?? "")
                        let unitVal = values.weighUnit ?? ""
                        unitArray.append(unitVal)
                    }
                    UserDefaults.standard.setValue(pointData, forKey: "GraphPoints")
                    UserDefaults.standard.setValue(dateArray, forKey: "GraphDates")
                    UserDefaults.standard.setValue(unitArray, forKey: "GraphUnitsClient")
                    self?.getFitnessAseesment()
                }else{
                    UserDefaults.standard.setValue(nil, forKey: "GraphPoints")
                    UserDefaults.standard.setValue(nil, forKey: "GraphDates")
                    UserDefaults.standard.setValue(nil, forKey: "GraphUnitsClient")
                    self?.getFitnessAseesment()
                }
                
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
    func getFitnessAseesment(){
        guard let clientId = UserDefaults.standard.value(forKey: "CurrentClientId") as? String else {return}
        let dictForBackEnd = API.ApiCreateDictionary.deleteClient(clientId: clientId).formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiWeeklyFitnessAssessment, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                
                let fitnessAssessmentData = data as? FitnessAssesment
                UserDataSingleton.sharedInstance.fitnessAssesment = fitnessAssessmentData
                self?.getWeeklyMeasurement()
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
    func getWeeklyMeasurement(){
        guard let clientId = UserDefaults.standard.value(forKey: "CurrentClientId") as? String else {return}
        let dictForBackEnd = API.ApiCreateDictionary.deleteClient(clientId: clientId).formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiWeeklyMeasurement, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                let fitnessAssessmentData1 = data as? FitnessAssesment1
                UserDataSingleton.sharedInstance.fitnessAssesment1 = fitnessAssessmentData1
                self?.getDataOfClientDetails()
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
    func deleteClient(){
        guard let clientId = clientId else {return}
        let dictForBackEnd = API.ApiCreateDictionary.deleteClient(clientId: clientId).formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiDeleteClient, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                print(data)
                clientDeleted = true
                self?.popVC()
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
}
