//
//  HeroViewModel.swift
//  RxSwiftDemo
//
//  Created by sunke on 2020/9/16.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
import RxSwift

class HeroViewModel {
    fileprivate lazy var bag : DisposeBag = DisposeBag()
    
    lazy var herosVariable : Variable<[Hero]> = {
        return Variable(self.getHeroData())
    }()
    
    var searchText : Observable<String>
    
    init(searchText : Observable<String>) {
        
        self.searchText = searchText
        
        self.searchText.subscribe(onNext: { (str : String) in
            let heros = self.getHeroData().filter({ (hero : Hero) -> Bool in
                if str == "" { return true }
                return hero.name.contains(str)
            })
            self.herosVariable.value = heros
        }).disposed(by: bag)
    }
    
    deinit {
        print("------")
    }
}

extension HeroViewModel {
    fileprivate func getHeroData() -> [Hero] {
        // 1.获取路径
        let path = Bundle.main.path(forResource: "heros.plist", ofType: nil)!
        
        // 2.读取文件内容
        let dictArray = NSArray(contentsOfFile: path) as! [[String : Any]]
//        let dictArray = Array(path)
        // 3.遍历所有的字典并且转成模型对象
        var heros = [Hero]()
        for dict in dictArray {
            heros.append(Hero(dict: dict))
        }
        
        return heros
    }
}
