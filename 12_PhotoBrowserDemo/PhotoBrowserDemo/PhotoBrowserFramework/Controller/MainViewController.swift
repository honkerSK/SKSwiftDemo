//
//  MainViewController.swift
//  PhotoBrowserDemo
//
//  Created by sunke on 2020/9/17.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
import Kingfisher

class MainViewController: UICollectionViewController {
    // MARK:- 属性
    var shops : [Shop] = [Shop]()
    var pageIndex = 0
    private lazy var photoBrowserAnimator = PhotoBrowserAnimator()
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载数据
        loadData(page: pageIndex, offset: 0)
    }
}


// MARK:- 弹出照片浏览器
extension MainViewController {
    private func presentPhotoBrowser(indexPath : NSIndexPath) {
        // 1.创建图片浏览器
        let photoBrowserVc = PhotoBrowserController(shops: shops, currentIndexPath: indexPath)
        
        // 2.设置弹出样式为自定义
        photoBrowserVc.modalPresentationStyle = .custom
        
        // 3.设置photoBrowserVc的转场代理
        photoBrowserVc.transitioningDelegate = photoBrowserAnimator
        
        // 4.设置photoBrowserAnimator的相关属性
        photoBrowserAnimator.setProperty(indexPath: indexPath, presentedDelegate: self, dismissDelegate: photoBrowserVc)
        
        // 弹出图片浏览器
        present(photoBrowserVc, animated: true, completion: nil)
    }
}


// MARK:- 用于提供动画的内容
extension MainViewController : PhotoBrowserPresentedDelegate {
    func imageForPresent(indexPath: NSIndexPath) -> UIImageView {
        // 1.创建用于做动画的UIImageView
        let imageView = UIImageView()
        
        // 2.设置imageView属性
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        // 3.设置图片
        let urlStr = shops[indexPath.item].download_url ?? ""
        guard let url = URL(string: urlStr) else {
            return UIImageView()
        }
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "empty_picture") )
        
        return imageView
    }
    
    func startRectForPresent(indexPath: NSIndexPath) -> CGRect {
        // 1.取出cell
        guard let cell = collectionView!.cellForItem(at: indexPath as IndexPath) else {
            return CGRect(x: collectionView!.bounds.width * 0.5, y: UIScreen.main.bounds.height + 50, width: 0, height: 0)
        }
        
        // 2.计算转化为UIWindow上时的frame
        //        let startRect = collectionView!.convertRect(cell.frame, toCoordinateSpace: UIApplication.sharedApplication.keyWindow!)
        let startRect = collectionView.convert(cell.frame, to: UIApplication.shared.keyWindow!)
        
        return startRect
    }
    
    func endRectForPresent(indexPath: NSIndexPath) -> CGRect {
        // 1.获取indexPath对应的URL
        let urlStr = shops[indexPath.item].download_url ?? ""
//        let url = shops[indexPath.item].picURL!
        guard let url = URL(string: urlStr) else {
            return .zero
        }
        
        // 2.取出对应的image
        //         var image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(url.absoluteString)

        var image : UIImage?
        ImageCache.default.retrieveImage(forKey: url.absoluteString) { (result) in
            switch result {
            case .success(let value):
                //print(value.cacheType)
                // If the `cacheType is `.none`, `image` will be `nil`.
                if value.cacheType == .none {
                    image = UIImage(named: "empty_picture")
                }else{
                    image = value.image
                }
            case .failure(let error):
                print(error)
            }
            
        }
        
        guard let newImage = image else { return CGRect.zero }
        // 3.根据image计算位置
        let screenW = UIScreen.main.bounds.width
        let screenH = UIScreen.main.bounds.height
        let imageH = screenW / newImage.size.width * newImage.size.height
        var y : CGFloat = 0
        if imageH < screenH {
            y = (screenH - imageH) * 0.5
        } else {
            y = 0
        }
        return CGRect(x: 0, y: y, width: screenW, height: imageH)
        
        
    }
}

// MARK:- collectionView的数据源和代理
extension MainViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shops.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCellID", for: indexPath) as! HomeViewCell
        
        // 2.给cell设置数据
        cell.shop = shops[indexPath.item]
        
        if indexPath.item == shops.count - 1 {
            pageIndex += 1
            loadData(page: pageIndex, offset: shops.count)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentPhotoBrowser(indexPath: indexPath as NSIndexPath)
        
    }
    
}


// MARK:- 请求网络数据
extension MainViewController {
    func loadData(page : Int, offset : Int) {
        NetworksTool.shareInstance.loadData(page: page, offset: offset) { (results, error) -> () in
            // 1.错误校验
            if error != nil {
                print(error)
                return
            }
            
            // 2.获取数据
            var tempShops = [Shop]()
            for shopDict in results! {
                let shop = Shop(dict: shopDict)
                //shop.picURL = URL(string: shop.download_url ?? "")
                tempShops.append(shop)
            }
            self.shops += tempShops
            // 3.刷新表格
            self.collectionView?.reloadData()
        }
    }
}
