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
    
    fileprivate lazy var bag : DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.PublishSubject, 订阅者只能接受, 订阅之后发出的事件
        let publishSub = PublishSubject<String>()
        publishSub.onNext("18")
        publishSub.subscribe { (event : Event<String>) in
            print(event)
        }.disposed(by: bag)
        publishSub.onNext("coderTao")
        print("-------------------------")
        
        
         // 2.ReplaySubject, 订阅者可以接受订阅之前的事件&订阅之后的事件
//         let replaySub = ReplaySubject<String>.create(bufferSize: 2)
         let replaySub = ReplaySubject<String>.createUnbounded()
         replaySub.onNext("a")
         replaySub.onNext("b")
         replaySub.onNext("c")
         
         replaySub.subscribe { (event : Event<String>) in
         print(event)
         }.disposed(by: bag)
         
         replaySub.onNext("d")
         print("-------------------------")
        
         
         // 3.BehaviorSubject, 订阅者可以接受,订阅之前的最后一个事件
         let behaviorSub = BehaviorSubject(value: "aa")
        behaviorSub.onNext("bb")
        behaviorSub.onNext("cc")
        behaviorSub.onNext("dd")

        
         behaviorSub.subscribe { (event : Event<String>) in
         print(event)
         }.disposed(by: bag)
         
         behaviorSub.onNext("ee")
         behaviorSub.onNext("ff")
         behaviorSub.onNext("gg")
         
         print("-------------------------")
         
         // 4.Variable (现在建议 BehaviorRelay 代替)
         /*
         Variable
         1> 相当于对BehaviorSubject进行装箱
         2> 如果想将Variable当成Obserable, 让订阅者进行订阅时, 需要asObserable转成Obserable
         3> 如果Variable打算发出事件, 直接修改对象的value即可
         4> 当事件结束时,Variable会自动发出completed事件
        
         
         */
        
//         let variable = Variable("a")
//         variable.value = "b"
//         variable.asObservable().subscribe { (event : Event<String>) in
//         print(event)
//         }.disposed(by: bag)
//
//         variable.value = "c"
//         variable.value = "d"
         
        
        let relay = BehaviorRelay(value: "a")
        relay.accept("b")
        relay.subscribe { (event : Event<String>) in
            print(event)
        }.disposed(by: bag)
        relay.accept("c")
        relay.accept("d")
        
    }
    
}






