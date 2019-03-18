//
//  XLCalendarRoundTripCell.swift
//  CalendarTest
//
//  Created by xiaolei on 2019/3/18.
//  Copyright © 2019 xiaolei. All rights reserved.
//

import UIKit

class XLCalendarRoundTripCell: UICollectionViewCell {
    
    enum RoundTripType {
        case departTrip
        case returnTrip
    }
    
    weak var calendar:XLCalendarRoundTrip?
    
    private var theLable:UILabel!
    private var calendarDate:Date?
    
    private var selectionView:UIImageView!
    private var selectionBgView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
        
        let label = UILabel.init()
        label.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width-20, height: self.bounds.height-20)
        label.center = CGPoint.init(x: self.bounds.width/2.0, y: self.bounds.height/2.0)
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(label)
        theLable = label
        
        selectionView = UIImageView.init(image: nil)
        selectionView.backgroundColor = UIColor.clear
        selectionView.alpha = 1
        self.contentView.addSubview(selectionView)
        selectionView.snp.makeConstraints { (make) in
            make.height.width.equalTo(50)
            make.center.equalToSuperview()
        }
        
        selectionBgView = UIView()
        selectionBgView.backgroundColor = UIColor.clear
        selectionBgView.alpha = 1
        selectionBgView.layer.cornerRadius = 2
        self.contentView.addSubview(selectionBgView)
        selectionBgView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        self.contentView.bringSubviewToFront(selectionView)
        self.contentView.bringSubviewToFront(theLable)
    }
    
    func setDate(_ date:Date?) {
        guard let calendarExsit = calendar else {return}
        self.calendarDate = date
        defer {
            if date == nil {
                theLable.text = ""
                theLable.textColor = UIColor.clear
                self.setBgImage(nil)
                self.selectionBgView.backgroundColor = UIColor.clear
            }
        }
        if date != nil {
            var textColor:UIColor = UIColor.black
            var type:RoundTripType? = nil
            var bgColor = UIColor.clear
            var cornerRadius:CGFloat = 0
            var alpha:CGFloat = 1
            //范围判断
            theLable.text = "\(date!.day_digital())"
            let bool1 = date!.isBefore(calendarExsit.minDate)
            let bool2 = date!.isAfter(calendarExsit.maxDate)
            if bool1 || bool2 {
                textColor = UIColor.lightGray
            } else {
                textColor = UIColor.black
            }
            //选中判断
            if let departDateE = calendarExsit.selectedDepartDate {
                if date!.isSameDay(departDateE) {
                    textColor = UIColor.white
                    type = .departTrip
                }
            }
            if let returnDateE = calendarExsit.selectedReturnDate {
                if date!.isSameDay(returnDateE) {
                    textColor = UIColor.white
                    type = .returnTrip
                }
            }
            if let departDateE = calendarExsit.selectedDepartDate, let returnDateE = calendarExsit.selectedReturnDate {
                if  date!.isSameDay(departDateE) && departDateE.isSameDay(returnDateE) {
                    bgColor = kColorThemeColor
                    cornerRadius = 2
                    type = nil
                }
                if departDateE.isSameDay(returnDateE) == false {
                    let bool1 = date!.isAfter(departDateE)
                    let bool2 = date!.isBefore(returnDateE)
                    let bool3 = date!.isSameDay(departDateE)
                    let bool4 = date!.isSameDay(returnDateE)
                    if (bool1 && bool2) || bool3 || bool4 {
                        alpha = 0.1
                        bgColor = kColorThemeColor
                    }
                }
                
            }
            
            setBgImage(type)
            theLable.textColor = textColor
            self.selectionBgView.backgroundColor = bgColor
            self.selectionBgView.layer.cornerRadius = cornerRadius
            self.selectionBgView.alpha = alpha
        }
    }
    
    private func setBgImage(_ type:RoundTripType?) {
        if type == nil {
            self.selectionView.image = nil
        } else if type == .departTrip {
            self.selectionView.image = UIImage.init(named: "roundTripDepart")
        } else if type == .returnTrip {
            self.selectionView.image = UIImage.init(named: "roundTripReturn")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
