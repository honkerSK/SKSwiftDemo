//
//  ViewController.swift
//  MixedImageTextDemo
//
//  Created by sunke on 2020/8/30.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

//插入的图片附件的尺寸样式
enum ImageAttachmentMode {
    case `default`  //默认（不改变大小）
    case fitTextLine  //使尺寸适应行高
    case fitTextView  //使尺寸适应textView
}


class ViewController: UIViewController {
    //图文混排显示的文本区域
    @IBOutlet weak var textView: UITextView!
    //文字大小
    let textViewFont = UIFont.systemFont(ofSize: 22)
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //插入图片1：保持原始尺寸
    @IBAction func btnClick1(_ sender: UIButton) {
        insertPicture(UIImage(named: "hero")!)
        
    }
    
    //插入图片2：适应行高
    @IBAction func btnClick2(_ sender: UIButton) {
        insertPicture(UIImage(named: "hero")!, mode:.fitTextLine)
        
    }
    
    //插入图片3：适应textView宽度
    @IBAction func btnClick3(_ sender: UIButton) {
        insertPicture(UIImage(named: "hero")!, mode:.fitTextView)
        
    }
    
    //插入文字
    @IBAction func btnClick4(_ sender: UIButton) {
        insertString("codeTao")
        
    }
    
    
    //插入文字
    func insertString(_ text:String) {
        //获取textView的所有文本，转成可变的文本
        let mutableStr = NSMutableAttributedString(attributedString: textView.attributedText)
        //获得目前光标的位置
        let selectedRange = textView.selectedRange
        //插入文字
        let attStr = NSAttributedString(string: text)
        mutableStr.insert(attStr, at: selectedRange.location)
        
        //设置可变文本的字体属性
        mutableStr.addAttribute(NSAttributedString.Key.font, value: textViewFont,
                                range: NSMakeRange(0,mutableStr.length))
        //再次记住新的光标的位置
        let newSelectedRange = NSMakeRange(selectedRange.location + attStr.length, 0)
        
        //重新给文本赋值
        textView.attributedText = mutableStr
        //恢复光标的位置（上面一句代码执行之后，光标会移到最后面）
        textView.selectedRange = newSelectedRange
    }
    
    //插入图片
    func insertPicture(_ image:UIImage, mode:ImageAttachmentMode = .default){
        //获取textView的所有文本，转成可变的文本
        let mutableStr = NSMutableAttributedString(attributedString: textView.attributedText)
        
        //创建图片附件
        let imgAttachment = NSTextAttachment(data: nil, ofType: nil)
        var imgAttachmentString: NSAttributedString
        imgAttachment.image = image
        
        //设置图片显示方式
        if mode == .fitTextLine {
            //与文字一样大小
            imgAttachment.bounds = CGRect(x: 0, y: -4, width: textView.font!.lineHeight,
                                          height: textView.font!.lineHeight)
        } else if mode == .fitTextView {
            //撑满一行
            let imageWidth = textView.frame.width - 10
            let imageHeight = image.size.height/image.size.width*imageWidth
            imgAttachment.bounds = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        }
        
        imgAttachmentString = NSAttributedString(attachment: imgAttachment)
        
        //获得目前光标的位置
        let selectedRange = textView.selectedRange
        //插入文字
        mutableStr.insert(imgAttachmentString, at: selectedRange.location)
        //设置可变文本的字体属性
        mutableStr.addAttribute(NSAttributedString.Key.font, value: textViewFont,
                                range: NSMakeRange(0,mutableStr.length))
        //再次记住新的光标的位置
        let newSelectedRange = NSMakeRange(selectedRange.location+1, 0)
        
        //重新给文本赋值
        textView.attributedText = mutableStr
        //恢复光标的位置（上面一句代码执行之后，光标会移到最后面）
        textView.selectedRange = newSelectedRange
        //移动滚动条（确保光标在可视区域内）
        self.textView.scrollRangeToVisible(newSelectedRange)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

