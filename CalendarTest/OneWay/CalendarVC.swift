//
//  CalendarVC.swift
//  CalendarTest
//
//  Created by xiaolei on 2019/3/14.
//  Copyright © 2019 xiaolei. All rights reserved.
//

import UIKit

protocol CalendarProtocol:class {
    func setSeletedDate(_ date:Date?)
}

class CalendarVC: UIViewController {
    weak var delegate:CalendarProtocol?
    private var calendar:XLCalendarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        let calendarView = XLCalendarView.init(selectedDate: Date())
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
            make.left.bottom.right.equalToSuperview()
        }
        
    }
    
    @objc private func confirmAction() {
        delegate?.setSeletedDate(calendar.selectedDate)
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
}
