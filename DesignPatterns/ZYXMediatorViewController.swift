//
//  ZYXMediatorViewController.swift
//  DesignPatterns
//
//  Created by PengXiang on 2018/7/7.
//  Copyright © 2018年 PengXiang. All rights reserved.
//中介者模式

import UIKit

class ZYXMediatorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let mediator = SecurityStaffMediator()
        let zhangSan = SecurityStaff(name: "张三", mediator: mediator)
        let liSi = SecurityStaff(name: "李四", mediator: mediator)
        let wangWu = SecurityStaff(name: "王五", mediator: mediator)
        
        
        zhangSan.sendMessage("大厅有人抢劫")
        print("")
        
        liSi.sendMessage("我马上过去看看")
        print("")
        
        wangWu.sendMessage("我马上过去看看")
    }
}
//对于 Colleague 而言，他需要通过 Mediator 知道其他 Colleague 给他发送了什么消息，所以在 Colleague 协议中，定义了一个colleague(_:didSendMessage:)，具体的 Colleague 类通过实现这个方法，就知道其他 Colleague 说了什么。
//MediatorProtocol规定 Mediator 需要：1）添加 Colleague 的方法；2）通知其他Colleagues 当前的 Coleague 说了什么。
protocol Colleague : class {
    func colleague(_ colleague : Colleague? , didSendMessage message : String)
}
protocol MediatorProtocol : class {
    func addColleague(_ colleague : Colleague)
    func didSendMessage(_ message : String , by colleague : Colleague)
}
//首先 Mediator 需要知道 Colleague 的类型，所以这里使用了泛型，把Colleague 的类型定义为ColleagueType：1）用一个数组来保存所有的 Colleagues；2）提供了添加和移除 Colleague 的方法；3）invokeColleagues(closure:)通过传入的 closure 参数，让每一个 Colleague 去执行 closure 里面的任务；4）invokeColleagues(by:closure:)某一个 Colleague 通过 closure 告诉其他 Colleagues 执行closure 里面的任务。
class Mediator<ColleagueType> {
   private var colleagues : [ColleagueType] = []
    // MARK: - Manage Colleague
    func addColleague(_ colleague : ColleagueType) -> Void {
        colleagues.append(colleague)
    }
    func removeColleague(_ colleague : ColleagueType) -> Void {
        guard let index = colleagues.index(where: {($0 as AnyObject) === (colleague as AnyObject)}) else {
            return
        }
        colleagues.remove(at: index)
    }
    func invokeColleagues(closure : (ColleagueType) -> Void) -> Void {
        colleagues.forEach(closure)
    }
    func invokeColleagues(by colleague : ColleagueType , closure : (ColleagueType) -> Void) -> Void {
        colleagues.forEach {
            guard ($0 as AnyObject) !== (colleague as AnyObject) else { return }
            closure($0)
        }
    }
}
//Colleague 需要持有 Mediator，所以我们必须定义了一个mediator属性，并且使用weak避免循环引用。在初始化函数中，调用了 mediator 的addColleague方法，把 Colleague 添加到 Mediator 中；在sendMessage方法的实现里面，当前的安保人员通过调用 Mediator 的didSendMessage(_:by:)告诉 Mediator 发生了什么；最后还实现了Colleague协议，用来接受其他安保人员发出来的信息。
final class SecurityStaff {
    var name : String
    weak var mediator : MediatorProtocol?
    init(name : String , mediator : MediatorProtocol) {
        self.name = name
        self.mediator = mediator
        mediator.addColleague(self)
    }
    func sendMessage(_ message : String) -> Void {
        print("\(name)发送:\(message)")
        mediator?.didSendMessage(message, by: self)
    }
}
extension SecurityStaff : Colleague {
    func colleague(_ colleague: Colleague?, didSendMessage message: String) {
        print("\(name) 收到: \(message)")
    }
}
//SecurityStaffMediator继承自Mediator<Colleague>，然后实现MediatorProtocol，在didSendMessage(_:by:)方法中，通知其他 Colleagues 发生了什么。
final class SecurityStaffMediator: Mediator<Colleague> { }

extension SecurityStaffMediator: MediatorProtocol {
    func didSendMessage(_ message: String, by colleague: Colleague) {
        invokeColleagues(by: colleague) {
            $0.colleague(colleague, didSendMessage: message)
        }
    }
}
