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

class ClientLessonViewController: UIViewController {
    
    //MARK::- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewVideo: UIView!
    
    //MARK::- VARIABLES
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]? = []
    
    
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        item = ["" as AnyObject,"" as AnyObject,"" as AnyObject,"" as AnyObject,"" as AnyObject,"" as AnyObject,"" as AnyObject]
        instantiateControllers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureTableView()
        videoSetUp()
        setUpSideBar(false,allowRighSwipe: false)
    }
    
    //MARK::- FUCTIONS
    
    func videoSetUp(){
        guard let videoURL = URL(string: "https://www.youtube.com/watch?v=yeyBEpsZfrs") else {return}
        // create an AVPlayer
        let player = AVPlayer(url: videoURL)
        // create a player view controller
        let controller = AVPlayerViewController()
        controller.player = player
        player.play()
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
        
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.LessonsTableViewCell.rawValue , item: item, configureCellBlock: { (cell, item, indexPath) in
            guard let cell = cell as? LessonsTableViewCell else {return}
            guard let infoType = item?[indexPath.row] as? String else {return}
            
            }, configureDidSelect: { (indexPath) in
                
        })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        dataSourceTableView?.item = item ?? []
        dataSourceTableView?.cellHeight = UITableViewAutomaticDimension
    }
    
    //MARK::- ACTIONS
    
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        popVC()
    }
    
}
