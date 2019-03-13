//
//  XLTimeManager+extension.swift
//  XLTimeManagerTest
//
//  Created by xiaolei on 2019/2/26.
//  Copyright © 2019 xiaolei. All rights reserved.
//


import Foundation

//String->Date
enum String2DateFormatterEnum:String {
    case a = "yyyy/MM/dd HH:mm"
    case b = "MM/dd/yyyy HH:mm"
    case c = "yyyy-MM-dd"
    case d = "dd-MM-yyyy"
    case e = "yyyy-MM-dd HH:mm"
    case f = "yyyy/MM/dd"
}

//Date->String
enum Date2StringFormatterEnum:String {
    case aa = "dd MMM'yy HH:mm" //special
    case bb = "EEE dd,MMM HH:mm"
    case cc = "EEE,dd MMM,yyyy"
    case dd = "dd MMM yyyy"
    case home = "ddMMM(月份全大写)'yy" //special
    case request = "yyyy-MM-dd"
    case traveler = "dd MMM'yyyy HH:mm"
    case bill = "dd MMM yyyy HH:mm:ss"
    case passenger = "dd-MM-yyyy"
    case navTitle = "dd MMM"
    case combineHome = "EEE,dd MMM"
    case full = "yyyy-MM-dd EEEE HH:mm"
}


extension Date {
    /*
     当需要添加formatter无法直接格式化的日期类型时，需要同时更改下面两个函数实现。
     eg: 02 Feb'19
     */
    
    var specialShowFormatterList:[Date2StringFormatterEnum] {
        get {
            return [.aa,.home]
        }
    }
    
    func specialHandler(_ style:Date2StringFormatterEnum) -> String {
        switch style {
        case .aa:
            return "\(day()) \(month_textAbbr())'\(year_last2())"
        case .home:
            return "\(day()) \(month_textAbbr().uppercased())'\(year_last2())"
        default:
            return ""
        }
    }
}

