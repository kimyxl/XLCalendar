//
//  CalendarRoundTripVC.swift
//  CalendarTest
//
//  Created by xiaolei on 2019/3/18.
//  Copyright © 2019 xiaolei. All rights reserved.
//

import UIKit


protocol CalendarRoundTripProtocol:class {
    func setSeletedDate(_ dateDepart:Date, _ dateReturn:Date)
}

class CalendarRoundTripVC: UIViewController {

    weak var delegate:CalendarRoundTripProtocol?
    private var calendar:XLCalendarRoundTrip!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = UIColor.white
        let calendarView = XLCalendarRoundTrip.init(selectedDepartDate: Date(), selectedReturnDate: nil)
        self.calendar = calendarView
        self.view.addSubview(calendarView)
        
        calendarView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func bottomView() {
        
    }
    
    
}
