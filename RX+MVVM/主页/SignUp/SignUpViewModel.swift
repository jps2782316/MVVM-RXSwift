//
//  SignUpViewModel.swift
//  RX+MVVM
//
//  Created by jps on 2018/11/27.
//  Copyright © 2018年 jps. All rights reserved.
//

import Foundation
import RxSwift

class SignUpViewModel {
    
    ///验证用户名后返回的结果
    let validatedUserName: Observable<ValidationResult>
    
    let validatedPassword: Observable<ValidationResult>
    
    let validatedPasswordRepeated: Observable<ValidationResult>
    
    ///注册按钮是否能点击
    let signupBtnEnabled: Observable<Bool>
    
    // Has user signed in
    let signedIn: Observable<Bool>
    
    // Is signing process in progress 是否正在转菊花中
    let signingIn: Observable<Bool>
    
    
    
    init(input: (
        username: Observable<String>,
        password: Observable<String>,
        repeatPassword: Observable<String>,
        loginTaps: Observable<Void>
        ),
        dependency: (
        API: GitHubAPI,
        validationService: GitHubValidationService,
        alertView: Wireframe
        )
         ) {
        
        let API = dependency.API
        let validationService = dependency.validationService
        let alertView = dependency.alertView
        
        
        validatedUserName = input.username.flatMapLatest { userName in
            return validationService.validateUserName(userName)
                .observeOn(MainScheduler.instance)
                .catchErrorJustReturn(.failed(message: "Error contacting server"))
        }.share(replay: 1)
        
        validatedPassword = input.password.map { password in
            return validationService.validatePassword(password)
        }.share(replay: 1)
        
        validatedPasswordRepeated = Observable
            .combineLatest(input.password,
                           input.repeatPassword,
                           resultSelector:validationService.validateRepeatedPassword)
            .share(replay: 1)
        
        let signingIn = ActivityIndicator()
        self.signingIn = signingIn.asObservable()
        
        let usernameAndPassword = Observable.combineLatest(input.username,
                                                           input.password) {
                                                            (username: $0, password: $1)
        }
        
        self.signedIn = input.loginTaps.withLatestFrom(usernameAndPassword).flatMapLatest { pair in
            return API.signup(pair.username, password: pair.password).observeOn(MainScheduler.instance).catchErrorJustReturn(false).trackActivity(signingIn)
            }.flatMapLatest { loggedIn -> Observable<Bool> in
                let message = loggedIn ? "Mock: Signed in to GitHub." : "Mock: Sign in to GitHub failed"
                return alertView.promptFor(message, cancelAction: "OK", actions: []).map { _ in
                    loggedIn
                }
        }.share(replay: 1)
        
        signupBtnEnabled = Observable.combineLatest(
            validatedUserName,
            validatedPassword,
            validatedPasswordRepeated,
            signingIn.asObservable()
        ) { userName, passwd, repeatPassword, signingIn in
            userName.isValid && passwd.isValid && repeatPassword.isValid && !signingIn
        }.distinctUntilChanged()
        .share(replay: 1)
        
        
    }
    
    
    
    
}
