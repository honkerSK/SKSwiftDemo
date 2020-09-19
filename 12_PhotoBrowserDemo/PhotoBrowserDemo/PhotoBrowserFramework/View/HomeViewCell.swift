//
//  HomeViewCell.swift
//  PhotoBrowserDemo
//
//  Created by sunke on 2020/9/17.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewCell: UICollectionViewCell {
    // 模型属性
    var shop : Shop? {
        didSet {
           
            let urlStr = shop?.download_url ?? ""
            let url = URL(string: urlStr)
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "empty_picture")!)

            
        }
    }
    
    // 控件属性
    @IBOutlet weak var imageView: UIImageView!
}
