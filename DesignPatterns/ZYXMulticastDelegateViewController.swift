//
//  ZYXMulticastDelegateViewController.swift
//  DesignPatterns
//
//  Created by PengXiang on 2018/7/7.
//  Copyright © 2018年 PengXiang. All rights reserved.
//多播委托模式

import UIKit

class ZYXMulticastDelegateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
//        首先创建了两个代理：fireStation和hospital。把fireStation定义为FireStation!，这样后面我们可以把fireStation设置为nil。然后把两个代理添加到multicastDelegate，接着通知特朗普大厦发生火灾，得到了我们预期的打印结果。
//
//        把fireStation设置为nil之后，只有医院接收到了通知。
        let securityCenter = SecurityCenter.shared
        var fireStation: FireStation! = FireStation()
        let hospital = HospitalEmergencyCenter()
        
        securityCenter.multicastDelegate.addDelegate(fireStation)
        securityCenter.multicastDelegate.addDelegate(hospital)
        securityCenter.multicastDelegate.notifyDelegates {
            $0.notifyFire(at: "特朗普大厦")
        }
        print("======分割线======")
        
        fireStation = nil
        
        securityCenter.multicastDelegate.notifyDelegates {
            $0.notifyFire(at: "特朗普大厦")
        }
//        多播委托模式非常适合用于把信息告诉代理的场景。如果是需要多个代理提供数据，这种模式就不适合了。
    }
}
//特朗普大厦发生火灾，大厦的安保中心及时通知消防中心和医院的急救中心。
//从这个例子可以分析得出：1）需要代理的对象是大厦的安保中心SecurityCenter；2）代理是消防中心FireStation和医院的急救中心HospitalEmergencyCenter；3）Swift默认没有提供多播委托给我们，需要自己创建MulticastDelegate；4）代理协议：FireEmergencyResponding。
//为了保证MulticastDelegate的通用性，把它定义为泛型。
//另外，为了不让MulticastDelegate强引用代理，定义了一个内部类DelegateWrapper来把代理包装起来，内部类里面弱引用代理。在内部类里面，delegate被定义为AnyObject?，而不是ProtocolType?，因为weak只能用于Class类型。
//还添加了管理代理的方法。
class MulticastDelegate<ProtocolType> {
    // MARK: - Helper Types
    
    private final class DelegateWrapper {
        weak var delegate: AnyObject?
        init(delegate: AnyObject) { self.delegate = delegate }
    }
    
    // MARK: - Properties
    
    private var delegateWrappers: [DelegateWrapper]
    private var delegates: [ProtocolType] {
        delegateWrappers = delegateWrappers.filter { $0.delegate != nil }
        return delegateWrappers.map { $0.delegate } as! [ProtocolType]
    }
    
    // MARK: - Initializers
    
    init(delegates: [ProtocolType] = []) {
        delegateWrappers = delegates
            .map { DelegateWrapper(delegate: $0 as AnyObject)}
    }
    
    // MARK: - Delegate Management
    
    func addDelegate(_ delegate: ProtocolType) {
        let wrapper = DelegateWrapper(delegate: delegate as AnyObject)
        delegateWrappers.append(wrapper)
    }
    
    func removeDelegate(_ delegate: ProtocolType) {
        guard let index = delegateWrappers
            .index(where: { $0.delegate === (delegate as AnyObject)}) else {
                return
        }
        delegateWrappers.remove(at: index)
    }
    
    func notifyDelegates(_ closure: (ProtocolType) -> Void) {
        delegates.forEach { closure($0) }
    }
}
//火灾紧急响应，只有一个方法，通知在某个地方发生了火灾。
protocol FireEmergencyResponding: class {
    func notifyFire(at location: String)
}
//消防中心和医院的急救中心
final class FireStation: FireEmergencyResponding {
    func notifyFire(at location: String) {
        print("已经通知消防员在\(location)发生了火灾")
    }
}

final class HospitalEmergencyCenter: FireEmergencyResponding {
    func notifyFire(at location: String) {
        print("已经通知医护人员在\(location)发生了火灾")
    }
}
///大厦的安保中心，因为安保中心通常只有一个，所以这里使用了单例。
final class SecurityCenter {
    static let shared = SecurityCenter()
    let multicastDelegate = MulticastDelegate<FireEmergencyResponding>()
}
