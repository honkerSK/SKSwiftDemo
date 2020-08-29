//
//  ImageViewExtension.swift
//  GIFAnimation
//
//  Created by sunke on 2020/8/28.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit



extension UIImageView {
    
    //加载gif图
    static func fromGif(frame: CGRect, resourceName: String) -> UIImageView? {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else {
            print("Gif does not exist at that path")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        let gifImageView = UIImageView(frame: frame)
        gifImageView.animationImages = images
        return gifImageView
    }
    
    
    
    /// 解析gif图
    /// - Parameter resourceName: git名称
    /// - Returns: [UIImage]?
    static func getImgArrFromGif(resourceName: String) -> [UIImage]? {
        //1.获取图片的路径
        guard let path = Bundle.main.path(forResource: resourceName, ofType: nil) else {
            print("Gif does not exist at that path")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        //2.根据路径, 将gif图转成Data类型
        //3.根据gifData创建CGImageSource
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        
        //4.获取imageSource中的图片的个数
        let imageCount = CGImageSourceGetCount(source)
        //5.获取一张张的图片
        var images = [UIImage]()
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        return images
    }
    
    /// 解析gif图
    /// - Parameter resourceName: git名称
    /// - Returns: [UIImage]? 图片数组和动画时间
    static func getImgArrAndDurationFromGif(resourceName: String) -> ([UIImage]?, TimeInterval)? {
        //1.获取图片的路径
        guard let filePath = Bundle.main.path(forResource: resourceName, ofType: nil) else {
            print("Gif does not exist at that path")
            return nil
        }
        let url = URL(fileURLWithPath: filePath)
        //2.根据路径, 将gif图转成Data类型
        guard let gifData = try? Data(contentsOf: url) else { return nil }
        //3.根据gifData创建CGImageSource
        guard let imageSource =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        //4.获取imageSource中的图片的个数
        let imageCount = CGImageSourceGetCount(imageSource)
        //5.获取一张张的图片
        var images = [UIImage]()
        var duration : TimeInterval = 0
        for i in 0 ..< imageCount {
            //5.1.获取图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else {
                continue
            }
            images.append(UIImage(cgImage: cgImage))
            // 5.2.获取每一帧的时间
            guard let imageDict = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? [String : Any] else {
                continue
            }
            guard let gifDict = imageDict[kCGImagePropertyGIFDictionary as String] as? [String : Any] else {
                continue
            }
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime as String] as? NSNumber else {
                continue
            }
            duration += frameDuration.doubleValue
            
        }
        return (images, duration)
    }
    
    
}
