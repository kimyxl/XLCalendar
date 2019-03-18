//
//  TestCollectionViewCell.swift
//  CalendarTest
//
//  Created by xiaolei on 2019/2/27.
//  Copyright © 2019 xiaolei. All rights reserved.
//

import UIKit

class XLCalendarCell: UICollectionViewCell {
    
    weak var calendar:XLCalendar?
    
    private var theLable:UILabel!
    private var calendarDate:Date?
    
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
        
        selectionView = UIView()
        selectionView.backgroundColor = UIColor.clear
        selectionView.frame = self.bounds
        selectionView.alpha = 1
        selectionView.layer.cornerRadius = 2
        self.contentView.addSubview(selectionView)
        
        self.contentView.bringSubviewToFront(theLable)
    }
    
    func setDate(_ date:Date?) {
        guard let calendarExsit = calendar else {return}
        self.calendarDate = date
        defer {
            if date == nil {
                theLable.text = ""
                theLable.textColor = UIColor.clear
                selectionView.backgroundColor = UIColor.clear
            }
        }
        if date != nil {
            var textColor:UIColor = UIColor.black
            var selectedBgBolor = UIColor.clear
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
            if let calendarSelectedExsit = calendarExsit.selectedDate {
                if date!.isSameDay(calendarSelectedExsit) {
                    textColor = UIColor.white
                    selectedBgBolor = kColorThemeColor
                    self.selectionView.transform = self.selectionView.transform.scaledBy(x: 0.5, y: 0.5)
                    UIView.animate(withDuration: 0.06, animations: {
                        self.selectionView.transform = self.selectionView.transform.scaledBy(x: 2, y: 2)
                    })
                }
            }
            theLable.textColor = textColor
            selectionView.backgroundColor = selectedBgBolor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


