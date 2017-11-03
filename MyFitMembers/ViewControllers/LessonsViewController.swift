//
//  LessonsViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/7/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

class LessonsViewController: UIViewController {
    
    //MARK::- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelLessonName: UILabel!
    @IBOutlet weak var viewVideo: UIView!
    
    @IBOutlet weak var viewCover: UIView!
    @IBOutlet weak var btnBack: UIButton!{
        didSet{
            btnBack.layer.cornerRadius = btnBack.frame.height/2
        }
    }
    //MARK::- VARIABLES
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]? = []
    var lessonId: String?
    var ofClient = false
    var player: AVPlayer?
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateControllers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setUpSideBar(false,allowRighSwipe: false)
        getQuizData()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    //MARK::- FUCTIONS
    
    func videoSetUp(_ urlString:String){
        //        http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
        guard let videoURL = URL(string: urlString) else {return}
        // create an AVPlayer
        player = AVPlayer(url: videoURL)
        print(videoURL)
        // create a player view controller
        let controller = AVPlayerViewController()
        controller.player = player
//        player?.play()
        // show the view controller
        self.addChildViewController(controller)
        self.viewVideo.addSubview(controller.view)
        controller.view.frame = self.viewVideo.frame
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
        UserDefaults.standard.setValue(nil, forKey: "runAble")
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.LessonsTableViewCell.rawValue , item: item, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? LessonsTableViewCell else {return}
            guard let lessonQuset = self.item as? [QuizQuestions] else {return}
            cell.setValue(lessonQuset , row: indexPath.row)
            }, configureDidSelect: { (indexPath) in
                
        })
        dataSourceTableView?.item = item ?? []
        dataSourceTableView?.cellHeight = UITableViewAutomaticDimension
        
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        tableView.reloadData()
        
    }
    
    func setData(_ lesson:LessonDescription){
        labelLessonName.text = lesson.lessonName
        self.item = lesson.lessonQuest
        let arrayMarks = Array(repeating: 0, count: item?.count ?? 0)
        print(arrayMarks)
        UserDefaults.standard.setValue(arrayMarks, forKey: "Marks")
        configureTableView()
    }
    
    //MARK::- ACTIONS
    
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        player?.pause()
        popVC()
    }
    
    @IBAction func btnActionSubmit(_ sender: UIButton) {
        var url = ""
        if ofClient{
            url = ApiCollection.apiClientSubmitMarks
        }else{
            url = ApiCollection.apiSubmitMarks
        }
        
        var totalMarks = 0
        guard let marksArray = UserDefaults.standard.value(forKey: "Marks") as? Array<Int> else {return}
        for mrk in marksArray{
            totalMarks += mrk
        }
        
        print(totalMarks)
        
        let totalQuestions = self.item?.count
        if totalMarks == totalQuestions{
            guard let lessnId = lessonId else {return}
            let dictForBackEnd = API.ApiCreateDictionary.submitMarks(lessonId: lessnId, marks: totalMarks.toString).formatParameters()
            print(dictForBackEnd)
            ApiDetector.getDataOfURL(url , dictForBackend: dictForBackEnd, failure: { (data) in
                print(data)
                }, success: { [unowned self] (data) in
                    print(data)
                    self.showAlert("Congrats, you passed!", message: "You can now continue on to the next lesson." , fail: false)
                }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
        }else{
            showAlert("Sorry, please try again.", message: "Please re-watch the video to find the correct answers." , fail: true)
        }
        
        
    }
    
    //MARK::- ALERTS
    func showAlert(_ titleMessage:String , message:String , fail:Bool){
        let controller = UIAlertController(title: titleMessage, message: message , preferredStyle: UIAlertControllerStyle.alert)
        let yes = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { [unowned self] (action) -> Void in
            
            if fail{
                self.configureTableView()
                
            }else{
                self.popVC()
            }
        }
        controller.addAction(yes)
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
}


extension LessonsViewController{
    
    //MARK::- API CALL FOR QUIZ
    
    func getQuizData(){
        var url = ""
        if ofClient{
            url = ApiCollection.apiClientLessonDescription
        }else{
            url = ApiCollection.apiLessonDescription
        }
        
        guard let lessonId = lessonId else {return}
        let dictForBackEnd = API.ApiCreateDictionary.getQuiz(lessonId: lessonId).formatParameters()
        print(dictForBackEnd)
        ApiDetector.getDataOfURL(url , dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            
            }, success: { [weak self] (data) in
                guard let lessonData = data as? LessonDescription else {return}
                print(lessonData.lessonName)
                print(lessonData.video?.videoLink)
                guard let vidUrl = lessonData.video?.videoLink else {return}
                let videoUrl = ApiCollection.apiImageBaseUrl  + vidUrl
                self?.videoSetUp(videoUrl)
                self?.setData(lessonData)
                self?.viewCover.isHidden = true
            }, method: .post, viewControl: self, pic: UIImage() , placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
}
