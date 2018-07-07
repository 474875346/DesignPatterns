//
//  ZYXBuilderPatternViewController.swift
//  DesignPatterns
//
//  Created by PengXiang on 2018/7/6.
//  Copyright © 2018年 PengXiang. All rights reserved.
//建造者模式

import UIKit

class ZYXBuilderPatternViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let employee = Employee()
        
        let beefHamburger = employee.createBeefHamburger()
        print(beefHamburger.description) // beef hamburger
        
        let chickenHamburger = employee.createChickenHamburger()
        print(chickenHamburger.description) // chicken hamburger
    }
}
//Product是Hamburger；Director是员工Employee，Builder是HamburgerBuilder
struct Hamburger {
    let meat : Meat
    let toppings : Toppings
    let sauces : Sauces
}
extension Hamburger : CustomStringConvertible {
    var description: String {
        return meat.rawValue + " Hamburger"
    }
}
enum Meat: String {
    case beef
    case chicken
}
struct Toppings: OptionSet {
    static let cheese = Toppings(rawValue: 1 << 0)
    static let lettuce = Toppings(rawValue: 1 << 1)
    static let tomatoes = Toppings(rawValue: 1 << 2)
    
    let rawValue: Int
    
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

struct Sauces: OptionSet {
    static let mustard = Sauces(rawValue: 1 << 0)
    static let ketchup = Sauces(rawValue: 1 << 1)
    
    let rawValue: Int
    
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
//Hamburger由肉Meat、配料Toppings和调味汁Sauces组成；另外实现了CustomStringConvertible，待会我们打印的时候能看到是什么汉堡。。其中肉可以选择牛肉和肌肉中的一种；配料可以多选：奶酪、生菜和番茄；调味汁也可以多选：芥末和番茄酱。
class HamburgerBuilder {
    private(set) var meat: Meat = .chicken
    private(set) var toppings: Toppings = []
    private(set) var sauces: Sauces = []
    func setMeat(_ meat : Meat) -> Void {
        self.meat = meat
    }
    func addToppings(_ toppings: Toppings) {
        self.toppings.insert(toppings)
    }
    
    func removeToppings(_ toppings: Toppings) {
        self.toppings.remove(toppings)
    }
    
    func addSauces(_ sauces: Sauces) {
        self.sauces.insert(sauces)
    }
    
    func removeSauces(_ sauces: Sauces) {
        self.sauces.remove(sauces)
    }
    
    func build() -> Hamburger {
        return Hamburger(meat: meat,
                         toppings: toppings,
                         sauces: sauces)
    }
}
//定义了制作汉堡需要的三种原料，并且使用了private(set)，防止被外部篡改（我们在写程序的时候，也要有这种思想，只暴露外部需要的api）；还有其他添加或者移除材料的方法；最后是最终完成制作的方法。
class Employee {
    private let builder = HamburgerBuilder()
    
    func createBeefHamburger() -> Hamburger {
        builder.setMeat(.beef)
        builder.addSauces(.ketchup)
        builder.addToppings([.lettuce, .tomatoes])
        return builder.build()
    }
    
    func createChickenHamburger() -> Hamburger {
        let builder = HamburgerBuilder()
        builder.setMeat(.chicken)
        builder.addSauces(.mustard)
        builder.addToppings([.lettuce, .tomatoes])
        return builder.build()
    }
}
//鸡肉汉堡和牛肉汉堡


