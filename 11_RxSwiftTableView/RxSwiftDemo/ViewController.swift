//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by sunke on 2020/9/13.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    fileprivate lazy var bag : DisposeBag = DisposeBag()

    fileprivate var heros : [Hero] = [Hero]()
    fileprivate lazy var heroVM : HeroViewModel = HeroViewModel(searchText: self.searchText)
    var searchText : Observable<String> {
        return searchBar.rx.text.orEmpty.throttle(0.5, scheduler: MainScheduler.instance)
        //return searchBar.rx_t
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.取出调整底部内边距
        automaticallyAdjustsScrollViewInsets = false
        
        // 2.给tableView绑定数据
        heroVM.herosVariable.asObservable().bind(to: tableView.rx.items(cellIdentifier: "HeroCellID", cellType: UITableViewCell.self)) { (row, hero, cell) in
            cell.textLabel?.text = hero.name
            cell.detailTextLabel?.text = hero.intro
            cell.imageView?.image = UIImage(named: hero.icon)
        }.disposed(by: bag)
        
        
        // 3.监听UITableView的点击
        tableView.rx.modelSelected(Hero.self).subscribe(onNext: { (hero : Hero) in
            print(hero.name)
        }).disposed(by: bag)
        
        // 4.搜索功能
        searchBar.rx.text.subscribe(onNext: { (str : String?) in
            print(str!)
        }).disposed(by: bag)
    }
    
    
    @IBAction func itemClick(_ sender: Any) {
        let hero = Hero(dict: ["icon" : "nss", "name" : "coderwhy", "intro" : "最牛B的英雄"])
        //heroVM.herosObserable.value = [hero]
        heroVM.herosVariable.value = [hero]
    }
    
}






