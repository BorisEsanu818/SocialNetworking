//
//  LessonVideoViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 16/11/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

class LessonVideoViewController: UIViewController {

//MARK::- VARIABLES
    
    var videoUrl : String?
    
//MARK::- OUTLETS
    @IBOutlet weak var viewVideo: UIView!
    
    
//MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        videoSetUp()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    
//MARK::- FUNCTIONS
    func videoSetUp(){
        
        guard var videoURL = URL(string: videoUrl ?? "") else {return}
        // create an AVPlayer
        var player = AVPlayer(url: videoURL)
        // create a player view controller
        var controller = AVPlayerViewController()
        controller.player = player
//        player.play()
      
        // show the view controller
        self.addChildViewController(controller)
        self.view.addSubview(controller.view)
        controller.view.frame = CGRect(x: viewVideo.origin.x, y: viewVideo.origin.y, w: DeviceDimensions.width, h: DeviceDimensions.height - 80)
    }

//MARK::- ACTIONS
    @IBAction func btnActionBack(_ sender: UIButton) {
        popVC()
    }
}
