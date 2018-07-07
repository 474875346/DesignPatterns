//
//  ZYXFactoryPatternViewController.swift
//  DesignPatterns
//
//  Created by PengXiang on 2018/7/6.
//  Copyright © 2018年 PengXiang. All rights reserved.
//

import UIKit

class ZYXFactoryPatternViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lebron = JobApplicant(name: "Lebron James", email: "lebronjames@example.com", status: .hired)
        let emailFactory = EmailFactory(senderEmail: "hr@company.com")
        let emial = emailFactory.createEmail(to: lebron)
        print(emial)
    }
}
//首先我们有两个模型，求职者JobApplicant和邮件Email
struct JobApplicant {
    let name : String
    let email : String
    var status : Status
    enum Status {
        case new
        case interview
        case hired
        case rejected
    }
}
struct Email {
    let subject: String
    let messageBody: String
    let recipientEmail: String
    let senderEmail: String
}
//我们的邮件工厂EmailFactory
struct EmailFactory {
    let senderEmail : String
    func createEmail(to recipient:JobApplicant, messageBody : String? = nil ) -> Email {
        switch recipient.status {
        case .new:
            return Email(
                subject: "已收到你的求职申请",
                messageBody: messageBody ?? "感谢你申请我们的职位，我们会在24小时内回复你。",
                recipientEmail: recipient.email,
                senderEmail: senderEmail)
        case .interview:
            return Email(
                subject: "面试邀请",
                messageBody: messageBody ?? "你的简历已经通过筛选，请于明天上午10点到我们公司面试。",
                recipientEmail: recipient.email,
                senderEmail: senderEmail)
        case .hired:
            return Email(
                subject: "你已通过面试",
                messageBody: messageBody ?? "恭喜你，你已经通过我们公司的面试，请于下周一到我们公司报道。",
                recipientEmail: recipient.email,
                senderEmail: senderEmail)
            
        case .rejected:
            return Email(
                subject: "面试未通过",
                messageBody: messageBody ?? "因不符合我公司的要求，此次面试不通过。谢谢！",
                recipientEmail: recipient.email,
                senderEmail: senderEmail)
        }
    }
    
}

