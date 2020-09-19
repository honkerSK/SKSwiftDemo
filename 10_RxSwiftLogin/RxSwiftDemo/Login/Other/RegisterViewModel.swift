//
//  RegisterViewModel.swift
//  RxSwiftDemo
//
//  Created by sunke on 2020/9/15.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewModel {
//    var username = Variable("")
//    var password = Variable("")
//    var repeatPassword = Variable("")
    
    var username = BehaviorRelay(value:"")
    var password = BehaviorRelay(value:"")
    var repeatPassword = BehaviorRelay(value:"")
    
    var usernameObserable : Observable<Result>
    var passwordObserable : Observable<Result>
    var repeatPwdObservable : Observable<Result>
    var registerBtnObservable : Observable<Bool>
    
    init() {
        usernameObserable = username.asObservable().map({ (password) -> Result in
            return InputValidator.validateUsername(password)
        })
        
        passwordObserable = password.asObservable().map({ (inputStr) -> Result in
            return InputValidator.validatePassword(inputStr)
        })
        
        repeatPwdObservable = Observable.combineLatest(password.asObservable(), repeatPassword.asObservable(), resultSelector: { (password, repeatPassword) -> Result in
            return InputValidator.validateRepeatPassword(password, repeatPassword)
        })
        
        registerBtnObservable = Observable.combineLatest(passwordObserable, repeatPwdObservable, usernameObserable, resultSelector: { (username, password, repeatPassword) -> Bool in
            return username.isValid && password.isValid && repeatPassword.isValid
        })
    }
}
