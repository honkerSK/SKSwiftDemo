//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by sunke on 2020/9/13.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let loginVc = LoginViewController()
        let loginNav = UINavigationController(rootViewController: loginVc)
        loginNav.modalPresentationStyle = .fullScreen
        
//        let topVC = topMostController()
//        topVC.present(loginNav, animated: true, completion: nil)
        
        present(loginNav, animated: true, completion: nil)
        
    }

    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!

        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!

        }
        return topController

    }
    
}






