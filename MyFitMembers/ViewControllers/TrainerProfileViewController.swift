//
//  TrainerProfileViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/5/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import SABlurImageView

class TrainerProfileViewController: UIViewController , DatePressed{
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var imageBackGround: SABlurImageView!
//    @IBOutlet weak var imageTrainer: UIImageView!{
//        didSet{
//            imageTrainer.layer.cornerRadius = imageTrainer.frame.width/2
//        }
//    }
//    
//    @IBOutlet weak var btnEdit: UIButton!
//    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    
    //MARK::- VARIABLES
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]? = []
    var delegate:DelegateClientCollectionViewController?
    var country: [String]? = [
        "Alabama",
        "Alaska",
        "American Samoa",
        "Arizona",
        "Arkansas",
        "California",
        "Colorado",
        "Connecticut",
        "Delaware",
        "District Of Columbia",
        "Federated States Of Micronesia",
        "Florida",
        "Georgia",
        "Guam",
        "Hawaii",
        "Idaho",
        "Illinois",
        "Indiana",
        "Iowa",
        "Kansas",
        "Kentucky",
        "Louisiana",
        "Maine",
        "Marshall Islands",
        "Maryland",
        "Massachusetts",
        "Michigan",
        "Minnesota",
        "Mississippi",
        "Missouri",
        "Montana",
        "Nebraska",
        "Nevada",
        "New Hampshire",
        "New Jersey",
        "New Mexico",
        "New York",
        "North Carolina",
        "North Dakota",
        "Northern Mariana Islands",
        "Ohio",
        "Oklahoma",
        "Oregon",
        "Palau",
        "Pennsylvania",
        "Puerto Rico",
        "Rhode Island",
        "South Carolina",
        "South Dakota",
        "Tennessee",
        "Texas",
        "Utah",
        "Vermont",
        "Virgin Islands",
        "Virginia",
        "Washington",
        "West Virginia",
        "Wisconsin",
        "Wyoming"
    ]
    var date: String?
    
    //MARK::- OVVERIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        getTrainerProfile(true)
//        imageBackGround.addBlurEffect(30, times: 1)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTrainerProfile(false)
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK::- FUNCTIONS
    func configureTableView(){
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.TrainerProfileTableViewCell.rawValue , item: item, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? TrainerProfileTableViewCell else {return}
            cell.delegate = self
            guard let itemVal = item?[indexPath.row] else {return}
            cell.setValue(itemVal)
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
    
    
    func stateButtonPressed(){
        let alertcontroller =   UIAlertController.showActionSheetController(title: "State", buttons: country ?? [""], success: { [unowned self]
            (state) -> () in
            guard let cell = self.tableView?.cellForRow(at: IndexPath(row: 0, section: 0)) as? TrainerProfileTableViewCell else {return}
            
            cell.btnState.setTitle(state, for: UIControlState())
            
            })
        present(alertcontroller, animated: true, completion: nil)
    }
    
    
    //MARK::- ACTIONS
    

    
}

extension TrainerProfileViewController{
    
    func getTrainerProfile(_ showLoader: Bool){
        let  dictForBackEnd = API.ApiCreateDictionary.broadCastListing().formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiTrainerProfile, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [unowned self] (data) in
                guard let personalData = data as? TrainerProfile else {return}
                var items = [TrainerProfile]()
                items.removeAll()
                items.append(personalData)
                self.item = items
                self.configureTableView()
                
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: showLoader, loaderColor: Colorss.darkRed.toHex())
    }

    

    
    
    @IBAction func btnActionDatePicker(_ sender: UIDatePicker) {
        var datee = sender.date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone =  TimeZone.autoupdatingCurrent
        date = formatter.string(from: datee)
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TrainerProfileTableViewCell else {return}
        
        let registerationDate = changeStringDateFormat(date ?? "",fromFormat:"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",toFormat:"MM/dd/yyyy")
        cell.labelRegisterationDate.text = registerationDate
    }
}


extension TrainerProfileViewController{
    
        
}
