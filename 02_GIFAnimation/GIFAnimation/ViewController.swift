//
//  ViewController.swift
//  GIFAnimation
//
//  Created by sunke on 2020/8/28.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
//import ImageViewExtension

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func gifFinishAction(_ sender: Any) {
        let gifFinishVC = GifFinishVC()
        
        self.navigationController?.pushViewController(gifFinishVC, animated: true)
    }
    
    
    
    
}

