//
//  ViewController.swift
//  SKGiftAnimation
//
//  Created by sunke on 2020/8/29.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var demoLabel: SKDigitLabel!
    fileprivate var containerView : SKGiftContainerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let containerFrame = CGRect(x: 0, y: 100, width: 320, height: 90)
        let containerView = SKGiftContainerView(frame: containerFrame)
        view.addSubview(containerView)
        self.containerView = containerView
    }
    
    @IBAction func gift1Click(_ sender: Any) {
        let giftModel = SKGiftModel(senderName: "codeTao", senderIcon: "icon4", giftIcon: "prop_g", giftName: "蘑菇")
               containerView.insertGiftModel(giftModel)
    }
    
    
    @IBAction func gift2Click(_ sender: Any) {
        let giftModel = SKGiftModel(senderName: "张三", senderIcon: "icon3", giftIcon: "prop_f", giftName: "啤酒")
        containerView.insertGiftModel(giftModel)
    }
    
    @IBAction func gift3Click(_ sender: Any) {
        let giftModel = SKGiftModel(senderName: "李四", senderIcon: "icon2", giftIcon: "prop_b", giftName: "跑车")
               containerView.insertGiftModel(giftModel)
    }
    
    @IBAction func gift4Click(_ sender: Any) {
        let giftModel = SKGiftModel(senderName: "王五", senderIcon: "icon1", giftIcon: "prop_h", giftName: "红包")
        containerView.insertGiftModel(giftModel)
    }
    
    
}

