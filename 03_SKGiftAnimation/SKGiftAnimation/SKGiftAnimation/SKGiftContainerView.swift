//
//  SKGiftContainerView.swift
//  SKGiftAnimation
//
//  Created by sunke on 2020/8/29.
//  Copyright © 2020 KentSun. All rights reserved.
//
//礼物动画视图容器
import UIKit

class SKGiftContainerView: UIView {

    fileprivate lazy var channelViews : [SKGiftChannelView] = [SKGiftChannelView]()
    fileprivate lazy var cacheGiftModels : [SKGiftModel] = [SKGiftModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

}


extension SKGiftContainerView {
    fileprivate func setupUI() {
        // 1.根据当前的渠道数，创建SKGiftChannelView
        let w : CGFloat = frame.width
        let h : CGFloat = 40
        let x : CGFloat = -w
        for i in 0..<2 {
            let y : CGFloat = (h + 10) * CGFloat(i)
            let channelView = SKGiftChannelView.loadChannelView()
            channelView.frame = CGRect(x: x, y: y, width: w, height: h)
            channelView.alpha = 0.0
            addSubview(channelView)
            channelViews.append(channelView)
            
            channelView.finishedCallback = {[unowned self] (channelView) in
                // 1.检查缓存中是否有内容
                guard self.cacheGiftModels.count != 0 else {
                    return
                }
                
                // 2.取出模型
                let firstGiftModel = self.cacheGiftModels.first!
                self.cacheGiftModels.removeFirst()
                
                // 3.取出和giftModel相同模型的个数
                var cacheNumber = 0
                for i in (0..<self.cacheGiftModels.count).reversed() {
                    if self.cacheGiftModels[i].isEqual(firstGiftModel) {
                        cacheNumber += 1
                        self.cacheGiftModels.remove(at: i)
                    }
                }
                
                // 4.让闲置的channelView执行缓存中礼物模型的动画
                channelView.cacheNumber = cacheNumber
                channelView.giftModel = firstGiftModel
            }
        }
    }
}


extension SKGiftContainerView {
    func insertGiftModel(_ giftModel : SKGiftModel) {
        // 1.判断是否有正在执行动画的渠道的模型和新插入的模型一致
        if let channelView = checkModelInChannerView(giftModel) {
            channelView.addOnceToCache()
            return
        }
        
        // 2.有没有闲置的channelView可以用于展示的礼物
        if let channelView = checkIdleChannelView() {
            channelView.giftModel = giftModel
            return
        }
        
        // 3.将模型添加到缓存中
        cacheGiftModels.append(giftModel)
    }
    
    fileprivate func checkModelInChannerView(_ newGiftModel : SKGiftModel) -> SKGiftChannelView? {
        // return channelViews.filter({ newGiftModel.isEqual($0.giftModel) }).first
        for channelView in channelViews {
            if newGiftModel.isEqual(channelView.giftModel) && channelView.state != .ending {
                return channelView
            }
        }
        return nil
    }
    
    fileprivate func checkIdleChannelView() -> SKGiftChannelView? {
        // return channelViews.filter({ $0.state == .idle }).first
        for channelView in channelViews {
            if channelView.state == .idle {
                return channelView
            }
        }
        return nil
    }
}

