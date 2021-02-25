//
//  LoginViewModel.swift
//  RX+MVVM
//
//  Created by jps on 2018/11/27.
//  Copyright © 2018年 jps. All rights reserved.
//

import Foundation
import RxSwift


// ************************************
// ViewModel 将用户输入行为，转换成输出的状态：
// ************************************



class LoginViewModel {
    
    //输出
    let userNameValid: Observable<Bool>
    let passwordValid: Observable<Bool>
    let everythingValid: Observable<Bool>
    
    
    //输入 -> 输出
    init(userName: Observable<String>, password: Observable<String>) {
        
        userNameValid = userName.map { $0.count >= 5 }.share(replay: 1)
        
        passwordValid = password.map { $0.count >= 5 }.share(replay: 1)
        
        everythingValid = Observable.combineLatest(userNameValid, passwordValid) { $0 && $1 }.share(replay: 1)
        
    }
    
    
    
    
    
}
