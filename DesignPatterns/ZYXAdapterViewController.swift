//
//  ZYXAdapterViewController.swift
//  DesignPatterns
//
//  Created by PengXiang on 2018/7/6.
//  Copyright © 2018年 PengXiang. All rights reserved.
//

import UIKit

class ZYXAdapterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //新的协议在适配器模式中是必须的，保证adapter在我们的应用中能正常使用。如果第三方的代码改变，我们更新adapter中的代码即可。
        let authService = WeiboAuthenticatorAdapter()
        authService.login(email: "test@example.com", password: "password", success: { (user, token) in
             print("登录成功： 1) 邮件：\(user.email), 2）token: \(token.value)")
        }) { (error) in
            print("登录失败：\(error?.localizedDescription ?? "")")
        }
    }
}
//假设下面的api来自第三方库，不能直接被修改
public struct WeiboUser {
    public let username: String
    public let email: String
    public let token: String
}

public final class WeiboAuthenticator {
    public func login(email: String,password: String,completion: (WeiboUser?, Error?) -> Void) {
        let token = "a_token_value"
        let username = "a_user_name"
        let user = WeiboUser(username: username,email: email,token: token)
        completion(user, nil)
    }
}
//为了统一第三方登录的api，我们需要一个新的协议AuthenticationServiceable
struct User2 {
    let email: String
    let password: String
}

struct Token {
    let value: String
}

protocol AuthenticationServiceable {
    func login(email: String,password: String,success: (User2, Token) -> Void,failure: (Error?) -> Void)
}
//创建适配器
final class WeiboAuthenticatorAdapter: AuthenticationServiceable {
    private lazy var authenticator = WeiboAuthenticator()
    func login(email: String,password: String,success: (User2, Token) -> Void,failure: (Error?) -> Void) {
        authenticator.login(email: email, password: password) { (weiboUser, error) in
            guard let weiboUser = weiboUser else {
                failure(error)
                return
            }
            let user = User2(email: weiboUser.email, password: weiboUser.username)
            let token = Token(value: weiboUser.token)
            success(user, token)
        }
    }
}
