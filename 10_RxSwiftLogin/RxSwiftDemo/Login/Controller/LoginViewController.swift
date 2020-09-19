//
//  LoginViewController.swift
//  RxSwiftDemo
//
//  Created by sunke on 2020/9/15.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    fileprivate lazy var bag : DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.设置导航栏
        setupNavigationBar()
        
        // 2.监听账号密码输入是否正确
        setupInputView()
        
        // 3.设置登录按钮的状态
        setupLoginButton()
    }
    
}

extension LoginViewController {
    fileprivate func setupNavigationBar() {
        navigationItem.title = "登录"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", style: .plain, target: self, action: #selector(exitItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(registerItemClick))
    }
    
    @objc fileprivate func exitItemClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func registerItemClick() {
        let registerVc = RegisterViewController()
        navigationController?.pushViewController(registerVc, animated: true)
    }
    
    fileprivate func setupInputView() {
        usernameTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderWidth = 1.0
        usernameTextField.layer.cornerRadius = 5.0
        usernameTextField.layer.masksToBounds = true
        
        
        let usernameObservable = usernameTextField.rx.text
            .map({ InputValidator.isValidEmail($0!) })
        usernameObservable.map({ $0 ? UIColor.green : UIColor.clear })
            .subscribe(onNext: { self.usernameTextField.layer.borderColor = $0.cgColor })
            .disposed(by: bag)
        
        let passwordObservable = passwordTextField.rx.text
                .map({ InputValidator.isValidPassword($0!) })
        passwordObservable.map({ $0 ? UIColor.green : UIColor.clear })
            .subscribe(onNext: { self.passwordTextField.layer.borderColor = $0.cgColor })
            .disposed(by: bag)
        
        
        Observable.combineLatest(usernameObservable, passwordObservable, resultSelector: { (vaildUsername, vaildPasword) -> Bool in
            return vaildPasword && vaildUsername
        }).subscribe(onNext: { (isEnable) in
            self.loginBtn.isEnabled = isEnable
        }).disposed(by: bag)
    }
    
    
    fileprivate func setupLoginButton() {
        
        return
    }
}
