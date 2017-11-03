
//
//  ClientViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 9/22/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class ClientViewController: UIViewController ,UIPageViewControllerDataSource ,UIPageViewControllerDelegate{

//MARK::- OUTLETS
    
    @IBOutlet weak var imageUser: UIImageView!{
        didSet{
            imageUser.layer.borderColor = UIColor.white.cgColor
            imageUser.layer.cornerRadius = imageUser.frame.height/2
        }
    }
    
    @IBOutlet weak var dataContentView: UIView!
    
    
    
//MARK::- VARIABLES
    var pageController : UIPageViewController?
    var pageScrollView:UIScrollView!
    var currentPageIndex:NSInteger = 0
    var clientCollection: ClientCollectionViewController?
    var messageCollectionVc: MessageViewController?
    var broadcastVc : BroadCastViewController?
    var viewControllerArray:NSArray? = []

    
    
//MARK::- OVERRIDE FUNCTIOSN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateViewControllers()
        guard let clientCollection = clientCollection else {return}
        setUp(clientCollection)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpSideBar(false,allowRighSwipe: false)
    }
    
//MARK::- FUNCTIONS
    func instantiateViewControllers(){
        clientCollection = StoryboardScene.Main.instantiateClientCollectionViewController()
        messageCollectionVc = StoryboardScene.Main.instantiateMessageViewController()
        broadcastVc = StoryboardScene.Main.instantiateBroadCastViewController()
    }
    
    func setUp(_ firstViewControl: UIViewController){
        guard let clientCollection = clientCollection , let messageCollectionVc = messageCollectionVc , let broadcastVc = broadcastVc else {return}
        viewControllerArray = [clientCollection,messageCollectionVc,broadcastVc]
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController?.setViewControllers([firstViewControl], direction: .forward, animated: true, completion: nil)
        pageController?.view.frame = CGRect(x: 0, y: 0, width: dataContentView.bounds.width, height: dataContentView.bounds.height)
        pageController?.delegate = self
        pageController?.dataSource = self
        guard let pageController = pageController else{return}
        self.addChildViewController(pageController)
        self.dataContentView.addSubview(pageController.view)
        self.pageController?.didMove(toParentViewController: self)
    }
    
    
//MARK::- PAGEVIEWCONTROLLER DELEGATE
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index : NSInteger = viewControllerArray?.index(of: viewController) ?? 0
        if index == NSNotFound{ return nil }
        index = index + 1
        if index == viewControllerArray?.count{ return nil }
        return viewControllerArray?.object(at: index) as? UIViewController
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index : NSInteger = viewControllerArray?.index(of: viewController) ?? 0
        if index == NSNotFound || index == 0{ return nil }
        index = index - 1
        return viewControllerArray?.object(at: index) as? UIViewController
    }
    
    
//MARK::- ACTIONS
    

   

}
