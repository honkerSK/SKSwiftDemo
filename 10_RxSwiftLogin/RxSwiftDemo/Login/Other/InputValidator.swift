//
//  InputValidator.swift
//  RxSwiftDemo
//
//  Created by sunke on 2020/9/15.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
import RxSwift

class InputValidator {
    
}

extension InputValidator {
    class func isValidEmail(_ email : String) -> Bool {
        let re = try? NSRegularExpression(
            pattern: "^\\S+@\\S+\\.\\S+$",
            options: [])
        
        if let re = re {
            let range = NSMakeRange(0, email.lengthOfBytes(using: .utf8))
            let result = re.matches(in: email, options: [], range: range)
            return result.count > 0
        }
        
        return false
    }
    
    class func isValidPassword(_ password : String) -> Bool {
//        return password.characters.count >= 8
        return password.count >= 8
    }
    
    class func validateUsername(_ username : String) -> Result {
        // 1.判断字符数是否正确
        if username.count < 6 {
            return Result.failure(message: "输入内容不能少于6个字符")
        }
        
        // 2.账号可用
        return Result.success(message: "账号可用")
    }
    
    class func validatePassword(_ password : String) -> Result {
        if password.count < 8 {
            return Result.failure(message: "输入密码不能少于6个字符")
        }
        
        return Result.success(message: "密码可用")
    }
    
    class func validateRepeatPassword(_ password : String, _ repeatPassword : String) -> Result {
        if password == repeatPassword {
            return Result.success(message: "账号&密码一致")
        }
        
        return Result.failure(message: "账号&密码不一致")
    }
}
