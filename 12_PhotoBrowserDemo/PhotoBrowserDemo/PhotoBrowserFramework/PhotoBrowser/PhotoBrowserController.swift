//
//  PhotoBrowserController.swift
//  PhotoBrowserDemo
//
//  Created by sunke on 2020/9/17.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
import SVProgressHUD
import Kingfisher

private let PhotoCellID = "PhotoCellID"

// 图片间距
private let PicMargin : CGFloat = 20

class PhotoBrowserController: UIViewController {
    
    // MARK:- 属性
    private var shops : [Shop]
    private var currentIndexPath : NSIndexPath
    
    // MARK:- 懒加载子控件
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: PhotoCollectionViewLayout())
    private lazy var closeBtn : UIButton = UIButton(title: "关闭", bgColor: UIColor.darkGray, fontSize: 14)
    private lazy var saveBtn : UIButton = UIButton(title: "保存", bgColor: UIColor.darkGray, fontSize: 14)
    
    
    // MARK:- 构造函数
    init(shops : [Shop], currentIndexPath : NSIndexPath) {
        self.shops = shops
        self.currentIndexPath = currentIndexPath
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view.frame.size.width += PicMargin
    }
    
    // MARK:- 系统的回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.设置子控件
        setupUI()
        
        // 2.滚到指定位置
        collectionView.scrollToItem(at: currentIndexPath as IndexPath, at: .centeredHorizontally, animated: false)
    }
}

// 设置子控件
extension PhotoBrowserController {
    /// 设置子控件
    private func setupUI() {
        // 1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        // 2.布局子控件
        let btnHMargin : CGFloat = 20
        let btnVMargin : CGFloat = 10
        let btnW : CGFloat = 100
        let btnH : CGFloat = 32
        closeBtn.frame = CGRect(x: btnHMargin, y: view.bounds.height - btnH - btnVMargin, width: btnW, height: btnH)
        saveBtn.frame = CGRect(x: view.bounds.width - PicMargin - btnW - btnHMargin, y: view.bounds.height - btnVMargin - btnH, width: btnW, height: btnH)
        collectionView.frame = view.bounds
        
        
        // 3.监听按钮的点击
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)

        // 4.准备collectionView的属性
        collectionView.dataSource = self
        collectionView.register(PhotoBrowserCell.self, forCellWithReuseIdentifier: PhotoCellID)
    }
    
    @objc private func closeBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveBtnClick() {
        // 1.获取cell
        guard let cell = collectionView.visibleCells[0] as? PhotoBrowserCell else {
            return
        }
        
        // 2.取出cell中的图片进行保存
        guard let image = cell.imageView.image else {
            return
        }
        
        // 3.将图片写入相册
//        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image:didFinishSavingWithError:contextInfo:), nil)
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    @objc func image(image : UIImage, didFinishSavingWithError error : NSError?, contextInfo context : AnyObject) {
        // 1.判断是否有错误
        let message = error == nil ? "保存成功" : "保存失败"
        
        // 2.显示保存结果
        SVProgressHUD.showInfo(withStatus: message, maskType: .none)
    }
}

// MARK:- UICollectionViewDataSource
extension PhotoBrowserController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCellID, for: indexPath) as! PhotoBrowserCell
        
        // 2.给cell设置数据
        let urlStr = shops[indexPath.item].download_url ?? ""
        let imageURL = URL(string: urlStr)
        
        cell.imageURL = imageURL
        cell.delegate = self
        
        // 3.自动下载下一张图片
        downloadNextImage(index: indexPath.item + 1)
        
        // 4.返回cell
        return cell
    }
    
    
    private func downloadNextImage(index : Int) {
        // 1.判断是否有下一张图片
        if index > shops.count - 1 {
            return
        }
        
        // 2.下载图片
//        let url = shops[index].picURL!
        //下载图片，又管理图片
//        SDWebImageManager.sharedManager().downloadImageWithURL(url, options: .RetryFailed, progress: nil) { (_, _, _, _, _) -> Void in
//
//        }
        let url = URL(string: shops[index].download_url ?? "")
        KingfisherManager.shared.retrieveImage(with: url!) { (result) in
            
        }
        
    }
}


// MARK:- 内部点击
extension PhotoBrowserController : PhotoBrowserCellDelegate {
    func photoBrowserCellImageClick() {
        closeBtnClick()
    }
}


extension PhotoBrowserController : PhotoBrowserDismissDelegate {
    func imageViewForDismiss() -> UIImageView {
        // 1.创建UIImageView对象
        let tempImageView = UIImageView()
        
        // 2.设置属性
        tempImageView.contentMode = .scaleAspectFill
        tempImageView.clipsToBounds = true
        
        // 3.设置图片
        let cell = collectionView.visibleCells[0] as! PhotoBrowserCell
        tempImageView.image = cell.imageView.image
//        tempImageView.frame = cell.scrollView.convertRect(cell.imageView.frame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
        tempImageView.frame = cell.scrollView.convert(cell.imageView.frame, to: UIApplication.shared.keyWindow!)
        
        return tempImageView
    }
    
    func indexPathForDismiss() -> NSIndexPath {
        return collectionView.indexPathsForVisibleItems[0] as NSIndexPath
    }
}


class PhotoCollectionViewLayout : UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        // 1.布局属性设置
        itemSize = collectionView!.bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .horizontal
        
        // 2.设置collectionView的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
    }
}

