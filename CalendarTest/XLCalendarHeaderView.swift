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
        self.backgroundColor = UIColor.white
        let line = UIView.init()
        line.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: 0.5)
        line.backgroundColor = kColorSegmentLine
        self.addSubview(line)
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
