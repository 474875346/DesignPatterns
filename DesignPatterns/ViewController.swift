//
//  ViewController.swift
//  DesignPatterns
//
//  Created by PengXiang on 2018/7/5.
//  Copyright © 2018年 PengXiang. All rights reserved.
// MVC

import UIKit
//单例模式
class MySingleton {
    static let shared = MySingleton()
    private init() { }
}
let singleton = MySingleton.shared
class ViewController: UIViewController {
    
    
    weak var delegate: ViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    private let items: [MenuItem] = [.home, .me, .settings]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
}
extension ViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = items[indexPath.row].rawValue
            return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        delegate?.menuViewController(self, didSelectItem: item)
        //        self.navigationController?.pushViewController(FoodMerchantRatingViewController.init(withRaingClient:DianPingClient()), animated: true)
        //        self.navigationController?.pushViewController(MementoPatternViewController(), animated: true)
        //        self.navigationController?.pushViewController(ZYXObserverPatternViewController(), animated: true)
        //        self.navigationController?.pushViewController(ZYXBuilderPatternViewController(), animated: true)
        //        self.navigationController?.pushViewController(ZYXFactoryPatternViewController(), animated: true)
        //        self.navigationController?.pushViewController(ZYXAdapterViewController(), animated: true)
        //        self.navigationController?.pushViewController(ZYXStatePatternViewController(), animated: true)
        //        self.navigationController?.pushViewController(ZYXMulticastDelegateViewController(), animated: true)
        //        self.navigationController?.pushViewController(ZYXFacadeViewController(), animated: true)
        //        self.navigationController?.pushViewController(ZYXFlyweightViewController(), animated: true)
//        self.navigationController?.pushViewController(ZYXMediatorViewController(), animated: true)
//        self.navigationController?.pushViewController(ZYXCompositeViewController(), animated: true)
        self.navigationController?.pushViewController(ZYXChainOfResponsibilityViewController(), animated: true)
    }
}
protocol ViewControllerDelegate:class {
    func menuViewController(_ menuViewController: ViewController,
                            didSelectItem item: MenuItem)
}
enum MenuItem: String {
    case home = "首页"
    case me = "我的"
    case settings = "设置"
}
