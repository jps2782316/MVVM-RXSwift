//
//  LoginViewController.swift
//  RX+MVVM
//
//  Created by jps on 2018/11/27.
//  Copyright © 2018年 jps. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {

    
    
    @IBOutlet weak var userNameTextView: UITextView!
    
    @IBOutlet weak var userNameDescLabel: UILabel!
    
    @IBOutlet weak var passwordTextView: UITextView!
    
    @IBOutlet weak var passwordDescLabel: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    
    let disposeBag = DisposeBag()
    
    
    private var vm: LoginViewModel!
    
    
    // ************************************
    // ViewController 主要负责数据绑定：
    // ************************************
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellow
        
        
        MVVMDemo()
        
    }
    
    
    
    
    
    ///2. 使用MVVM的代码结构
    func MVVMDemo() {
        //输入源传入vm
        vm = LoginViewModel(userName: userNameTextView.rx.text.orEmpty.asObservable(),
                            password: passwordTextView.rx.text.orEmpty.asObservable())
        
        //数据绑定
        vm.userNameValid.bind(to: passwordTextView.rx.isUserInteractionEnabled).disposed(by: disposeBag)
        
        vm.userNameValid.bind(to: userNameDescLabel.rx.isHidden).disposed(by: disposeBag)
        
        vm.passwordValid.bind(to: passwordDescLabel.rx.isHidden).disposed(by: disposeBag)
        
        vm.everythingValid.bind(to: loginBtn.rx.isEnabled).disposed(by: disposeBag)
        
        //点击事件
        loginBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.loginHandle()
        }).disposed(by: disposeBag)
    }
    
    
    
    ///1. 不使用MVVM时的代码结构
    func noMVVMDemo() {
        //1.
        
        // 用户名是否有效
        let usernameValid = userNameTextView.rx.text.orEmpty
            .map { $0.count >= 5 }
            .share(replay: 1)
        
        // 用户名是否有效 -> 密码输入框是否可用
        usernameValid
            .bind(to: passwordTextView.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
        
        // 用户名是否有效 -> 用户名提示语是否隐藏
        usernameValid
            .bind(to: userNameDescLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        //2.
        
        // 密码是否有效
        let passwordValid = passwordTextView.rx.text.orEmpty
            .map { $0.count >= 5 }
            .share(replay: 1)
        
        // 密码是否有效 -> 密码提示语是否隐藏
        passwordValid.bind(to: passwordDescLabel.rx.isHidden).disposed(by: disposeBag)
        
        
        //3.
        
        // 所有输入是否有效
        let everythingValid = Observable.combineLatest(
            usernameValid,
            passwordValid
        ) { $0 && $1 } // 取用户名和密码同时有效
            .share(replay: 1)
        
        // 所有输入是否有效 -> 绿色按钮是否可点击
        everythingValid.bind(to: loginBtn.rx.isEnabled).disposed(by: disposeBag)
        
        
        //4.
        // 点击绿色按钮 -> 处理登录逻辑
        loginBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.loginHandle()
        }).disposed(by: disposeBag)
    }
    
    

}



extension LoginViewController {
    
    func loginHandle() {
        print("请求登录接口")
    }
    
}







