//
//  XLCalendarHeaderView.swift
//  CalendarTest
//
//  Created by xiaolei on 2019/2/28.
//  Copyright © 2019 xiaolei. All rights reserved.
//

import UIKit

class XLCalendarHeaderView: UICollectionReusableView {

    var monthLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = colorWithHexString("#f8f8f8")
        self.createUI()
    }
    
    private func createUI() {
        let monthLabel = UILabel()
        monthLabel.textColor = UIColor.black
        monthLabel.frame = self.bounds
        monthLabel.textAlignment = .center
        self.addSubview(monthLabel)
        self.monthLabel = monthLabel
    }
    
    func setMonth(_ str:String) {
        self.monthLabel.text = str
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
