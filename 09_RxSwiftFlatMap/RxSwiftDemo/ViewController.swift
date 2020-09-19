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

struct Student {
    var score : BehaviorRelay<Double>
}

class ViewController: UIViewController {
    
    fileprivate lazy var bag : DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.Swift中如何使用map
        let array = [1, 2, 3, 4]
        /*
        var tempArray = [Int]()
        for num in array {
            tempArray.append(num * num)
        }
        let array2 = array.map { (num : Int) -> Int in
            return num * num
        }
        */
        let array2 = array.map({ $0 * $0 })
        print(array2)
        print("---------------------")
        
        // 2.在RxSwift中map函数的使用
        Observable.of(1, 2, 3, 4)
            .map { (num : Int) -> Int in
                return num * num
            }
            .subscribe { (event : Event<Int>) in
                print(event)
            }
            .disposed(by: bag)
        
        print("------------")
        
        // 3.flatMap使用
        let stu1 = Student(score: BehaviorRelay(value: 80))
        let stu2 = Student(score: BehaviorRelay(value: 100))
        
        let studentVariable = BehaviorRelay(value: stu1)
        
        /*
        //flatMap问题:修改studentVariable订阅值, 会同时订阅 stu1 和stu2
         studentVariable.asObservable()
            .flatMap { (stu : Student) -> Observable<Double> in
                return stu.score.asObservable()
            }
            .subscribe { (event : Event<Double>) in
                print(event)
            }
            .disposed(by: bag)
        */
        
        //改进 flatMapLatest : studentVariable 只要发生改变, 使用最新的订阅值
        studentVariable.asObservable()
            .flatMapLatest { (stu : Student) -> Observable<Double> in
                return stu.score.asObservable()
            }
            .subscribe { (event : Event<Double>) in
                print(event)
            }
            .disposed(by: bag)
        
        //修改订阅值
        studentVariable.accept(stu2)
        stu2.score.accept(0)
        
        stu1.score.accept(1000)
    }


}





