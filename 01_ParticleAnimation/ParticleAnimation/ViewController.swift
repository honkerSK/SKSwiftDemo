//
//  ViewController.swift
//  ParticleAnimation
//
//  Created by sunke on 2020/8/28.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1.创建发射器
        let emitterLayer = CAEmitterLayer()
        
        // 2.设置发射器的位置
        emitterLayer.emitterPosition = CGPoint(x: view.bounds.width * 0.5, y: 100)
        
        // 3.设置粒子
        var cells = [CAEmitterCell]()
        for i in 0..<10 {
            // 3.1.创建粒子
            let cell = CAEmitterCell()
            
            // 3.2.设置发射的速率
            cell.birthRate = 5
            
            // 3.3.设置发射的方向
            cell.emissionLongitude = CGFloat(M_PI/2)
            cell.emissionRange = CGFloat(M_PI/6)
            
            // 3.4.粒子的速率
            cell.velocity = 80 // 40~120
            cell.velocityRange = 40
            
            // 3.5.生存时间
            cell.lifetime = 8 // 6~14
            cell.lifetimeRange = 3
            
            // 3.6.设置粒子缩放
            cell.scale = 0.6 // 0.3 ~ 0.9
            cell.scaleRange = 0.3
            
            cell.spin = 2
            cell.spinRange = 1
            
            // 3.7.设置粒子的内容
            cell.contents = UIImage(named: "good\(i)_30x30")?.cgImage
            
            cells.append(cell)
        }
        
        
        // 3.8.将cell设置到发射器中
        emitterLayer.emitterCells = cells
        
        // 4.将layer添加到父layer中
        view.layer.addSublayer(emitterLayer)
    }


}

