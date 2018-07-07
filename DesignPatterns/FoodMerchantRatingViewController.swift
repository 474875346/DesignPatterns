//
//  FoodMerchantRatingViewController.swift
//  DesignPatterns
//
//  Created by PengXiang on 2018/7/5.
//  Copyright © 2018年 PengXiang. All rights reserved.
//策略模式

import UIKit
class FoodMerchantRatingViewController: UIViewController {
    private let foodMerchantRatingClient: FoodMerchantRatingStrategy
    // MARK: - Initializers
    
    init(withRaingClient client: FoodMerchantRatingStrategy) {
        foodMerchantRatingClient = client
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Views
    
    @IBOutlet private var merchantNameTextField: UITextField!
    @IBOutlet private var ratingServiceNameLabel: UILabel!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var reviewLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingServiceNameLabel.text = foodMerchantRatingClient.ratingServiceName
    }
    @IBAction private func searchButtonTapped() {
        guard let merchantName = merchantNameTextField.text,
            !merchantName.isEmpty  else {
                return
        }
        foodMerchantRatingClient
            .fetchRatingforMerchant(named: merchantName,
                                    success: { [weak self] (rating, review) in
                                        self?.ratingLabel.text = rating
                                        self?.reviewLabel.text = review
            })
    }
}
protocol FoodMerchantRatingStrategy {
    var ratingServiceName: String { get }
    func fetchRatingforMerchant(named name: String,
                                success: (_ rating: String, _ review: String) -> Void)
}

class DianPingClient: FoodMerchantRatingStrategy {
    let ratingServiceName = "大众点评"
    func fetchRatingforMerchant(named name: String,
                                success: (String, String) -> Void) {
        let rating = "⭐⭐⭐⭐"
        let review = "还不错！！！"
        success(rating, review)
    }
}

class KouBeiClient: FoodMerchantRatingStrategy {
    let ratingServiceName = "口碑"
    func fetchRatingforMerchant(named name: String,
                                success: (String, String) -> Void) {
        let rating = "⭐⭐⭐⭐⭐"
        let review = "非常好！"
        success(rating, review)
    }
}
