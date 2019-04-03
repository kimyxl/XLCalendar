//
//  TestCollectionViewCell.swift
//  CalendarTest
//
//  Created by xiaolei on 2019/2/27.
//  Copyright © 2019 xiaolei. All rights reserved.
//

import UIKit

class XLCalendarCell: UICollectionViewCell {
    
    weak var calendar:XLCalendarView?
    var priceDic = [String:Any]()
    var lowestDayOfMonth = [String:[String]]()
    
    private var theLable:UILabel!
    private var calendarDate:Date?
    private var subLabel:UILabel!
    private var selectionView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
        
        let label = UILabel.init()
        label.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width-20, height: self.bounds.height-20)
        label.center = CGPoint.init(x: self.bounds.width/2.0, y: self.bounds.height/2.0-6.5)
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(label)
        theLable = label
        
        let subLabel = UILabel()
        subLabel.backgroundColor = UIColor.clear
        subLabel.textAlignment = .center
        subLabel.textColor = UIColor.black
        subLabel.font = UIFont.systemFont(ofSize: 11)
        subLabel.textColor = kColorGreyWord
        self.contentView.addSubview(subLabel)
        self.subLabel = subLabel
        subLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(theLable.snp.bottom).offset(-5)
        }
        
        selectionView = UIView()
        selectionView.backgroundColor = UIColor.clear
        selectionView.alpha = 1
        selectionView.layer.cornerRadius = 2
        self.contentView.addSubview(selectionView)
        selectionView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }
        
        self.contentView.bringSubviewToFront(self.theLable)
        self.contentView.bringSubviewToFront(self.subLabel)
    }
    
    func setDate(_ date:Date?) {
        guard let calendarExsit = calendar else {return}
        self.calendarDate = date
        defer {
            if date == nil {
                theLable.text = ""
                theLable.textColor = UIColor.clear
                selectionView.backgroundColor = UIColor.clear
                subLabel.text = ""
            }
        }
        if date != nil {
            var textColor:UIColor = UIColor.black
            var selectedBgBolor = UIColor.clear
            var subTitleColor = kColorGreyWord
            //范围判断
            theLable.text = "\(date!.day_digital())"
            let bool1 = date!.isBeforeDay(calendarExsit.minDate)
            let bool2 = date!.isAfterDay(calendarExsit.maxDate)
            if bool1 || bool2 {
                textColor = UIColor.lightGray
            } else {
                textColor = UIColor.black
            }
            //最低价判断
            if self.lowestDayOfMonth.count>0 {
                let dateStr = "\(date!.year())-\(date!.month())"
                let dayStr = "\(date!.day())"
                if let dayStrL = self.lowestDayOfMonth[dateStr] {
                    if dayStrL.contains(dayStr)  {
                        subTitleColor = kColorThemeGreen
                    }
                }
            }
            
            //选中判断
            if let calendarSelectedExsit = calendarExsit.selectedDate {
                if date!.isSameDay(calendarSelectedExsit) {
                    textColor = UIColor.white
                    selectedBgBolor = kColorThemeColor
                    subTitleColor = kColorWhite
                    self.selectionView.transform = self.selectionView.transform.scaledBy(x: 0.5, y: 0.5)
                    UIView.animate(withDuration: 0.06, animations: {
                        self.selectionView.transform = self.selectionView.transform.scaledBy(x: 2, y: 2)
                    })
                }
            }
            
            theLable.textColor = textColor
            selectionView.backgroundColor = selectedBgBolor
            subLabel.textColor = subTitleColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


