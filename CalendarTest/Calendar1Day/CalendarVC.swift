//
//  CalendarVC.swift
//  CalendarTest
//
//  Created by xiaolei on 2019/3/14.
//  Copyright © 2019 xiaolei. All rights reserved.
//

import UIKit

protocol CalendarProtocol:class {
    func setSeletedDate(_ date:Date)
}

class CalendarVC: UIViewController {
    weak var delegate:CalendarProtocol?
    private var calendar:XLCalendarView!
    private var _selectedDate:Date?
    private var _minimumDate:Date?
    private var _maximumDate:Date?
    
    private(set) var lowestPriceDic = [String:Any]()
    private(set) var lowestDayOfMonth =  [String:[String]]()
    
    private var bottomView:UIView!
    convenience init(selectedDate:Date?, minimumDate minDate:Date? = nil, maximumDate maxDate:Date? = nil) {
        self.init()
        self._selectedDate = selectedDate
        self._minimumDate = minDate
        self._maximumDate = maxDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        let calendarView = XLCalendarView.init(selectedDate: self._selectedDate, minDate: self._minimumDate, maxDate: self._maximumDate)
        self.calendar = calendarView
        self.view.addSubview(calendarView)
        let bottomView = getBottomView()
        self.view.addSubview(bottomView)
        
        calendarView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.height.equalTo(55)
            make.left.right.equalToSuperview()
             make.bottom.equalToSuperview().offset(-0)
        }
        self.bottomView = bottomView
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.bottomView.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-kSafeBottomHeiht)
        }
    }
    
    @objc private func confirmAction() {
        if let sdate = self.calendar.selectedDate {
            delegate?.setSeletedDate(sdate)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func getBottomView() -> UIView {
        let content = UIView()
        let line = UIView()
        line.backgroundColor = kColorSegmentLine
        content.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        let confirmBtn = UIButton.init(type: .custom)
        confirmBtn.setTitle("Confirm", for: .normal)
        confirmBtn.setBackgroundColor(kColorThemeColor, forState: .normal)
        confirmBtn.setTitleColor(kColorWhite, for: .normal)
        confirmBtn.layer.cornerRadius = 2
        confirmBtn.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        content.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(17)
            make.right.equalToSuperview().offset(-17)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
        return content
    }
    
    var kSafeBottomHeiht:CGFloat {
        get {
            if #available(iOS 11.0, *) {
                return self.view.safeAreaInsets.bottom
            }
            else {
                if self.hidesBottomBarWhenPushed {
                    return 0
                }
                else {
                    return 49
                }
            }
        }
    }
}
