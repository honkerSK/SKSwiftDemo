//
//  GifFinishVC.swift
//  GIFAnimation
//
//  Created by sunke on 2020/8/28.
//  Copyright © 2020 KentSun. All rights reserved.
//
// 监听gif起始播放
import UIKit

class GifFinishVC: UIViewController , CAAnimationDelegate{
    
    var launchImageView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let screenWidth = UIScreen.main.bounds.size.width
//        let screenHeight = UIScreen.main.bounds.size.height
//        let mainWindow = UIApplication.shared.keyWindow!

        let launchImageViewW:CGFloat = 370.0
        let launchImageViewH:CGFloat = 200.0
        let launchImageViewX: CGFloat = (screenWidth - launchImageViewW) * 0.5
        let launchImageViewY: CGFloat = 200
        let launchImageView = UIImageView(frame: CGRect(x: launchImageViewX, y: launchImageViewY, width: launchImageViewW, height: launchImageViewH))
        view.addSubview(launchImageView)
        self.launchImageView = launchImageView
        launchImageView.contentMode = .scaleAspectFill
        
       
        //动画数组
        guard let imageArrTime = UIImageView.getImgArrAndDurationFromGif(resourceName: "NARUTO.gif") else{ return }
        guard let imageArr = imageArrTime.0 else {
            return
        }
        var cgimageArr = [CGImage]()
        for  image in imageArr {
            cgimageArr.append(image.cgImage!)
        }
        
        //关键帧动画
        let animation : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "contents")
        animation.delegate = self
        animation.duration = imageArrTime.1 //播放时间
        animation.calculationMode = .cubic //平滑执行
        animation.values = cgimageArr
        launchImageView.layer.add(animation, forKey: nil)
    }
    
}

//MARK:- CAAnimationDelegate
extension GifFinishVC{

    func animationDidStart(_ anim: CAAnimation) {
        print("gif图开始播放")
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("gif图结束播放")
        
        //清理内存
        launchImageView?.layer.removeAllAnimations()
    }
}
