//
//  ClientWeignInViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/18/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class ClientWeignInViewController: UIViewController , LineChartDelegate , DelegateAddWeighIn{
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewLineChart: LineChart!{
        didSet{
            viewLineChart.backgroundColor = Colorss.lineChartBackgroundColor.toHex()
        }
    }
    
    @IBOutlet weak var labelNoData: UILabel!
    
    //MARK::- VARIABLES
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]?
    var weighInPopUp: WeighInPopUpView?
    var popUpPresent = false
    var boolConfigure = false
    var unitDefined = ""
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        fromWeighIn = true
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpLineChart()
        fromWeighIn = true
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if popUpPresent{
            popUpPresent.toggle()
            removeAnimate(weighInPopUp ?? UIView())
        }else{
            
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    //MARK::- FUNCTIONS
    
    func setUpLineChart(){
        
        viewLineChart.clearAll()
        weighInPopUp = WeighInPopUpView(frame: self.view.frame)
        
        var data: [CGFloat] = []
        var xLabels: [String] = []
        
        var points = UserDefaults.standard.value(forKey: "GraphPointsClient") as? [CGFloat]
        var xString = UserDefaults.standard.value(forKey: "GraphDatesClient") as? [String]
        
        
        if points == nil || points?.count == 0{
            points = [5]
            xString = ["1"]
            data = points!
            xLabels = xString!
            labelNoData.isHidden = false
            viewLineChart.isHidden = true
            boolConfigure = false
        }else{
            print(points)
            print(xString)
            labelNoData.isHidden = true
            viewLineChart.isHidden = false
            guard let points = points , let xString = xString else {return}
            data = points
            xLabels = xString
            boolConfigure = true
        }
        
        // simple line with custom x axis labels
        
        viewLineChart.animation.enabled = true
        viewLineChart.area = true
        viewLineChart.x1.labels.visible = true
        viewLineChart.x1.labels.values = xLabels
        viewLineChart.y1.labels.visible = false
        print(data)
        viewLineChart.addLine(data)
        self.item = xLabels as [AnyObject]?
        viewLineChart.delegate = self
        if boolConfigure{
            configureTableView()
        }
    }
    
    func configureTableView(){
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.ClientsWeighInTableViewCell.rawValue , item: item, configureCellBlock: { [unowned self] (cell, item, indexPath) in
            guard let cell = cell as? ClientsWeighInTableViewCell else {return}
            guard var points = UserDefaults.standard.value(forKey: "GraphPointsClient") as? [CGFloat] else {return}
            guard var xString = UserDefaults.standard.value(forKey: "GraphDatesClient") as? [String] else {return}
            guard var units = UserDefaults.standard.value(forKey: "GraphUnitsClient") as? [String] else {return}
            self.unitDefined = units[0]
            cell.setValue(xString[indexPath.row], weight: points[indexPath.row] , unit: units[indexPath.row])
            }, configureDidSelect: {  (indexPath) in
                
        })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        dataSourceTableView?.headerHight = 0.0
        dataSourceTableView?.footerHeight = 0.0
        dataSourceTableView?.cellHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }
    
    
    
    //MARK::- DELEGATES
    
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
        print( "x: \(x)     y: \(yValues)")
    }
    
    func selectedData(_ date: String){
        
    }
    
    func delegateAddWeighIn(_ weigh:String , unit:String){
        sendWeigh(weigh , unit: unit)
    }
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        popVC()
    }
    
    @IBAction func btnActionWeighIn(_ sender: UIButton) {
        if boolConfigure{
            popUpPresent = true
            weighInPopUp?.constraintHeightViewCustomisation.constant = 0
            weighInPopUp?.viewCustomisation.isHidden = true
            weighInPopUp?.delegate = self
            weighInPopUp?.labelUnit.text = unitDefined ?? "lbs"
            
            showAnimate(weighInPopUp ?? UIView())
            self.view.addSubview(weighInPopUp ?? UIView())
        }else{
            popUpPresent = true
            weighInPopUp?.delegate = self
            weighInPopUp?.constraintHeightViewCustomisation.constant = 75
            weighInPopUp?.viewCustomisation.isHidden = false
            weighInPopUp?.labelUnit.text = "lbs"
            showAnimate(weighInPopUp ?? UIView())
            self.view.addSubview(weighInPopUp ?? UIView())
        }
        
    }
}

extension ClientWeignInViewController{
    
    func sendWeigh(_ weigh: String , unit:String){
        let dictForBackEnd = API.ApiCreateDictionary.clientAddWeighIn(weight: weigh , unit: unit).formatParameters()
        print(dictForBackEnd)
        
        ApiDetector.getDataOfURL(ApiCollection.apiClientAddWeighIn, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                self?.getWeighIn()
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
    func getWeighIn(){
        let dictForBackEnd = API.ApiCreateDictionary.clientListing().formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiWeeklyWeighInsOfClient, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                
                guard let weighInData = data as? [WeighIn] else {return}
                var dateArray = [String]()
                var pointData = [CGFloat]()
                var unitArray = [String]()
                for values in weighInData{
                    let pt = values.weigh?.toInt()?.toCGFloat
                    let date = values.weighPicDate
                    pointData.append(pt ?? 0.0)
                    let time = changeStringDateFormat(date ?? "",fromFormat:"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",toFormat:"MM/dd")
                    dateArray.append(time ?? "")
                    let unitVal = values.weighUnit ?? ""
                    unitArray.append(unitVal)
                }
                UserDefaults.standard.setValue(pointData, forKey: "GraphPointsClient")
                UserDefaults.standard.setValue(dateArray, forKey: "GraphDatesClient")
                UserDefaults.standard.setValue(unitArray, forKey: "GraphUnitsClient")
                self?.setUpLineChart()
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
}





