//
//  ViewController.swift
//  swiftTest
//
//  Created by sunke on 2020/10/11.
//

import UIKit
//import SecondViewController

//为没有参数也没有返回值的闭包类型起一个别名
typealias Nothing = () -> ()

//如果闭包的没有返回值，那么我们还可以这样写，
typealias Anything = () -> Void

//为接受一个Int类型的参数不返回任何值的闭包类型 定义一个别名：PrintNumber
typealias PrintNumber = (Int) -> ()

//为接受两个Int类型的参数并且返回一个Int类型的值的闭包类型 定义一个别名：Add
typealias Add = (Int, Int) -> (Int)

class ViewController: UIViewController {
    
    
    //闭包的创建、赋值、调用
    //为(_ num1: Int, _ num2: Int) -> (Int) 类型的闭包定义别名：Add
    typealias Add = (_ num1: Int, _ num2: Int) -> (Int)
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        test1()
        
        //形式二：闭包类型申明和变量的创建合并在一起
        test2()
        
        //形式三：省略闭包接收的形参、省略闭包体中返回值
        test3()
        
        //形式四：在形式三的基础上进一步精简
        test4()
        
        //形式五：如果闭包没有接收参数省略in
        test5()
        
        //形式六：简写的实际参数名
        test6()
        
//        let closer : (Int , Int)-> (Int) = { (a, b) in
//            return a + b
//        }
//        let c = closer(3, 4)
//        print("c= \(c)")
        
        
    }
    
    
    @IBAction func pushVC(_ sender: Any) {
        let secondVC = SecondViewController()
        secondVC.closer = { [weak self] (text) in
            self?.label.text = text
        }

        navigationController?.pushViewController(secondVC, animated: true)
        
    }
    
    
    func test1() {
        //创建一个 Add 类型的闭包常量：addCloser1
        let addCloser1: Add
        //为已经创建好的常量 addCloser1 赋值
        addCloser1 = {
            (_ num1: Int, _ num2: Int) -> (Int) in
            return num1 + num2
        }
        
        //调用闭包并接受返回值
        let result = addCloser1(20, 10)
    }
    
    func test2() {
        //创建一个 (_ num1: Int, _ num2: Int) -> (Int) 类型的闭包常量：addCloser1
        let addCloser1: (_ num1: Int, _ num2: Int) -> (Int)
        //为已经创建好的常量 addCloser1 赋值
        addCloser1 = {
            (_ num1: Int, _ num2: Int) -> (Int) in
            return num1 + num2
        }
        //调用闭包并接受返回值
        let result = addCloser1(20, 10)
        
    }
    
    func test3() {
        //创建一个 (Int, Int) -> (Int) 类型的闭包常量：addCloser1
        let addCloser1: (Int, Int) -> (Int)
        //为已经创建好的常量 addCloser1 赋值
        addCloser1 = {
            (num1, num2) in
            return num1 + num2
        }
        //调用闭包并接受返回值
        let result = addCloser1(20, 10)
    }
    
    func test4() {
        //创建一个 (Int, Int) -> (Int) 类型的闭包常量：addCloser1 并赋值
        let addCloser1: (Int, Int) -> (Int) = { [weak self]
            (num1, num2) in
            return num1 + num2
        }
        //调用闭包并接受返回值
        let result = addCloser1(20, 10)
    }
    
    func test5() {
        //创建一个 () -> (String) 类型的闭包常量：addCloser1 并赋值
        let addCloser1: () -> (String) = {
            return "这个闭包没有参数，但是有返回值"
        }
        //调用闭包并接受返回值
        let result = addCloser1()
    }
    
    func test6() {
        //创建一个 (String, String) -> (String) 类型的闭包常量：addCloser1 并赋值
        let addCloser1: (String, String) -> (String) = {
            return "闭包的返回值是:\($0),\($1)"
        }
        //调用闭包并接受返回值
        let result = addCloser1("Hello", "Swift!")
    }
    
    
}

