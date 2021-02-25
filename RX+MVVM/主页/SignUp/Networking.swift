//
//  Networking.swift
//  RX+MVVM
//
//  Created by jps on 2018/11/28.
//  Copyright © 2018年 jps. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//协议
///验证 （都是一些规则验证，无网络请求）
protocol GitHubValidationService {
    ///验证用户名
    func validateUserName(_ username: String) -> Observable<ValidationResult>
    ///验证密码
    func validatePassword(_ password: String) -> ValidationResult
    ///验证二次密码
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult
}

//类
class GithubDefaultValidationService: GitHubValidationService {
    
    let apiDelegate: GitHubAPI = GitHubDefaultAPI.shared
    
    static let shared = GithubDefaultValidationService()
    
    let minPwdLength = 5
    
    
    func validateUserName(_ username: String) -> Observable<ValidationResult> {
        if username.isEmpty {
            return .just(.empty)
        }
        
        //只能输入数字和字母  (alphanumerics 字母数字)
        let range = username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted)
        
        if range != nil {
            //print(range!)
            return .just(.failed(message: "Username can only contain numbers or digits"))
        }
        
        
        
        let laodingValue = ValidationResult.validating
        
        return apiDelegate.usernameAvailable(username).map { available in
            if available {
                return .ok(message: "Username available")
            }else {
                return .failed(message: "Username already exists")
            }
        }.startWith(laodingValue)
    }
    
    
    
    func validatePassword(_ password: String) -> ValidationResult {
        let pwdCount = password.count
        if pwdCount == 0 {
            return .empty
        }
        if pwdCount < minPwdLength {
            return .failed(message: "Password must be at least \(minPwdLength) characters")
        }
        
        return .ok(message: "Password acceptable")
    }
    
    
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        if repeatedPassword.count == 0 {
            return .empty
        }
        if repeatedPassword == password {
            return .ok(message: "Password repeated")
        }
        else {
            return .failed(message: "Password different")
        }
    }
    
    
}

// ===========================
//        let set = CharacterSet.alphanumerics
//        //// 取反，除去 字母数字外的所有字符
//        let inver = set.inverted
// ===========================








//================= networking ================

//协议
protocol GitHubAPI {
    ///用户名是否有效
    func usernameAvailable(_ userName: String) -> Observable<Bool>
    ///注册
    func signup(_ userName: String, password: String) -> Observable<Bool>
}

//类
class GitHubDefaultAPI: GitHubAPI {
    
    let urlSession: URLSession
    
    static let shared = GitHubDefaultAPI(urlSession: URLSession.shared)
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    
    func usernameAvailable(_ userName: String) -> Observable<Bool> {
        let url = URL(string: "https://github.com/\(userName.URLEscaped)")!
        let request = URLRequest(url: url)
        
        return self.urlSession.rx.response(request: request).map { pair in
            return pair.response.statusCode == 404
        }.catchErrorJustReturn(false)
    }
    
    
    func signup(_ userName: String, password: String) -> Observable<Bool> {
        let signupResult = arc4random() % 5 == 0 ? false : true
        
        return Observable.just(signupResult).delay(1.0, scheduler: MainScheduler.instance)
    }
    
    
    
}
