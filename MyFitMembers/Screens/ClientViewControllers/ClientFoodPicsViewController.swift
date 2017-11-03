//
//  FoodPicsViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/10/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Fusuma

var fromEnlargedScreen = false

class ClientFoodPicsViewController: UIViewController ,  CalendarViewDelegate, IndicatorInfoProvider , DelegateAddFoodPicViewFoodSelected , DelegateSelectedPicView{
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewCalendar: UIView!
    
    //MARK::- VARIABLES
    var dataSourceTableView: DataSourceTableView?
    var item:[AnyObject]?
    let calendarView = CalendarView.instance(Foundation.Date(), selectedDate: Foundation.Date())
    var addFoodPicView: AddFoodPicView?
    var boolPlusPressed = false
    var selectedPicView: SelectedPicView?
    var calendarFoodView: CalendarFoodView?
    var foodPicSelected = ""
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateControllers()
        calendarFoodView = CalendarFoodView(frame: self.view.frame)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if fromEnlargedScreen{
            fromEnlargedScreen = false
        }else{
            fromEnlargedScreen = false
            guard let mnth = calendarView.baseDate?.month else {return}
            getMonthImages(mnth , moved: false)
            isSelfie = false
            setUpSideBar(false,allowRighSwipe: false)
            callSelfieDidSelectBlock(calendarView)
        }
        allowRev = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if boolPlusPressed{
            removeAnimate(addFoodPicView ?? UIView())
        }else{
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    //MARK::- FUNCTIONS
    
    func calendarLoad(_ selectedDate: Foundation.Date , moved: Bool){
        calendarView.delegate = self
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        viewCalendar.addSubview(calendarView)
        if moved{
            
        }else{
            calendarView.selectedDate = selectedDate
        }
        callSelfieDidSelectBlock(calendarView)
        viewCalendar.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
        viewCalendar.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
    }
    
    func instantiateControllers(){
        addFoodPicView = AddFoodPicView(frame: self.view.frame)
        addFoodPicView?.delegate = self
        selectedPicView = SelectedPicView(frame: self.view.frame)
        selectedPicView?.delegate = self
    }
    
    func configureTableView(_ itemVal:[AnyObject]){
        dataSourceTableView = DataSourceTableView(tableView: tableView, cell: CellIdentifiers.ClientsFoodPicTableViewCell.rawValue , item: itemVal, configureCellBlock: { [weak self] (cell, item, indexPath) in
            guard let cell = cell as? ClientsFoodPicTableViewCell else {return}
            guard let foodPicArray = itemVal as? [FoodPics] else {return}
            cell.setData(foodPicArray[indexPath.row])
            }, configureDidSelect: { [unowned self] (indexPath) in
                let vc = StoryboardScene.Main.instantiateEnlargedPicViewController()
                guard let foodPicArray = itemVal as? [FoodPics] else {return}
                let foodData = foodPicArray[indexPath.row]
                guard let image  = foodData.userImage?.userOriginalImage else {return}
                let imgUrl = ApiCollection.apiImageBaseUrl + image
                print(imgUrl)
                vc.fromSelfie = false
                vc.imageProd = imgUrl
                self.pushVC(vc)
            })
        tableView.delegate = dataSourceTableView
        tableView.dataSource = dataSourceTableView
        dataSourceTableView?.headerHight = 0.0
        dataSourceTableView?.footerHeight = 0.0
        dataSourceTableView?.cellHeight = 60.0
        tableView.reloadData()
        
        
    }
    
    func indicatorInfoForPagerTabStrip(_ pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "FoodPics")
    }
    
    func callFusumaImagePicker(_ item:String){
       
        CameraGalleryPickerBlock.sharedInstance.pickerImage(type: item, presentInVc: self, pickedListner: {
            [weak self]
            (image,imageUrl) -> () in
            self?.addFoodPicView?.removeFromSuperview()
            self?.sendFoodPic(image)
            }, canceledListner: { [weak self] in
                self?.addFoodPicView?.removeFromSuperview()
            } , allowEditting:true)
        
    }
    
    //MARK::- DELEGATES
    
    func delegateAddFoodPicViewFoodSelected(_ foodPic:String){
        print(foodPic)
        foodPicSelected = foodPic
        let alertcontroller =   UIAlertController.showActionSheetController(title: "Choose your action", buttons: ["Camera" , "Photo Library"], success: { [weak self]
            (state) -> () in
            self?.callFusumaImagePicker(state)
            })
        present(alertcontroller, animated: true, completion: nil)
        
    }
    
    func didSelectDate(_ date: Date , cell:DayCollectionCell , collectionView: UICollectionView) {
        print("\(date.year)-\(date.month)-\(date.day)")
        guard let foodPicArray = calendarFoodPicItem as? [FoodPics] else {return}
        let filteredFoodPic = foodPicArray.filter({ (foodPic) -> Bool in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let selfieDate = dateFormatter.date( from: foodPic.foodPicDate ?? "") ?? Foundation.Date()
            return selfieDate.day == date.day && selfieDate.year == date.year && selfieDate.month == date.month
        })
        self.item = filteredFoodPic
        configureTableView(self.item ?? [])
    }
    
    func btnPressed(){
        guard let mnth = calendarView.baseDate?.month else {return}
        getMonthImages(mnth , moved: true)
    }
    
    func callSelfieDidSelectBlock(_ calendarView : CalendarView?){}
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        popVC()
    }
    
    @IBAction func btnActionAddSelfie(_ sender: UIButton) {
        boolPlusPressed = true
        self.view.addSubview(addFoodPicView ?? UIView())
        showAnimate(addFoodPicView ?? UIView())
    }
    
}

extension ClientFoodPicsViewController : FusumaDelegate{
    //MARK::- Fusuma delegates
    
    func fusumaImageSelected(_ image: UIImage) {
        addFoodPicView?.removeFromSuperview()
        sendFoodPic(image)
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(_ image: UIImage) {
        print("Called just after FusumaViewController is dismissed.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        print("Camera roll unauthorized")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
    }
    
    //MARK::- Selected Image Or Reject Image
    
    func delegateSelectedPicViewAccept(_ image: UIImage){
        removeAnimate(selectedPicView ?? UIView())
    }
    
    func delegateSelectedPicViewReject(){
        removeAnimate(selectedPicView ?? UIView())
    }
}




extension ClientFoodPicsViewController{
    
    //MARK::- API
    
    func sendFoodPic(_ image:UIImage){
        let dictForBackEnd = API.ApiCreateDictionary.addFoodPicByClient(picType: foodPicSelected).formatParameters()
        print(dictForBackEnd)
        ApiDetector.getDataOfURL(ApiCollection.apiClientAddFoodPic, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                print(data)
                guard let mnth = self?.calendarView.baseDate?.month else {return}
                self?.getMonthImages(mnth , moved: false)
            }, method: .postWithImage, viewControl: self, pic: image, placeHolderImageName: "image" , headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
    func getMonthImages(_ mnth:Int , moved: Bool){
        
        let dictForBackEnd = API.ApiCreateDictionary.clientMonthlyFoodPics(month: mnth.toString).formatParameters()
        print(dictForBackEnd)
        
        ApiDetector.getDataOfURL(ApiCollection.apiMonthlyClientFoodPics, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                print(data)
                guard let foodPicData = data as? [FoodPics] else {return}
                calendarFoodPicItem = foodPicData
                guard let foodPicArray = foodPicData as? [FoodPics] else {return}
                let date = Foundation.Date()
                let filteredFoodPic = foodPicArray.filter({ (foodPic) -> Bool in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    let selfieDate = dateFormatter.date( from: foodPic.foodPicDate ?? "") ?? Foundation.Date()
                    return selfieDate.day == date.day && selfieDate.year == date.year && selfieDate.month == date.month
                })
                self?.item = filteredFoodPic
                print(self?.item)
                
                self?.calendarLoad(Foundation.Date() , moved: moved)
                self?.configureTableView(filteredFoodPic)
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
        
    }
}
