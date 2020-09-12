//
//  ViewController.swift
//  SKWaterfallLayout
//
//  Created by sunke on 2020/8/23.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

private let kCellID = "kCellID"

class ViewController: UIViewController {
    
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = SKWaterfallLayout()
        
        layout.minimumLineSpacing = 10  //行间距
        layout.minimumInteritemSpacing = 10 //列间距
        //内边距
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        //layout.cols = 3
        //数据源
        layout.dataSource = self
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellID)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
    }
}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath)
        
        cell.backgroundColor = UIColor.randomColor
        
        return cell
    }
}

extension ViewController : SKWaterfallLayoutDataSource {
    func waterfallLayout(_ layout: SKWaterfallLayout, indexPath: IndexPath) -> CGFloat {
        // return CGFloat(arc4random_uniform(160) + 80)
        return indexPath.item % 2 == 0 ? 250 : 180
    }
    
    func waterfallLayout(_ layout: SKWaterfallLayout) -> Int {
        return 4
    }
}

