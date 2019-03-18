//
//  XLCalendar.swift
//  CalendarTest
//
//  Created by xiaolei on 2019/3/1.
//  Copyright © 2019 xiaolei. All rights reserved.
//

import UIKit

class XLCalendar2DayView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private(set) var startDate:Date?
    private(set) var endDate:Date?
    private(set) var minDate:Date = Date()
    private(set) var maxDate:Date = Date()
    private(set) var today = Date()
    
    private let cellid = "XLCalendarRoundTripCellid"
    private let headerid = "XLCalendarRoundTripHeaderid"
    private var collectionView:UICollectionView!
    private var weekView:UIView?
    private var allMonth = 13
    private var firstDayInMonth = [Date]()
    
    enum TripSelectState {
        case shouldChooseDepart
        case shouldChooseReturn
        case done
    }
    
    convenience init(start:Date?, end:Date?) {
        self.init(frame: .zero)
        self.today = self.get0ClockDate(Date())
        self.minDate = self.get0ClockDate(self.minDate)
        self.maxDate = self.minDate.adding(day: 0, month: 0, year: 1)!
        self.allMonth = self.minDate.differMonths(date: self.maxDate)+1
        guard self.allMonth>0 else { return }
        
        func handleSelectedDates(_ selectedDate:Date) -> Date? {
            if selectedDate.isBefore(self.maxDate) && selectedDate.isAfter(self.minDate) || selectedDate.isSameDay(self.maxDate) || selectedDate.isSameDay(self.minDate) {
                return self.get0ClockDate(selectedDate)
            }
            return nil
        }
        
        if let startDate = start {
            self.startDate = handleSelectedDates(startDate)
        }
        
        if let endDate = end {
            self.endDate = handleSelectedDates(endDate)
        }
        
        self.createUI()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = CGRect.init(x:0, y: 31, width: self.frame.width, height: self.frame.height-31)
    }
    
    private func judgeTripState() -> TripSelectState {
        if self.startDate == nil {
            if self.endDate != nil {
                self.endDate = nil
            }
            return .shouldChooseDepart
        }
        if self.startDate != nil && self.endDate == nil {
            return .shouldChooseReturn
        }
        return .done
    }
    
    ///当月总天数
    private func daysInMonth(_ date:Date) -> Int {
        let daysInMonth = XLTimeManager.calendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: date)
        return daysInMonth!.count
    }
    
    //MARK: ------------- DataSource & Delegate----------------------
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.allMonth
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let startDays = firstDayInMonth[section].week_digital()-1
        let daysWithStart = daysInMonth(firstDayInMonth[section])+startDays
        let numbersInRow = (collectionView.collectionViewLayout as? XLCanlendarViewLayout)?.numbersInRow ?? 7
        var rows = daysWithStart/numbersInRow
        if daysWithStart%numbersInRow != 0 {
            rows += 1
        }
        let allcount = rows*numbersInRow
        return allcount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! XLCalendar2DayCell
        cell.calendar = self
        let date = self.indexpath2Date(indexPath)
        if date != nil {
            cell.setDate(date)
        } else {
            cell.setDate(nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerid, for: indexPath) as? XLCalendarHeaderView
        let firstDay = self.firstDayInMonth[indexPath.section]
        headerView?.setMonth("\(firstDay.month_textFull())  \(firstDay.year())")
        return headerView ?? XLCalendarHeaderView()
    }
    
    // UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let date = self.indexpath2Date(indexPath)
        guard let dateExsit = date else {return}
        let bool1 = dateExsit.isAfter(self.minDate)
        let bool2 = dateExsit.isBefore(self.maxDate)
        let bool3 = (dateExsit.isSameDay(self.minDate))
        let bool4 = (dateExsit.isSameDay(self.maxDate))
        guard (bool1 && bool2) || bool3 || bool4 else {return}
        if judgeTripState() == .shouldChooseDepart {
            self.startDate = dateExsit
        } else if judgeTripState() == .shouldChooseReturn {
            if dateExsit.isBefore(self.startDate!) {
                self.startDate = dateExsit
                self.endDate = nil
            } else {
                self.endDate = dateExsit
            }
        } else if judgeTripState() == .done {
            self.startDate = dateExsit
            self.endDate = nil
        }
        collectionView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "XLCalendar2DayViewDidSelecteAnItem"), object: nil)
    }
    
    //MARK: ----  functions --------
    private func date2Indexpath(_ date:Date) -> IndexPath {
        var indexPath = IndexPath.init(item: 0, section: 0)
        for (index,d) in self.firstDayInMonth.enumerated() {
            if d.year_digital() == date.year_digital() && d.month_digital() == date.month_digital() {
                indexPath.section = index
                break
            }
        }
        let startDays = self.firstDayInMonth[indexPath.section].week_digital()-1
        let dayNum = startDays + date.day_digital() - 1
        indexPath.item = dayNum
        return indexPath
    }
    
    private func indexpath2Date(_ indexPath: IndexPath) -> Date? {
        let startDays = self.firstDayInMonth[indexPath.section].week_digital()-1
        let dayNum = indexPath.item+1-startDays
        if dayNum > daysInMonth(self.firstDayInMonth[indexPath.section]) {
            return nil
        }
        if dayNum > 0 {
            let firstDate = self.firstDayInMonth[indexPath.section]
            let date = XLTimeManager.createADay(year: firstDate.year_digital(), month: firstDate.month_digital(), day: dayNum)
            return date
        }
        return nil
    }
    
    private func get0ClockDate(_ localDate:Date) -> Date {
        let dateComponents = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year, Calendar.Component.hour], from: localDate)
        return XLTimeManager.createADay(year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!)!
    }
    
    //MARK: ----  UI
    private func createUI() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNoti(_:)), name: NSNotification.Name(rawValue: "XLCanlendarViewLayoutCalculateItemWidthDone"), object: nil)
        
        let year = self.today.year_digital()
        let month = self.today.month_digital()
        let firstDay = XLTimeManager.createADay(year: year, month: month, day: 1)!
        for i in 0..<self.allMonth {
            let fday = firstDay.adding(day: 0, month: i, year: 0)!
            self.firstDayInMonth.append(fday)
        }
        
        let layout = XLCanlendarViewLayout.init()
        
        let collectionView = UICollectionView.init(frame: CGRect.init(x:0, y: 31, width: self.frame.width, height: self.frame.height-31), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(collectionView)
        collectionView.register(XLCalendar2DayCell.self, forCellWithReuseIdentifier: cellid)
        collectionView.register(XLCalendarHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerid)
        
        self.collectionView = collectionView
        if let selectedDate = self.startDate {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
                self.collectionView.scrollToItem(at: self.date2Indexpath(selectedDate), at: .centeredVertically, animated: true)
            }
        }
    }
    
    @objc private func receiveNoti(_ noti:NSNotification) {
        var leftMargin:CGFloat = 0
        if let dic = noti.object as? [String:CGFloat] {
            leftMargin = dic["leftMargin"] ?? 0
        }
        self.addWeek(leftMargin)
    }
    
    private func addWeek(_ leftMaigin:CGFloat) {
        guard weekView == nil else { return }
        let weekview = createWeekView(frame: CGRect.init(x: collectionView.frame.origin.x, y: 0, width: collectionView.frame.width, height: 30), eachWidth: (collectionView.collectionViewLayout as! XLCanlendarViewLayout).itemWidth, leftMaigin: leftMaigin)
        weekview.backgroundColor = UIColor.white
        self.addSubview(weekview)
        self.weekView = weekview
    }
    
    private func createWeekView(frame:CGRect, eachWidth:CGFloat, leftMaigin:CGFloat) -> UIView {
        let weekView = UIView()
        weekView.frame = frame
        let arr = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        for (index,str) in arr.enumerated() {
            let weeklabel = UILabel()
            weeklabel.frame = CGRect.init(x: leftMaigin+CGFloat(index)*eachWidth, y: 0, width: eachWidth, height: frame.height)
            weeklabel.text = str
            weeklabel.font = UIFont.systemFont(ofSize: 15, weight: .thin)
            weeklabel.textAlignment = .center
            weekView.addSubview(weeklabel)
        }
        weekView.layer.shadowOpacity = 0.3
        weekView.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        weekView.layer.shadowColor = UIColor.black.cgColor
        weekView.layer.shadowRadius = 2
        return weekView
    }
    
}

