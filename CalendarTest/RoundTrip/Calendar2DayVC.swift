//
//  CalendarRoundTripVC.swift
//  CalendarTest
//
//  Created by xiaolei on 2019/3/18.
//  Copyright © 2019 xiaolei. All rights reserved.
//

import UIKit

protocol Calendar2DayProtocol:class {
    func setSeletedDate(_ dateDepart:Date, _ dateReturn:Date)
}

class Calendar2DayVC: UIViewController {
    
    enum CalendarType {
        case flight
        case hotel
    }
    
    weak var delegate:Calendar2DayProtocol?
    private var calendar:XLCalendar2DayView!
    private var type = CalendarType.flight
    
    private var _startDate:Date?
    private var _endDate:Date?
    
    private var leftLabel:UILabel!
    private var rightLabel:UILabel!
    private var midLabel:UILabel!
    
    convenience init(strat:Date?, end:Date?, type:CalendarType?) {
        self.init()
        if let typeA = type {
            self.type = typeA
        }
        self._startDate = strat
        self._endDate = end
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        let calendarView = XLCalendar2DayView.init(start: _startDate, end: _endDate)
        self.calendar = calendarView
        self.view.addSubview(calendarView)
        
        let bgView = bottomView()
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(110)
        }
        
        calendarView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(bgView.snp.top)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNoti(_:)), name: NSNotification.Name(rawValue: "XLCalendar2DayViewDidSelecteAnItem"), object: nil)
    }
    
    @objc private func confirmAction() {
        if let _1day = calendar.startDate, let _2day = calendar.endDate {
            delegate?.setSeletedDate(_1day, _2day)
        }
    }
    
    @objc private func receiveNoti(_ noti:Notification) {
        self.dealDatesDisplay()
    }
    
    private func dealDatesDisplay() {
        if let dDate =  calendar.startDate {
            leftLabel.text = dDate.dateString(.combineHome)
        } else {
            leftLabel.text = " "
        }
        if let rDate = calendar.endDate {
            rightLabel.text = rDate.dateString(.combineHome)
        } else {
            rightLabel.text = " "
        }
        if calendar.startDate == nil || calendar.endDate == nil {
            if self.type == .flight {
                midLabel.text = "- DAYS"
            } else if self.type == .hotel {
                midLabel.text = "- NIGHTS"
            }
        }
        
        if let dDate =  calendar.startDate, let rDate = calendar.endDate {
            let dif = dDate.dayInterval(another: rDate)
            if self.type == .flight {
                if dif != 0 {
                    midLabel.text = "\(dif) DAYS"
                } else {
                    midLabel.text = "SAME\nDAY"
                }
            } else if self.type == .hotel {
                midLabel.text = "\(dif) NIGHTS"
            }
        }
    }
    
    private func bottomView() -> UIView {
        let bgView = UIView()
        bgView.backgroundColor = kColorThemeColor
        //left
        let leftLabel = UILabel()
        leftLabel.textColor = UIColor.white
        leftLabel.font = UIFont.systemFont(ofSize: 14)
        leftLabel.text = " "
        bgView.addSubview(leftLabel)
        self.leftLabel = leftLabel
        let leftInfoLabel = UILabel()
        leftInfoLabel.textColor = UIColor.white
        leftInfoLabel.font = UIFont.systemFont(ofSize: 11)
        if self.type == .flight {
            leftInfoLabel.text = "Departure"
        } else if self.type == .hotel {
            leftInfoLabel.text = "Check-In"
        }
        bgView.addSubview(leftInfoLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(16)
        }
        leftInfoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(leftLabel.snp.bottom).offset(5)
            make.left.equalTo(leftLabel)
        }
        //right
        let rightLabel = UILabel()
        rightLabel.textColor = UIColor.white
        rightLabel.font = UIFont.systemFont(ofSize: 14)
        rightLabel.text = " "
        bgView.addSubview(rightLabel)
        let rightInfoLabel = UILabel()
        rightInfoLabel.textColor = UIColor.white
        rightInfoLabel.font = UIFont.systemFont(ofSize: 11)
        if self.type == .flight {
            rightInfoLabel.text = "Return"
        } else if self.type == .hotel {
            rightInfoLabel.text = "Check-Out"
        }
        bgView.addSubview(rightInfoLabel)
        self.rightLabel = rightLabel
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(16)
        }
        rightInfoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(rightLabel.snp.bottom).offset(5)
            make.right.equalTo(rightLabel)
        }
        //mid
        let midLabel = UILabel()
        midLabel.textColor = UIColor.white
        midLabel.font = UIFont.systemFont(ofSize: 11)
        midLabel.numberOfLines = 0
        bgView.addSubview(midLabel)
        self.midLabel = midLabel
        midLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-24)
        }
        
        let confirm = UIButton.init(type: .custom)
        confirm.setTitle("Confirm", for: .normal)
        confirm.setTitleColor(kColorThemeColor, for: .normal)
        confirm.setBackgroundColor(kColorWhite, forState: .normal)
        confirm.layer.cornerRadius = 2
        confirm.clipsToBounds = true
        confirm.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        bgView.addSubview(confirm)
        confirm.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(17)
            make.right.equalToSuperview().offset(-17)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(40)
        }
        self.dealDatesDisplay()
        return bgView
    }
    
    
}
