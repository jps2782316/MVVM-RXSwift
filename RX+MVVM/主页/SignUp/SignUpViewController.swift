//
//  SignUpViewController.swift
//  RX+MVVM
//
//  Created by jps on 2018/11/27.
//  Copyright © 2018年 jps. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userNameDescLabel: UILabel!
    
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordDescLabel: UILabel!
    
    @IBOutlet weak var repeatPwdField: UITextField!
    @IBOutlet weak var repeatPwdDescLabel: UILabel!
    
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()
    
    var vm: SignUpViewModel!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        vm = SignUpViewModel(input: (username: userNameField.rx.text.orEmpty.asObservable(),
                                     password: passwordField.rx.text.orEmpty.asObservable(),
                                     repeatPassword: repeatPwdField.rx.text.orEmpty.asObservable(),
                                     loginTaps: signupBtn.rx.tap.asObservable()),
                             dependency: (API: GitHubDefaultAPI.shared,
                                          validationService: GithubDefaultValidationService.shared,
                                          alertView: DefaultWireframe.shared))
        
        //绑定结果
        vm.signupBtnEnabled.subscribe(onNext: {[weak self] valid in
            self?.signupBtn.isEnabled = valid
            self?.signupBtn.alpha = valid ? 1 : 0.5
        }).disposed(by: disposeBag)
        
        vm.validatedUserName.bind(to: userNameDescLabel.rx.validationResult).disposed(by: disposeBag)
        
        vm.validatedPassword.bind(to: passwordDescLabel.rx.validationResult).disposed(by: disposeBag)
        
        vm.validatedPasswordRepeated.bind(to: repeatPwdDescLabel.rx.validationResult).disposed(by: disposeBag)
        
        vm.signingIn.bind(to: activityIndicator.rx.isAnimating).disposed(by: disposeBag)
        
        vm.signedIn.subscribe(onNext: { signedIn in
            print("User signed in \(signedIn)")
        }).disposed(by: disposeBag)
        
        
        let tap = UITapGestureRecognizer()
        tap.rx.event.subscribe(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tap)
        
        
    }
    

    

}
