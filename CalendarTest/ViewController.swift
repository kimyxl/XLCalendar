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

class ViewController:UIViewController, CalendarProtocol {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let mycalendar = XLCalendar.init(selectedDate: XLTimeManager.createADay(year: 2019, month: 6, day: 1))
//        mycalendar.frame = CGRect.init(x: 0, y: 20, width: self.view.bounds.width, height: self.view.bounds.height-20)
//        self.view.addSubview(mycalendar)
        
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = CalendarRoundTripVC()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setSeletedDate(_ date: Date?) {
        print(date)
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


///color
let kColorThemeColor        = colorWithHexString("#ed8649")
let kColorThemeLight        = colorWithHexString("#FCF1EA")
let kColorThemeRed          = colorWithHexString("#ff1c1c")
let kColorBlack             = colorWithHexString("#111111")
let kColorWhite             = colorWithHexString("#ffffff")
let kColorSegmentLine       = colorWithHexString("#d6d6d6")
let kColorGreyWord          = colorWithHexString("#999999")
let kColorTextGray          = colorWithHexString("#666666")
let kColorBackgroundColor   = colorWithHexString("#fefdfc")
//let kColorBackgroundColor = kColorThemeRed//test
let kColorThemeGreen        = colorWithHexString("#0b9d78")

//UIButton
extension UIButton {
    func setBackgroundColor(_ backgroundColor:UIColor, forState:UIControl.State) {
        self.setBackgroundImage(UIButton.imageWithColor(backgroundColor), for: forState)
    }
    
    fileprivate class func imageWithColor(_ color:UIColor)->UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
