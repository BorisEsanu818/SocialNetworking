//
//  LessonCollectionViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/7/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import AVFoundation

class LessonCollectionViewController: UIViewController , DelegateGoToQuizScreen {
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var labelNoDataFound: UILabel!
    
    //MARK::- VARIABLES
    var dataSourceTableView: LessonCollectionTableViewDataSource?
    var item:[AnyObject]? = []
    var selectedIndexPath:Int? = 0987654
    var delegate:DelegateClientCollectionViewController?
    var lessonVc: LessonsViewController?
    var ofClient = false
    
    //MARK::- OVVERIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateViewController()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLessonData()
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    //MARK::- FUNCTIONS
    
    func instantiateViewController(){
        NotificationCenter.default.addObserver(self, selector: #selector(LessonCollectionViewController.showVideo), name: NSNotification.Name(rawValue: "ShowVideoPressed"), object: nil)
        lessonVc = StoryboardScene.Main.instantiateLessonsViewController()
    }
    
    func configureTableView(){
        dataSourceTableView = LessonCollectionTableViewDataSource(tableView: tableView, cell: CellIdentifiers.LessonCollectionCollapsedTableViewCell.rawValue , item: item, configureCellBlock: { [weak self] (cell, item, indexPath) in
            if self?.selectedIndexPath == 0987654{
                
            }else{
                if indexPath.row == self?.selectedIndexPath{
                    guard let cell = cell as? LessonCollectionCollapsedTableViewCell else {return}
                    
                }else{
                    guard let cell = cell as? LessonCollectionTableViewCell else {return}
                    
                }
            }
            }, configureDidSelect: { [weak self] (indexPath) in
                self?.selectedIndexPath = indexPath.row
                self?.tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic )
            })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        dataSourceTableView?.headerHight = 0.0
        dataSourceTableView?.footerHeight = 0.0
        dataSourceTableView?.cellHeight = UITableViewAutomaticDimension
        dataSourceTableView?.cellName1 = CellIdentifiers.LessonCollectionCollapsedTableViewCell.rawValue
        dataSourceTableView?.cellName2 = CellIdentifiers.LessonCollectionTableViewCell.rawValue
        dataSourceTableView?.cellName3 = CellIdentifiers.LessonCollectionRecentTableViewCell.rawValue
        dataSourceTableView?.vc = self
        dataSourceTableView?.delegate = self
        tableView.reloadData()
        
    }
    
    
    //MARK::- DELEGATES
    
    func showVideo(_ lessonId: String){
        guard let lessonVc = lessonVc else {return}
        lessonVc.lessonId = lessonId
        pushVC(lessonVc)
    }
    
    func delegateGoToQuizScreen(_ lessonId: String){
        let lessonVc = StoryboardScene.Main.instantiateLessonsViewController()
        lessonVc.lessonId = lessonId
        lessonVc.ofClient = ofClient
        pushVC(lessonVc)
    }
    
    func delegateShowVideo(_ index:Int){
        guard let item = item as? [Lesson] else {return}
        let lesson = item[index].video?.videoLink
        let vc = StoryboardScene.Main.instantiateLessonVideoViewController()
        guard let lessonUrl = lesson else {
            AlertView.callAlertView("", msg: "NO video url is provided", btnMsg: "OK", vc: self)
            return
        }
        print(ApiCollection.apiImageBaseUrl + lessonUrl)
        vc.videoUrl = ApiCollection.apiImageBaseUrl + lessonUrl
        pushVC(vc)
    }
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        popVC()
    }
}


extension LessonCollectionViewController{
    
    //MARK::- API
    
    func getLessonData(){
        
        if !ofClient{
            let dictForBackEnd = API.ApiCreateDictionary.lessonListing().formatParameters()
            print(dictForBackEnd)
            ApiDetector.getDataOfURL(ApiCollection.apiLessonListing, dictForBackend: dictForBackEnd, failure: { (data) in
                print(data)
                }, success: { [unowned self] (data) in
                    print(data)
                    guard let lessonDat = data as? [Lesson] else {return}
                    if lessonDat.count == 0{
                        self.labelNoDataFound.isHidden = false
                    }else{
                        self.labelNoDataFound.isHidden = true
                    }
                    self.item = lessonDat
                    self.configureTableView()
                }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
        }else{
            let dictForBackEnd = API.ApiCreateDictionary.clientListing().formatParameters()
            print(dictForBackEnd)
            ApiDetector.getDataOfURL(ApiCollection.apiLessonListingOfClient, dictForBackend: dictForBackEnd, failure: { (data) in
                print(data)
                }, success: { [unowned self] (data) in
                    print(data)
                    guard let lessonDat = data as? [Lesson] else {return}
                    if lessonDat.count == 0{
                        self.labelNoDataFound.isHidden = false
                    }else{
                        self.labelNoDataFound.isHidden = true
                    }
                    self.item = lessonDat
                    self.configureTableView()
                }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
        }
        
    }
    
}

extension LessonCollectionViewController{
    //MARK::- GET IMAGE FROM VIDEO
    
    
    
}


