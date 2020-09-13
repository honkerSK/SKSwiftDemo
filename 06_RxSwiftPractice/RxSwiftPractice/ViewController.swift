//
//  ViewController.swift
//  RxSwiftPractice
//
//  Created by sunke on 2020/9/12.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    fileprivate lazy var bag : DisposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.监听按钮点击
        //1.1 传统方式
        //btnClickDemo()
        //1.2 RxSwift方式
        rxBtnClickDemo()
        
        //2.监听UITextField的文字改变
        //2.1 传统做法, 设置代理
        //textField1.delegate = self
        //textField2.delegate = self
        
        //2.2 RxSwift, 订阅文字的改变
        //rxTextFieldDemo()
        
        
        //3.将UITextField文字改变的内容显示在Label中
        rxTextFieldBindDemo()
        
        
        //4.KVO
        //4.1 传统方式
        //kvoDemo()
        
        
        //4.2 RxSwift方式
        rxKvoDemo()
        
        //5.UIScrollView的滚动
        scrollView.contentSize = CGSize(width: 1000, height: 0)
        //5.1 传统方法
        //scrollView.delegate = self
        
        //5.2 RxSwift方式
        scrollView.rx.contentOffset.subscribe(onNext: { (point : CGPoint) in
            print(point)
        }).disposed(by: bag)
        
    }
    
    
    
}


//MARK:- 1.监听按钮点击
extension ViewController{
    func btnClickDemo()  {
        //1.1 传统方式
        btn1.addTarget(self, action: #selector(btn1Click), for: .touchUpInside)
        btn2.addTarget(self, action: #selector(btn2Click), for: .touchUpInside)
    }
    
    @objc func btn1Click(){
        print("点击按钮1")
    }
    @objc func btn2Click(){
        print("点击按钮2")
    }
    
    //1.2 RxSwift方式
    func rxBtnClickDemo(){
        btn1.rx.tap.subscribe { (event : Event<()>) in
            print("按钮1发生了点击")
        }.disposed(by: bag)
        btn2.rx.tap.subscribe { (event : Event<()>) in
            print("按钮2发生了点击")
        }.disposed(by: bag)
        
    }
    
}



//MARK:- 2.监听UITextField的文字改变
extension ViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == textField1 {
            print("第一个输入框发生了改变")
        } else {
            print("第二个输入框发生了改变")
        }
        return true
    }
    
}

extension ViewController {
    func rxTextFieldDemo(){
        
        //方法一: 需要解包2次
        /*
         textField1.rx.text.subscribe { (event : Event<String?>) in
         print(event.element)
         }.disposed(by: bag)
         
         textField2.rx.text.subscribe { (event : Event<String?>) in
         print(event.element!!)
         }.disposed(by: bag)
         */
        
        //方法二:onNext 需要解包1次
        textField1.rx.text.subscribe(onNext: { (str : String?) in
            print(str!)
        }).disposed(by: bag)
        
        textField2.rx.text.subscribe(onNext: { (str : String?) in
            print(str!)
        }).disposed(by: bag)
        
    }
    
    //MARK:- 3.将UITextField文字改变的内容显示在Label中
    func rxTextFieldBindDemo() {
        textField1.rx.text
            .bind(to: label1.rx.text)
            .disposed(by: bag)
        textField2.rx.text
            .bind(to: label2.rx.text)
            .disposed(by: bag)
        
    }
}

//MARK:- KVO
extension ViewController{
    
    func kvoDemo()  {
        label1.addObserver(self, forKeyPath: "text", options: .new, context: nil)
        label1.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        label2.addObserver(self, forKeyPath: "text", options: .new, context: nil)
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if label1.isEqual(object) {
            if keyPath == "text" {
                print("label1文字改变")
            } else {
                print("fame改变")
            }
        } else {
            print("label2文字改变")
        }
    }
    
    
    func rxKvoDemo() {
        label1.rx.observe(String.self, "text")
            .subscribe(onNext: { (str: String?) in
                guard let textStr = str else { return }
                print(textStr)
            }).disposed(by: bag)
        label1.rx.observe(CGRect.self, "frame")
            .subscribe(onNext: { (frame: CGRect?) in
                guard let label1Frame = frame else { return }
                print(label1Frame)
            }).disposed(by: bag)
        
        label2.rx.observe(String.self, "text")
            .subscribe(onNext: { (str:String?) in
                guard let textStr = str else { return }
                print(textStr)
            }).disposed(by: bag)
    }
    
}


extension ViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }

}




