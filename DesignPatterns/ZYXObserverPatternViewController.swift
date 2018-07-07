//
//  ZYXObserverPatternViewController.swift
//  DesignPatterns
//
//  Created by PengXiang on 2018/7/6.
//  Copyright © 2018年 PengXiang. All rights reserved.
//观察者模式

import UIKit

class ZYXObserverPatternViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User(name: "Lebron")
        var _ : NSKeyValueObservation? = user.observe(\.name, options: [.initial,.new]) { (user, change) in
            print("名字是：\(user.name)")
        }
        user.name = "Love"
    }
}
@objcMembers class User: NSObject {
    dynamic var name : String
    public init(name:String) {
        self.name = name
    }
}
