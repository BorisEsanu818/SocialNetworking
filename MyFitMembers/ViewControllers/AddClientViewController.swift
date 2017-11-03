//
//  AddClientViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 9/24/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class AddClientViewController: UIViewController, DelegateAddClientMeasurementsField {

//MARK::- OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSendInvite: UIButton!
    @IBOutlet weak var textViewAddress: PlaceholderTextView!
    
//MARK::- VARIABLES
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]? = []
    var popUpAddClientMeasurementField: AddClientMeasurementsField?
    
//MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        item = ["Chest" as AnyObject,"Biceps" as AnyObject,"Waist" as AnyObject,"Thigh" as AnyObject]
        instantiateControllers()
        showShadow(btnSendInvite)
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
    }
    
    func configureTableView(){
        
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.AddClientTableViewCell.rawValue , item: item, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? AddClientTableViewCell else {return}
            cell.setValue(item?[indexPath.row] as? String ?? "", measurementType: "Inch")
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
    
    
//MARK::- ACTIONS
    
    @IBAction func btnActionAddCustomField(_ sender: UIButton) {
         popUpAddClientMeasurementField?.textFieldAddField.text = ""
        self.view.addSubview(popUpAddClientMeasurementField ?? UIView())
        showAnimate(popUpAddClientMeasurementField ?? UIView())
    }
    
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }

}
