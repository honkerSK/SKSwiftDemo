//
//  Result.swift
//  RxSwiftDemo
//
//  Created by sunke on 2020/9/15.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum Result {
    case success(message : String)
    case failure(message : String)
}

extension Result {
    var textColor : UIColor {
        switch self {
        case .success:
            return UIColor.black
        default:
            return UIColor.red
        }
    }
    
    var description : String {
        switch self {
        case let .success(message):
            return message
        case let .failure(message):
            return message
        }
    }
    
    var isValid : Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }
}


extension Reactive where Base : UILabel {
    var validationResult: UIBindingObserver<Base, Result> {
        return UIBindingObserver(UIElement: base) { label, result in
            label.textColor = result.textColor
            label.text = result.description
        }
    }
}

extension Reactive where Base : UITextField {
    var enableResult : UIBindingObserver<Base, Result> {
        return UIBindingObserver(UIElement: base, binding: { (textFiled, result) in
            textFiled.isEnabled = result.isValid
        })
    }
}
