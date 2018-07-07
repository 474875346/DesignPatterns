//
//  ZYXFacadeViewController.swift
//  DesignPatterns
//
//  Created by PengXiang on 2018/7/7.
//  Copyright © 2018年 PengXiang. All rights reserved.
// 门面模式

import UIKit

class ZYXFacadeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let cola = Product(id: UUID().uuidString, name: "可乐", price: 3)
        let sprite = Product(id: UUID().uuidString, name: "雪碧", price: 3)
        
        let inventoryDatabase = InventoryDatabase(inventory: [cola: 10, sprite: 10])
        let shippingDatabase = ShippingDatabase()
        
        let orderFacade = OrderFacade(inventoryDatabase: inventoryDatabase,shippingDatabase: shippingDatabase)
        
        let customer = Customer(id: UUID().uuidString,address: "深圳南山区xx街道xx小区10栋",name: "Lebron James")
        
        orderFacade.placeOrder(for: cola, by: customer)
    }
}
//这里我们就以刚刚提到的电商下单系统为例。首先我们需要Customer和Product数据模型；然后是库存InventoryDatabase；用户下单后，把已购买的产品存到待发货数据库ShippingDatabase中。实际开发中，肯定还需要顾客数据库和发票的处理等等，这里为了简便，我们就不考虑这些了。
///这里简单地创建了Customer和Product。因为后面要把他们作为字典的key，所以都实现了Hashable协议。
// MARK: - Customer
struct Customer {
    let id: String
    var address: String
    var name: String
}
extension Customer: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
    
    static func ==(lhs: Customer, rhs: Customer) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Product
struct Product {
    let id: String
    var name: String
    var price: Double
}
extension Product: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
    
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
//InventoryDatabase记录了某个产品对应的数量有多少个；ShippingDatabase记录了某个客户对应的待发货的产品。
final class InventoryDatabase {
    var inventory: [Product: Int] = [:]
    init(inventory: [Product: Int]) { self.inventory = inventory }
}

final class ShippingDatabase {
    var pendingShipments: [Customer: [Product]] = [:]
}
//在订单门面里，持有了InventoryDatabase和ShippingDatabase实例。还提供了一个下单的方法：先查询要下单的产品的库存，如果库存为0，则提示缺货；如果库存足够，把库存减一，并加到待发货数据库中。
final class OrderFacade {
    let inventoryDatabase: InventoryDatabase
    let shippingDatabase: ShippingDatabase
    
    init(inventoryDatabase: InventoryDatabase,shippingDatabase: ShippingDatabase) {
        self.inventoryDatabase = inventoryDatabase
        self.shippingDatabase = shippingDatabase
    }
    
    func placeOrder(for product: Product, by customer: Customer) {
        let productCount = inventoryDatabase.inventory[product, default: 0]
        
        guard productCount > 0 else {
            print("\(product.name)缺货")
            return
        }
        
        inventoryDatabase.inventory[product] = productCount - 1
        
        var pendingShipmentProducts = shippingDatabase.pendingShipments[customer, default: []]
        pendingShipmentProducts.append(product)
        shippingDatabase.pendingShipments[customer] = pendingShipmentProducts
        
        print("\(customer.name)购买了\(product.name)")
    }
}
