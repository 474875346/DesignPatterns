//
//  ZYXChainOfResponsibilityViewController.swift
//  DesignPatterns
//
//  Created by PengXiang on 2018/7/7.
//  Copyright © 2018年 PengXiang. All rights reserved.
//责任链模式

import UIKit

class ZYXChainOfResponsibilityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let fiveYuanHandler = RMBHandler(rmbType: FiveYuan.self)
        let tenYuanHandler = RMBHandler(rmbType: TenYuan.self)
        let twentyYuanHandler = RMBHandler(rmbType: TwentyYuan.self)
        
        fiveYuanHandler.next = tenYuanHandler
        tenYuanHandler.next = twentyYuanHandler
        
        let vendingMachine = VendingMachine(rmbHandler: fiveYuanHandler)
        //插入标准的5元纸币
        let fiveYuan = FiveYuan()
        vendingMachine.insertRMB(fiveYuan)
        //插入标准的20元纸币
        let twentyYuan = TwentyYuan()
        vendingMachine.insertRMB(twentyYuan)
        //投入无效的纸币
        let rmb = RMB(width: TwentyYuan.standardWidth,
                      height: FiveYuan.standardHeight)
        vendingMachine.insertRMB(rmb)
    }
}
//创建一个 RMB 基类：
//1）standardWidth和standardHeight只读属性表示纸币的标准宽高，单位是毫米，让子类实现；
//2）rmbValue表示纸币面值，让子类实现；
//3）width和 height两个存储属性，表示纸币的实际长宽，单位是毫米，因为纸币在使用过程等中，肯定会有一些磨损，实际的长宽与标准长宽有差别；
//4）required标记的初始化函数，我们需要通过这个函数来初始化；
//5）convenience初始化函数，用于创建标准的 RMB；
//6）最后实现了CustomStringConvertible，打印的时候更好看
class RMB  {
    class var standardWidth:CGFloat {
        return 0
    }
    class var standardHeight: CGFloat {
        return 0
    }
    
    var rmbValue: Double {
        return 0
    }
    final let width: CGFloat
    final let height: CGFloat
    
    required init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    convenience init() {
        let width = type(of: self).standardWidth
        let height = type(of: self).standardHeight
        self.init(width: width, height: height)
    }
}
extension RMB: CustomStringConvertible {
    var description: String {
        return "长：\(width)，宽：\(height)，面值：\(rmbValue)元"
    }
}
//分别创建了FiveYuan、TenYuan和TwentyYuan。
final class FiveYuan: RMB {
    
    override class var standardWidth: CGFloat {
        return 135
    }
    override class var standardHeight: CGFloat {
        return 63
    }
    override var rmbValue: Double {
        return 5
    }
}

final class TenYuan: RMB {
    
    override class var standardWidth: CGFloat {
        return 140
    }
    override class var standardHeight: CGFloat {
        return 70
    }
    override var rmbValue: Double {
        return 10
    }
}

final class TwentyYuan: RMB {
    
    override class var standardWidth: CGFloat {
        return 145
    }
    override class var standardHeight: CGFloat {
        return 70
    }
    override var rmbValue: Double {
        return 20
    }
}
//首先创建了RMBHandlerProtocol，规定next属性和handleRMBValidation(_:)方法。
protocol RMBHandlerProtocol {
    var next: RMBHandlerProtocol? { get }
    func handleRMBValidation(_ unknownRMB: RMB) -> RMB?
}
//创建具体的 Handler，RMBHandler：
//– 1）next，下一个 RMBHandler；
//– 2）rmbType，人民币类型，这样我们就不必为每一类纸币都创建一个Handler，例如FiveYuanHandler等；
//– 3）widthRange和heightRange是有效的长宽范围；
//– 4）在初始化函数中，我们默认地允许长宽的误差为1毫米；
//– 5）实现handleRMBValidation(_:)，判断传入的unknownRMB的长宽是否符合要求，若符合，创建具体的 RMB 实例，否则让下一个 handler 继续处理。
final class RMBHandler: RMBHandlerProtocol {
    var next: RMBHandlerProtocol?
    let rmbType: RMB.Type
    let widthRange: ClosedRange<CGFloat>
    let heightRange: ClosedRange<CGFloat>
    
    init(rmbType: RMB.Type,
         widthTolerance: CGFloat = 1,
         heightTolerance: CGFloat = 1) {
        
        self.rmbType = rmbType
        
        let standardWidth = rmbType.standardWidth
        self.widthRange = (standardWidth - widthTolerance) ...
            (standardWidth + widthTolerance)
        
        let standardHeight = rmbType.standardHeight
        self.heightRange = (standardHeight - heightTolerance) ...
            (standardHeight + heightTolerance)
    }
}

extension RMBHandler {
    func handleRMBValidation(_ unknownRMB: RMB) -> RMB? {
        guard let rmb = createRMB(from: unknownRMB) else {
            return next?.handleRMBValidation(unknownRMB)
        }
        return rmb
    }
    
    private func createRMB(from unknownRMB: RMB) -> RMB? {
        print("尝试创建RMB：\(rmbType)")
        guard widthRange.contains(unknownRMB.width) else {
            print("长度不符合要求")
            return nil
        }
        guard heightRange.contains(unknownRMB.height) else {
            print("宽度不符合要求")
            return nil
        }
        let rmb = rmbType.init(width: unknownRMB.width,
                               height: unknownRMB.height)
        print("已创建纸币，\(rmb)")
        return rmb
    }
}
//创建了 Client 角色，VendingMachine：
//1）rmbHandler：handler 链的第一个handler，自动售货机不需要知道 handler 链的所有 handlers；
//2）rmbs：所有已投的有效人民币；
//3）简单的初始化函数；
//4）insertRMB(_:)插入未知的人民币，首先验证是否是有效的人民币，如果有效，添加到rmbs中，最后打印已投币的总额。
final class VendingMachine {
    
    private let rmbHandler: RMBHandler
    private(set) var rmbs: [RMB] = []
    
    init(rmbHandler: RMBHandler) {
        self.rmbHandler = rmbHandler
    }
    
    func insertRMB(_ unknownRMB: RMB) {
        guard let rmb = rmbHandler
            .handleRMBValidation(unknownRMB) else {
                print("无效的纸币")
                return
        }
        print("纸币已接收")
        rmbs.append(rmb)
        
        let totalValue = rmbs.reduce(0, { $0 + $1.rmbValue })
        print("已投币总金额：\(totalValue)元")
    }
}
