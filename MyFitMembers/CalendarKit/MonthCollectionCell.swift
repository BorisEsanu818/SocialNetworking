//
//  MonthCollectionCell.swift
//  Calendar
//
//  Created by Boris Esanu on 02/06/15.
//  Copyright (c) 2015 Lancy. All rights reserved.
//

import UIKit

typealias CalendarCellForRow = (_ cell : AnyObject?,_ date : Date?,_ indexPath : IndexPath) -> ()

protocol MonthCollectionCellDelegate: class {
    func didSelect(_ date: Date , cell:DayCollectionCell , collectionView: UICollectionView)
}

class MonthCollectionCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    weak var monthCellDelgate: MonthCollectionCellDelegate?
    
    var dates = [Date]()
    var previousMonthVisibleDatesCount = 0
    var currentMonthVisibleDatesCount = 0
    var nextMonthVisibleDatesCount = 0
    var calendarCellForRow : CalendarCellForRow?
    var logic: CalendarLogic? {
        didSet {
            populateDates()
            if collectionView != nil {
                collectionView.reloadData()
            }
        }
    }
    
    var selectedDate: Date? {
        didSet {
            if collectionView != nil {
                collectionView.reloadData()
            }
        }
    }
    
    func populateDates() {
        if logic != nil {
            dates = [Date]()
            
            dates += logic!.previousMonthVisibleDays!
            dates += logic!.currentMonthDays!
            dates += logic!.nextMonthVisibleDays!
            
            previousMonthVisibleDatesCount = logic!.previousMonthVisibleDays!.count
            currentMonthVisibleDatesCount = logic!.currentMonthDays!.count
            nextMonthVisibleDatesCount = logic!.nextMonthVisibleDays!.count
            
        } else {
            dates.removeAll(keepingCapacity: false)
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nib = UINib(nibName: "DayCollectionCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "DayCollectionCell")
        
        let headerNib = UINib(nibName: "WeekHeaderView", bundle: nil)
        self.collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "WeekHeaderView")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 7*6 = 42 :- 7 columns (7 days in a week) and 6 rows (max 6 weeks in a month)
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCollectionCell", for: indexPath) as! DayCollectionCell
        let date = dates[indexPath.item]
        print(date)
        var bk = false
        var lnch = false
        var dnr = false
        var bks = false
        var dnrs = false
        
        
        cell.date = (indexPath.item < dates.count) ? date : nil
        cell.mark = (selectedDate == date)
        if !isSelfie{
            let arrayFoodPic = calendarFoodPicItem as? [FoodPics]
            for foodPic in arrayFoodPic ?? []{
                let strDate = foodPic.foodPicDate ?? ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                let foodDate = dateFormatter.date( from: strDate ) ?? Foundation.Date()
                
                if date.day == foodDate.day && date.year == foodDate.year && date.month == foodDate.month{
                    cell.constraintBottomLabel.constant = 12
                    let foodType = foodPic.foodType ?? ""
                    if foodType == "Breakfast" {
                        bk = true
                        cell.labelBreakFast.isHidden = false
                    }else if foodType == "Afternoon Snack" {
                        bks = true
                        cell.labelNoonSnacks.isHidden = false
                    }else if foodType == "Lunch" {
                        lnch = true
                        cell.labelLunch.isHidden = false
                    }else if foodType == "Evening Snack" {
                        dnrs = true
                        cell.labelEveningSnacks.isHidden = false
                    }else if foodType == "Dinner" {
                        dnr = true
                        cell.labelDinner.isHidden = false
                    }else {
                        
                        cell.labelBreakFast.isHidden = true
                        cell.labelNoonSnacks.isHidden = true
                        cell.labelLunch.isHidden = true
                        cell.labelEveningSnacks.isHidden = true
                        cell.labelDinner.isHidden = true
                        cell.imageSelfie.isHidden = true
                    }
                    
                }else{
                    
                    print(date.day)
                    print(foodDate.day)
                    print(date.year)
                    print(foodDate.year)
                    print(date.month)
                    print(foodDate.month)
                    
                    if bk{
                        
                        cell.labelBreakFast.isHidden = false
                    }else{
                        cell.labelBreakFast.isHidden = true
                    }
                    if bks{
                        cell.labelNoonSnacks.isHidden = false
                    }else{
                        cell.labelNoonSnacks.isHidden = true
                    }
                    if lnch{
                        cell.labelLunch.isHidden = false
                    }else{
                        cell.labelLunch.isHidden = true
                    }
                    if dnrs{
                        cell.labelEveningSnacks.isHidden = false
                    }else{
                        cell.labelEveningSnacks.isHidden = true
                    }
                    if dnr{
                        cell.labelDinner.isHidden = false
                    }else{
                        cell.labelDinner.isHidden = true
                    }
                    
                    if bk || lnch || dnr || bks || dnrs{
                        cell.constraintBottomLabel.constant = 12
                    }else{
                        cell.constraintBottomLabel.constant = 0
                    }
                    
                    cell.imageSelfie.isHidden = true
                }
            }
            cell.imageSelfie.isHidden = true
        }else{
            var selfiePresent = false
            let selfieCollection = selfiesPicItem as? [Selfie]
            for selfie in selfieCollection ?? []{
                let strDate = selfie.selfiePicDate ?? ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                let selfieDate = dateFormatter.date( from: strDate ) ?? Foundation.Date()
                
                if date.day == selfieDate.day && date.year == selfieDate.year && date.month == selfieDate.month{
                    cell.imageSelfie.isHidden = false
                    cell.constraintBottomLabel.constant = 0
                    guard let imagePath = selfie.userImage?.userOriginalImage else {return UICollectionViewCell() }
                    guard let imageUrl = URL(string: ApiCollection.apiImageBaseUrl + imagePath) else {return UICollectionViewCell() }
                    selfiePresent = true
                    cell.imageSelfie.yy_setImage(with: imageUrl, placeholder: UIImage(named: "ic_placeholder"))
                    
                }else{
                    if selfiePresent{
                        cell.constraintBottomLabel.constant = 0
                        cell.viewFoodInfo.isHidden = false
                        cell.imageSelfie.isHidden = false
                    }else{
                        cell.constraintBottomLabel.constant = 0
                        cell.viewFoodInfo.isHidden = true
                        cell.imageSelfie.isHidden = true
                    }
                    
                }
                
            }
        }
        
        cell.disabled = (indexPath.item < previousMonthVisibleDatesCount) ||
            (indexPath.item >= previousMonthVisibleDatesCount
                + currentMonthVisibleDatesCount)
        
        if let block = calendarCellForRow {
            block(cell,date,indexPath)
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if monthCellDelgate != nil {
            guard let cell = collectionView.cellForItem(at: indexPath) as? DayCollectionCell else {return}
            cell.mark = true
            
            monthCellDelgate!.didSelect(dates[indexPath.item] , cell: cell , collectionView: collectionView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "WeekHeaderView", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/7.0, height: collectionView.frame.height/7.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/7.0)
    }
    
    
    
}
