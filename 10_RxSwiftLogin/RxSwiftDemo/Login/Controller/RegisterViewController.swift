//
//  RegisterViewController.swift
//  RxSwiftDemo
//
//  Created by sunke on 2020/9/15.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameHintLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordHintLabel: UILabel!
    @IBOutlet weak var passwordRepeatTextField: UITextField!
    @IBOutlet weak var passwordRepeatLabel: UILabel!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    fileprivate lazy var bag : DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.设置标题
        navigationItem.title = "注册"
        
        // 2.注册逻辑
        // 2.1.账号判断逻辑
        let registerVM = RegisterViewModel()
        /*
        usernameTextField.rx.text.subscribe(onNext: { (inputStr : String?) in
            // 1.判断字符串是否符合规则
            guard InputValidator.isValidEmail(inputStr!) else {
                self.usernameHintLabel.text = "账号必须是邮件格式"
                self.usernameHintLabel.textColor = UIColor.red
                self.passwordTextField.isEnabled = false
                return
            }
            
            // 2.符合规则
            self.usernameHintLabel.text = "账号可用"
            self.passwordTextField.isEnabled = true
            self.usernameHintLabel.textColor = UIColor.black
        }).addDisposableTo(bag)
        */
        
        usernameTextField.rx.text.orEmpty.bind(to: registerVM.username)
//            .bindTo(registerVM.username)
            .disposed(by: bag)
        
        registerVM.usernameObserable
            .bind(to: usernameHintLabel.rx.validationResult)
            .disposed(by: bag)
        
        registerVM.usernameObserable
            .bind(to: passwordTextField.rx.enableResult)
            .disposed(by: bag)
        
        
        // 2.2.密码判断逻辑
        passwordTextField.rx.text.orEmpty
            .bind(to: registerVM.password)
            .disposed(by: bag)
        
        registerVM.passwordObserable
            .bind(to: passwordHintLabel.rx.validationResult)
            .disposed(by: bag)
        registerVM.passwordObserable
            .bind(to: passwordRepeatTextField.rx.enableResult)
            .disposed(by: bag)
        
        // 2.3.判断重复密码逻辑
        passwordRepeatTextField.rx.text.orEmpty
            .bind(to: registerVM.repeatPassword)
            .disposed(by: bag)
        
        registerVM.repeatPwdObservable
            .bind(to: passwordRepeatLabel.rx.validationResult)
            .disposed(by: bag)
        
        // 2.4.处理点击事件
        registerVM.registerBtnObservable
            .bind(to: registerBtn.rx.isEnabled)
            .disposed(by: bag)
        
        
        // 3.监听注册按钮的点击
        registerBtn.rx.tap.subscribe(onNext: { (_) in
            _ = self.navigationController?.popViewController(animated: true)
        }).disposed(by: bag)
    }
}
