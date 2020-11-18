//
//  SecondViewController.swift
//  swiftTest
//
//  Created by sunke on 2020/10/12.
//

import UIKit

class SecondViewController: UIViewController {

    
    
    weak var textFiled : UITextField?
    
    var closer:((String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        let textFiled = UITextField()
        textFiled.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        textFiled.borderStyle = .roundedRect
        view.addSubview(textFiled)
        self.textFiled = textFiled
        
        
        let btn = UIButton(type: .custom)
        btn.setTitle("返回", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.backgroundColor = .red
        btn.frame = CGRect(x: 100, y: 250, width: 50, height: 50)
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        
    }
    
    @objc func back(){
        if closer != nil {
            closer!(textFiled!.text!)
        }
        navigationController?.popViewController(animated: true)
    }

    

   
}
