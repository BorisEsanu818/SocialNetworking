//
//  WeighInViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/10/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class WeighInViewController: UIViewController , IndicatorInfoProvider, LineChartDelegate {
    
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
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        fromWeighIn = true
        setUpLineChart()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    //MARK::- FUNCTIONS
    
    func setUpLineChart(){
        
        var configure = false
        weighInPopUp = WeighInPopUpView(frame: self.view.frame)
        
        var data: [CGFloat] = []
        var xLabels: [String] = []
        
        var points = UserDefaults.standard.value(forKey: "GraphPoints") as? [CGFloat]
        var xString = UserDefaults.standard.value(forKey: "GraphDates") as? [String]
        if points == nil || points?.count == 0{
            data = [5 , 5]
            xLabels = ["1" , "1"]
            labelNoData.isHidden = false
            viewLineChart.isHidden = true
            configure = false
        }else{
            configure = true
            print(points)
            print(xString)
            labelNoData.isHidden = true
            
            guard let points = points , let xString = xString else {return}
            data = points
            xLabels = xString
        }
        
        // simple line with custom x axis labels
        
        viewLineChart.animation.enabled = true
        viewLineChart.area = true
        viewLineChart.x1.labels.visible = true
        viewLineChart.x1.labels.values = xLabels
        viewLineChart.y1.labels.visible = false
        viewLineChart.addLine(data)
        self.item = xLabels as [AnyObject]?
        viewLineChart.delegate = self
        if configure{
            configureTableView()
        }else{
            
        }
        
        
    }
    
    func configureTableView(){
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.WeighInTableViewCell.rawValue , item: item, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? WeighInTableViewCell else {return}
            guard var points = UserDefaults.standard.value(forKey: "GraphPoints") as? [CGFloat] else {return}
            guard var xString = UserDefaults.standard.value(forKey: "GraphDates") as? [String] else {return}
            guard var units = UserDefaults.standard.value(forKey: "GraphUnitsClient") as? [String] else {return}
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
    
    func indicatorInfoForPagerTabStrip(_ pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:"Weigh-In")
    }
    
    func selectedData(_ date: String){
        var configure = false
        let points = UserDefaults.standard.value(forKey: "GraphPoints") as? [CGFloat]
        var xString = UserDefaults.standard.value(forKey: "GraphDates") as? [String]
        if points == nil || points?.count == 0{
            
            configure = false
        }else{
            configure = true
        }
        if configure{
            configureTableView()
        }else{
            
        }
        
    }
    
    
    
    
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        popVC()
    }
    
    
}

