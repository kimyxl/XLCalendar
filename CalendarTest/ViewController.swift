//
//  ViewController.swift
//  CalendarTest
//
//  Created by xiaolei on 2019/2/27.
//  Copyright © 2019 xiaolei. All rights reserved.
//

import UIKit

let kScreenW = UIScreen.main.bounds.width
let kScale = UIScreen.main.scale

import SnapKit

class ViewController:UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let mycalendar = XLCalendar.init(selectedDate: XLTimeManager.createADay(year: 2019, month: 6, day: 1))
        mycalendar.frame = CGRect.init(x: 0, y: 20, width: self.view.bounds.width, height: self.view.bounds.height-20)
        self.view.addSubview(mycalendar)
        
        
    }
}



func colorWithHexString(_ hexString:String)->UIColor {
    
    var cString = hexString.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
    if (cString.hasPrefix("#")) {
        let index = cString.index(cString.startIndex, offsetBy:1)
        cString = String(cString[index...])
    }
    if (cString.count != 6) {
        return UIColor.red
    }
    let rIndex = cString.index(cString.startIndex, offsetBy: 2)
    let rString = String(cString[..<rIndex])
    let otherString = String(cString[rIndex...])
    let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
    let gString = String(otherString[..<gIndex])
    let bIndex = cString.index(cString.endIndex, offsetBy: -2)
    let bString = String(cString[bIndex...])
    
    var red:CUnsignedInt = 0, green:CUnsignedInt = 0, blue:CUnsignedInt = 0;
    Scanner(string: rString).scanHexInt32(&red)
    Scanner(string: gString).scanHexInt32(&green)
    Scanner(string: bString).scanHexInt32(&blue)
    return RGBA(red:CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
}

func RGBA (red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)->UIColor {
    return UIColor (red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
}


func DispatchAfter_main(after:Double, handler:@escaping()->Void) {
    DispatchQueue.main.asyncAfter(deadline: .now()+after) {
        handler()
    }
}
