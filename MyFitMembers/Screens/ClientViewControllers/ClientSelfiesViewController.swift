//
//  SelfieViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/12/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Fusuma
import AVFoundation

class ClientSelfiesViewController: UIViewController, CalendarViewDelegate , IndicatorInfoProvider , DelegateSelectedPicView{
    
    //MARK::- OUTLETS
    @IBOutlet var placeholderView: UIView!
    @IBOutlet weak var imagesSelfie: UIImageView!
    
    
    //MARK::- VARIABLES
    let calendarView = CalendarView.instance(Foundation.Date(), selectedDate: Foundation.Date())
    var boolPlusPressed = false
    var selectedPicView: SelectedPicView?
    var selfie: UIImage?
    var item : [AnyObject]? = []
    
    
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedPicView = SelectedPicView(frame: self.view.frame)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isSelfie = true
        setUpSideBar(false,allowRighSwipe: false)
        guard let mnth = calendarView.baseDate?.month else {return}
        getMonthSelfies(mnth)
//        onTapImage()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if boolPlusPressed{
            removeAnimate(selectedPicView ?? UIView())
        }else{
            
        }
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK::- DELEGATE
    func setUpCalendar(){
        calendarView.delegate = self
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.addSubview(calendarView)
        calendarView.selectedDate = Foundation.Date()
        callSelfieDidSelectBlock(calendarView)
        placeholderView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
        placeholderView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
    }
    
    
    func btnPressed(){
        
    }
    
    
    func didSelectDate(_ date: Date , cell:DayCollectionCell , collectionView: UICollectionView) {
        print("\(date.year)-\(date.month)-\(date.day)")
        imagesSelfie.image = cell.imageSelfie.image
        
    }
    
    func indicatorInfoForPagerTabStrip(_ pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Selfies")
    }
    
    func callSelfieDidSelectBlock(_ calendarView : CalendarView?){
        
    }
    
    //MARK::- GESTURES
    
    func onTapImage(){
        imagesSelfie.addTapGesture { [unowned self] (tap) in
            let vc = StoryboardScene.Main.instantiateEnlargedPicViewController()
            vc.selfieImage = self.imagesSelfie.image
            vc.fromSelfie = true
            self.pushVC(vc)
        }
    }
    
    //MARK::- FUNCTIONS
    
    func getImage(_ type:String){
        
        CameraGalleryPickerBlock.sharedInstance.pickerImage(type: type, presentInVc: self, pickedListner: {
            [weak self]
            (image,imageUrl) -> () in
            self?.selfie = image
            self?.sendSelfie()
            
            }, canceledListner: {} , allowEditting: false)
    }
    
    func callFusumaImagePicker(){
        allowRev = true
        let controller = UIAlertController(title: title, message: "Choose action" , preferredStyle: UIAlertControllerStyle.actionSheet)
        let buttons = ["Camera" , "Photo Library"]
        for btn in buttons{
            let action = UIAlertAction(title: btn, style: UIAlertActionStyle.default, handler: { [unowned self] (action) -> Void in
                self.getImage(btn ?? "")
                })
            controller.addAction(action)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "")
        , style: UIAlertActionStyle.cancel) { (action) -> Void in
            
        }
        controller.addAction(cancel)
        present(controller, animated: true, completion: nil)
        //        CameraGalleryPickerBlock.sharedInstance.pickerImage(type: "Camera", presentInVc: self, pickedListner: {
        //            [weak self]
        //            (image,imageUrl) -> () in
        //            self?.selfie = image
        //            self?.sendSelfie()
        //
        //            }, canceledListner: {})
        
        
        //        let fusuma = FusumaViewController()
        //        fusuma.hasVideo = false
        //        fusuma.delegate = self
        //        fusuma.modeOrder = .CameraFirst
        //        fusumaCropImage = true
        //        self.presentViewController(fusuma, animated: true, completion: nil)
    }
    
    
    func instantiateControllers(){
        
        selectedPicView = SelectedPicView(frame: self.view.frame)
        selectedPicView?.delegate = self
    }
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        popVC()
    }
    
    
    @IBAction func btnActionPlus(_ sender: UIButton) {
        boolPlusPressed = true
        callFusumaImagePicker()
    }
    
    
}

extension ClientSelfiesViewController : FusumaDelegate{
    //MARK::- Fusuma delegates
    
    func fusumaImageSelected(_ image: UIImage) {
        selfie = image
        sendSelfie()
        print("Image selected")
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
    
    //MARK::- DELEGATE PIC
    
    func delegateSelectedPicViewAccept(_ image: UIImage){
        
    }
    
    func delegateSelectedPicViewReject(){
        
    }
    
}


extension ClientSelfiesViewController{
    
    //MARK::- API
    
    func sendSelfie(){
        let dictForBackEnd = API.ApiCreateDictionary.clientAddSelfie().formatParameters()
        
        guard let selfieImg = selfie  else {return}
        ApiDetector.getDataOfURL(ApiCollection.apiClientAddSelfie, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [unowned self] (data) in
                print(data)
                guard let mnth = self.calendarView.baseDate?.month else {return}
                self.getMonthSelfies(mnth)
                
            }, method: .postWithImage, viewControl: self, pic: selfieImg, placeHolderImageName: "image", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
    
    //MARK::- API
    
    func getMonthSelfies(_ mnth:Int){
        
        let dictForBackEnd = API.ApiCreateDictionary.clientMonthlyFoodPics(month: mnth.toString).formatParameters()
        
        
        ApiDetector.getDataOfURL(ApiCollection.apiClientMonthlySelfie, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                guard let selfieData = data as? [Selfie] else {return}
                self?.item = selfieData
                selfiesPicItem = selfieData
                self?.setUpCalendar()
                
                let date = Foundation.Date()
                let selfiePic = selfieData.filter({ (selfi) -> Bool in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    let selfieDate = dateFormatter.date(from: selfi.selfiePicDate ?? "") ?? Foundation.Date()
                    return selfieDate.day == date.day && selfieDate.year == date.year && selfieDate.month == date.month
                })
                if selfiePic.count > 0{
                    guard let selfie1 = selfiePic[0].userImage?.userOriginalImage else {return}
                    guard let selfieUrl = URL(string: ApiCollection.apiImageBaseUrl + selfie1) else {return}
                    self?.imagesSelfie.yy_setImage(with: selfieUrl, options: .progressiveBlur)}else{}
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
        
    }
    
    
}
