//
//  XLTimeManager.swift
//
//  Created by xiaolei on 2019/5/17.
//  Copyright © 2019 xiaolei. All rights reserved.
/*
 EEEE：表示星期几（如 Monday）。使用 1-3 个字母表示周几的缩略写法。(EEE：Mon)
 MMMM：月份的全写（如 October）。使用 1-3 个字母表示月份的缩略写法。(MMM：Oct, MM：11)
 dd：表示一个月里面日期的数字（如 09 或 15）。
 yyyy：4 个数字表示的年（如 2015）。
 HH：2 个数字表示的小时（如 08 或 19）。
 mm：2 个数字表示的分钟（如 05 或者 54）。
 ss：2 个数字表示的秒。
 zzz：3 个字母表示的时区（如 GMT）。
 GGG：BC 或者 AD。
 */
/*
 NSDate 对象封装了单个的时间点，独立于任何特定的日历系统或者时区。
 所有的 NSDate 都存储了一个浮点数，这个浮点数代表了从 2001 年 1 月 1 日 00:00:00 UTC 起的秒数。这些秒数与时区、星期几、月份、夏令时、闰秒或者闰年一点关系都没有。如果所需的计算基于秒数就可以完成，那么它会在 NSDate 上进行。否则，就要借助其他的类型了。
 */


import Foundation


class XLTimeManager {
    static var calendar:Calendar {
        get {
            calendar_gregorian.timeZone = TimeZone.current
            return calendar_gregorian
        }
    }
    static private var calendar_gregorian:Calendar = {
        var calendar = Calendar.init(identifier: .gregorian)
        return calendar
    }()
    
    fileprivate static var formatter:DateFormatter {
        get {
            formatter_default.timeZone = TimeZone.current
            return formatter_default
        }
    }
    static private let formatter_default:DateFormatter = {
        let formatter = DateFormatter.init()
        let locale = Locale.init(identifier: "en_US")
        formatter.locale = locale
        return formatter
    }()
    
    class func createADay(year:Int, month:Int, day:Int) -> Date? {
        var components = DateComponents.init()
        components.day = day
        components.month = month
        components.year = year
        components.timeZone = TimeZone.current
        let date = calendar.date(from: components)
        return date
    }
    
    fileprivate static let formatterGMT:DateFormatter = {
        let formatter = DateFormatter.init()
        formatter.timeZone = TimeZone.init(identifier: "GMT")!
        let locale = Locale.init(identifier: "en_US")
        formatter.locale = locale
        return formatter
    }()
    
    fileprivate class func dateComponents(_ date:Date) -> DateComponents {
        let dateComponents = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year, Calendar.Component.weekOfYear, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second, Calendar.Component.weekday, Calendar.Component.timeZone], from: date)
        return dateComponents
    }
}

//Date与string转换，不涉及时区问题
extension String {
    func dateFromFormatter(type formatterType:String2DateFormatterEnum) -> Date? {
        XLTimeManager.formatter.dateFormat = formatterType.rawValue
        let date = XLTimeManager.formatter.date(from: self)
        return date
    }
    func dateFromFormatterStr(formatterStr:String) -> Date? {
        XLTimeManager.formatter.dateFormat = formatterStr
        let date = XLTimeManager.formatter.date(from: self)
        return date
    }
}

extension Date {
    func dateString(_ style:Date2StringFormatterEnum) -> String {
        //特殊判断
        if self.specialShowFormatterList.contains(style) {
            return self.specialHandler(style)
        }
        //常规
        XLTimeManager.formatter.dateFormat = style.rawValue
        let convertedDateString = XLTimeManager.formatter.string(from: self)
        return convertedDateString
    }
    
    func dateGMTString(_ style:Date2StringFormatterEnum) -> String {
        guard self.specialShowFormatterList.contains(style) == false else {return ""}
        XLTimeManager.formatterGMT.dateFormat = style.rawValue
        let convertedDateString = XLTimeManager.formatterGMT.string(from: self)
        return convertedDateString
    }
    
    func adding(day:Int, month:Int=0, year:Int=0) -> Date? {
        var components = DateComponents.init()
        components.day = day
        components.month = month
        components.year = year
        let calculatedDate = XLTimeManager.calendar.date(byAdding: components, to: self)
        return calculatedDate
    }
    
    func get0ClockDate() -> Date {
        let dateComponents = XLTimeManager.calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: self)
        return XLTimeManager.createADay(year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!)!
    }
    
    //无视时分秒计算日期差值
    func dayInterval(another:Date) -> Int {
        let date1 = self.get0ClockDate()
        let date2 = another.get0ClockDate()
        return date1.differDays(date:date2)
    }
    
    func isSameDay(_ another:Date) -> Bool {
        let days = self.dayInterval(another: another)
        if days == 0 { return true }
        return false
    }
    ///不包含，以“天”为单位判断
    func isBeforeDay(_ beforeDate:Date) -> Bool {
        let days = self.dayInterval(another: beforeDate)
        if days > 0 { return true }
        return false
    }
    ///不包含，以“天”为单位判断
    func isAfterDay(_ afterDay:Date) -> Bool {
        let days = self.dayInterval(another: afterDay)
        if days < 0 { return true }
        return false
    }
    
    /// 两日期相差天数, 返回值为正负零, 可判断日期前后(不满24小时不算一天)
    func differDays(date:Date) -> Int {
        let diffDateComponents = XLTimeManager.calendar.dateComponents([Calendar.Component.day], from: self, to: date)
        return diffDateComponents.day ?? 0
    }
    // 两日期相差月数, 返回值为正负零, 可判断日期前后(不满24小时不算一天)
    func differMonths(date:Date) -> Int {
        let diffDateComponents = XLTimeManager.calendar.dateComponents([Calendar.Component.month], from: self, to: date)
        return diffDateComponents.month ?? 0
    }
    /// 两日期相隔年月日 -> [年，月，日] (正负值) (不满24小时不算一天)
    func differDate(date:Date) -> [Int] {
        let diffDateComponents = XLTimeManager.calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: self, to: date)
        let year = diffDateComponents.year ?? 0
        let month = diffDateComponents.month ?? 0
        let day = diffDateComponents.day ?? 0
        return [year,month,day]
    }
    
    func year() -> String {
        return "\(self.year_digital())"
    }
    func year_digital() -> Int {
        let dateComponets = XLTimeManager.dateComponents(self)
        return dateComponets.year ?? 0
    }
    func year_last2() -> String {
        let str = self.year()
        let startIndex = str.index(str.endIndex, offsetBy: -2)
        return String(str[startIndex...])
    }
    
    func day() -> String {
        let num = self.day_digital()
        return self.dealSingleString(num)
    }
    func day_digital() -> Int {
        let dateComponets = XLTimeManager.dateComponents(self)
        return dateComponets.day ?? 0
    }
    
    func hour() -> String {
        let num = self.hour_digital()
        return self.dealSingleString(num)
    }
    func hour_digital() -> Int {
        let dateComponets = XLTimeManager.dateComponents(self)
        return dateComponets.hour ?? 0
    }
    
    func minute() -> String {
        let num = self.minute_digital()
        return self.dealSingleString(num)
    }
    func minute_digital() -> Int {
        let dateComponets = XLTimeManager.dateComponents(self)
        return dateComponets.minute ?? 0
    }
    
    func second() -> String {
        let num = self.second_digital()
        return self.dealSingleString(num)
    }
    func second_digital() -> Int {
        let dateComponets = XLTimeManager.dateComponents(self)
        return dateComponets.second ?? 0
    }
    
    func month() -> String {
        let num = self.month_digital()
        return self.dealSingleString(num)
    }
    func month_digital() -> Int {
        let dateComponets = XLTimeManager.dateComponents(self)
        return dateComponets.month ?? 0
    }
    func month_textFull() -> String {
        XLTimeManager.formatter.dateFormat = "MMMM"
        return  XLTimeManager.formatter.string(from: self)
    }
    func month_textAbbr() -> String {
        XLTimeManager.formatter.dateFormat = "MMM"
        return  XLTimeManager.formatter.string(from: self)
    }
    
    func week() -> String {
        let num = self.week_digital()
        return self.dealSingleString(num)
    }
    func week_digital() -> Int {
        let dateComponets = XLTimeManager.dateComponents(self)
        return dateComponets.weekday ?? 0
    }
    func week_textFull() -> String {
        XLTimeManager.formatter.dateFormat = "EEEE"
        return  XLTimeManager.formatter.string(from: self)
    }
    func week_textAbbr() -> String {
        XLTimeManager.formatter.dateFormat = "EEE"
        return  XLTimeManager.formatter.string(from: self)
    }
    private func dealSingleString(_ num:Int) -> String {
        if num < 10 {
            return "0\(num)"
        } else {
            return "\(num)"
        }
    }
}

extension TimeInterval {
    func dateFromTimeStamp() -> Date? {
        var num = self
        if self > 999999999999 {
            num /= 1000.0
        }
        let date = Date.init(timeIntervalSince1970: num)
        return date
    }
}

