//
//  BroadCastViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 9/23/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class BroadCastViewController: UIViewController , BroadCastDone{
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var labelNoDataFound: UILabel!
    //MARK::- VARIABLES
    
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]? = []
    var popUpBroadCast: NewBroadCast?
    var delegate:DelegateClientCollectionViewController?
    var boolPopUpPresent = false
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateViewControllers()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getBroadCastMessagesListing()
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if boolPopUpPresent{
            boolPopUpPresent = false
            removeAnimate(self.popUpBroadCast ?? UIView())
        }
    }
    
    //MARK::- FUNCTIONS
    
    func instantiateViewControllers(){
        popUpBroadCast = NewBroadCast(x: 0, y: 0, w: DeviceDimensions.width, h: DeviceDimensions.height)
        popUpBroadCast?.delegate = self
    }
    
    
    func configureTableView(){
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.BroadCastTableViewCell.rawValue , item: item, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? BroadCastTableViewCell else {return}
            guard let broadCastMessagesArray = item as? [BroadCastMessagesListing] else {return}
            cell.setData(broadCastMessagesArray[indexPath.row])
            }, configureDidSelect: { (indexPath) in
                
        })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        dataSourceTableView?.cellHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }
    
    //MARK::- DELEGATES
    
    func delegatebroadCastDone(){
        getBroadCastMessagesListing()
    }
    
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        popVC()
    }
    
    @IBAction func btnActionCreateNewBroadCast(_ sender: UIButton) {
        popUpBroadCast?.vc = self
        boolPopUpPresent = true
        popUpBroadCast?.textView.text = ""
        self.view.addSubview(popUpBroadCast ?? UIView())
        showAnimate(popUpBroadCast ?? UIView())
    }
}

extension BroadCastViewController{
    
    //MARK::- API CALL
    
    func getBroadCastMessagesListing(){
        let dictForBackEnd = API.ApiCreateDictionary.lessonListing().formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiMessageBroadCastingList, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                guard let broadCastMessagesArray = data as? [BroadCastMessagesListing] else {return}
                print(data)
                if broadCastMessagesArray.count == 0 {
                    self?.labelNoDataFound.isHidden  = false
                    
                }else{
                    self?.labelNoDataFound.isHidden  = true
                }
                self?.item = broadCastMessagesArray
                self?.configureTableView()
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
    
}
