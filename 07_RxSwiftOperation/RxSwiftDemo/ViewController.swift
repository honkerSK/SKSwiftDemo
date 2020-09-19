//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by sunke on 2020/9/13.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    fileprivate lazy var bag : DisposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.创建一个never的Obserable
        //never就是创建一个sequence，但是不发出任何事件信号。
        let neverO = Observable<String>.never()
        neverO.subscribe { (event : Event<String>) in
            print(event)
            print("This will never be printed")
        }.disposed(by: bag)
        
        
        // 2.创建一个empty的Obserable
        //empty就是创建一个空的sequence,只能发出一个completed事件
        let emptyO = Observable<String>.empty()
        emptyO.subscribe { (event : Event<String>) in
            print(event)
        }.disposed(by: bag)
        
        print("--------------------")
        
        // 3.创建一个just的Obserable
        //just --> 1> 传入的值  2> 完成事件
        //just是创建一个sequence只能发出一种特定的事件，能正常结束
        let justO = Observable.just("coderTao")
        justO.subscribe { (event : Event<String>) in
            print(event)
        }.disposed(by: bag)
        
        print("--------------------")
        
        
        // 4.创建一个of的Obserable
        //of是创建一个sequence能发出很多种事件信号
        //of --> 1> 传入空值 2> 依次显示对应的值 3>
        let ofO = Observable.of("a", "b", "c")
        ofO.subscribe { (event : Event<String>) in
            print(event)
        }.disposed(by: bag)
        
        print("--------------------")
        
        // 5.创建一个from的Obserable
        // from就是从数组中创建sequence
        let array = [1, 2, 3, 4, 5]
        let fromO = Observable.from(array)
        fromO.subscribe { (event : Event<Int>) in
            print(event)
        }.disposed(by: bag)
        
        
        print("--------------------")
        
        // 6.创建一个create的Obserable
        //create操作符传入一个观察者observer，然后调用observer的onNext，onCompleted和onError方法。返回一个可观察的obserable序列。
        let createO = createObserable()
        
        createO.subscribe { (event : Event<Any>) in
            print(event)
        }.disposed(by: bag)
        
        let myJustO = myJustObserable(element: "coderTao")
        myJustO.subscribe { (event : Event<String>) in
            print(event)
        }.disposed(by: bag)
        
        print("--------------------")
        
        
        // 7.创建一个Range的Obserable
        //range就是创建一个sequence，他会发出这个范围中的从开始到结束的所有事件
        let rangeO = Observable.range(start: 1, count: 10)
        rangeO.subscribe { (event : Event<Int>) in
            print(event)
        }.disposed(by: bag)
        
        print("--------------------")
        
        
        // 8.repeatElement
        //创建一个sequence，发出特定的事件n次
        let repeatO = Observable.repeatElement("hello world")
        repeatO.take(5)
            .subscribe { (event : Event<String>) in
                print(event)
        }.disposed(by: bag)
        
        print("------------------------")
        
        // 9.generate(类似于for循环)
        let generateO = Observable.generate(initialState: 0, condition: { $0 < 10 }, iterate: { $0 + 1 })
        generateO.subscribe({ print($0) })
            .disposed(by: bag)
        
        print("------------------------")
        
        // 10.error(发出错误信号)
        let error = NSError(domain: "错误", code: 1000, userInfo: nil) as Error
        let errorO = Observable<Any>.error(error)
        errorO.subscribe({ print($0) })
            .disposed(by: bag)
    }
    
}


extension ViewController {
    fileprivate func createObserable() -> Observable<Any> {
        return Observable.create({ (observer : AnyObserver<Any>) -> Disposable in
            observer.onNext("coderTao")
            observer.onNext("18")
            observer.onNext("1.88")
            observer.onCompleted()
            return Disposables.create()
        })
    }
    fileprivate func myJustObserable(element : String) -> Observable<String> {
        return Observable.create({ (observer : AnyObserver<String>) -> Disposable in
            observer.onNext(element)
            observer.onCompleted()
            
            return Disposables.create()
        })
    }
}


