//
//  SelfieViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 10/12/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import XLPagerTabStrip

var selfiesPicItem:[AnyObject] = []


class SelfieViewController: UIViewController, CalendarViewDelegate , IndicatorInfoProvider {
    
    //MARK::- OUTLETS
    @IBOutlet var placeholderView: UIView!
    @IBOutlet weak var imagesSelfie: UIImageView!
    
    
    //MARK::- VARIABLES
    let calendarView = CalendarView.instance(Foundation.Date(), selectedDate: Foundation.Date())
    var item : [AnyObject]? = []
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isSelfie = true
        setUpSideBar(false,allowRighSwipe: false)
        guard let mnth = calendarView.baseDate?.month else {return}
        getMonthSelfies(mnth)
        
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
    
    func didSelectDate(_ date: Date , cell:DayCollectionCell , collectionView: UICollectionView) {
        print("\(date.year)-\(date.month)-\(date.day)")
        imagesSelfie.image = cell.imageSelfie.image
    }
    
    func indicatorInfoForPagerTabStrip(_ pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Selfies")
    }
    
    func callSelfieDidSelectBlock(_ calendarView : CalendarView?){
    }
    
    func btnPressed(){
        guard let mnth = calendarView.baseDate?.month else {return}
        getMonthSelfies(mnth)
    }

    
    
}

extension SelfieViewController{
    
    //MARK::- API
    
    func getMonthSelfies(_ mnth:Int){
        let clientId = UserDefaults.standard.value(forKey: "CurrentClientId") as? String
        guard let clientIdn = clientId else {return}
        
        let dictForBackEnd = API.ApiCreateDictionary.monthlyFoodPics(clientId: clientIdn, month: mnth.toString).formatParameters()
        ApiDetector.getDataOfURL(ApiCollection.apiMonthlySelfies, dictForBackend: dictForBackEnd, failure: { (data) in
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
