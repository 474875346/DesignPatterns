//
//  ZYXFlyweightViewController.swift
//  DesignPatterns
//
//  Created by PengXiang on 2018/7/7.
//  Copyright © 2018年 PengXiang. All rights reserved.
//享元模式

import UIKit

class ZYXFlyweightViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let font1 = UIFont.SFUITextFont(style: .heavy, size: 20)
        let font2 = UIFont.SFUITextFont(style: .heavy, size: 20)
        print(font1 == font2)  // true
        // Do any additional setup after loading the view.
    }
}
//在开发中，难免会遇到自定义字体的需求，这里以自定义字体为例，假设在项目中要用到SFUIText这个系列的字体：
extension UIFont {
    
    enum SFUITextFontStyle: String {
        case medium = "SFUIText-Medium"
        case regular = "SFUIText-Regular"
        case heavy = "SFUIText-Heavy"
        case bold = "SFUIText-Bold"
        case semibold = "SFUIText-Semibold"
    }
    
    static var SFUITextFonts: [String: UIFont] = [:]
    
    static func SFUITextFont(style: SFUITextFontStyle,
                             size: CGFloat) -> UIFont? {
        
        let key = "\(style.rawValue)\(size)"
        if let font = SFUITextFonts[key] {
            return font
        }
        
        let font = UIFont(name: style.rawValue, size: size)
        SFUITextFonts[key] = font
        return font
    }
}
