//
//  SKWaterfallLayout.swift
//  SKWaterfallLayout
//
//  Created by sunke on 2020/8/23.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

@objc protocol SKWaterfallLayoutDataSource : class {
    /// 每个cell高度
    func waterfallLayout(_ layout : SKWaterfallLayout, indexPath : IndexPath) -> CGFloat
    /// 有多少列
    @objc optional func waterfallLayout(_ layout : SKWaterfallLayout) -> Int
}

class SKWaterfallLayout: UICollectionViewFlowLayout {
    fileprivate lazy var cols : Int = self.dataSource?.waterfallLayout?(self) ?? 2
       weak var dataSource : SKWaterfallLayoutDataSource?
       
       fileprivate lazy var cellAttrs : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
       fileprivate lazy var colHeights : [CGFloat] = Array(repeating: self.sectionInset.top, count: self.cols)
}

// MARK:- 准备好所有的布局
extension SKWaterfallLayout{
    override func prepare() {
        super.prepare()
        
        // UICollectionViewLayoutAttributes
        
        // 1.校验collectionView是否有值
        guard let collectionView = collectionView else {
            return
        }
        
        // 2.获取cell的个数
        let count = collectionView.numberOfItems(inSection: 0)
        
        // 3.遍历出所有的cell, 并且计算frame
        let itemW = (collectionView.bounds.width - sectionInset.left - sectionInset.right - (CGFloat(cols) - 1) * minimumInteritemSpacing) / CGFloat(cols)
        
        for i in 0..<count {
            // 3.1.创建UICollectionViewLayoutAttributes
            let indexPath = IndexPath(item: i, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // 3.2.计算高度
            let itemH = dataSource?.waterfallLayout(self, indexPath: indexPath) ?? 0
            /*
            if let dataSource = dataSource {
            } else {
                fatalError("请给SKWaterfallLayout设置数据源")
            }
            */
            
            // 3.3.计算x值
            let minH = colHeights.min()!
            let minIndex = colHeights.firstIndex(of: minH)!
            let itemX = sectionInset.left + CGFloat(minIndex) * (itemW + minimumInteritemSpacing)
            
            // 3.4.计算y值
            let itemY = minH
            
            // 3.5.设置frame
            attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
            
            // 3.6.给minIndex赋值新的高度
            colHeights[minIndex] = attr.frame.maxY + minimumLineSpacing
            
            // 3.7.将的attr添加到cellAttrs中
            cellAttrs.append(attr)
        }
    }
    
    
}

// MARK:- 返回准备好的布局
extension SKWaterfallLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
}


// MARK:- 设置可滚动区域
extension SKWaterfallLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: colHeights.max()! + sectionInset.bottom - minimumLineSpacing)
    }
}

