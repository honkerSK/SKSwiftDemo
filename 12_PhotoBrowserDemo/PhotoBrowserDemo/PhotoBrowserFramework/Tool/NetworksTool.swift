//
//  NetworksTool.swift
//  PhotoBrowserDemo
//
//  Created by sunke on 2020/9/17.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
import Alamofire

class NetworksTool: NSObject {

    // 设计swift单例
    static let shareInstance : NetworksTool = {
        let tools = NetworksTool()
        return tools
    }()
    
    // 给闭包起别名
    typealias FinishedCallBack = (_ results : [[String : AnyObject]]?, _ error : NSError?) -> ()
}

// MARK:- 请求数据
extension NetworksTool {
    func loadData(page : Int, offset : Int, finished : @escaping FinishedCallBack) {
        
        // 1.获取请求的URL
        let urlString = "https://picsum.photos/v2/list?page=\(page)&limit=30"
        
        // 2.发送网络请求
        
        AF.request(urlString).responseJSON {  (response) in
            switch response.result {
                case .success(let json):
                    //print(json)
                    guard let resultArray = json as? [[String: AnyObject]] else {
                         finished(nil, NSError(domain: "KentSun.PhotoBrowserDemo", code: 1000, userInfo: ["errorInfo" : "获取数据不正确"]))
                        return
                    }
                    
                    finished(resultArray, nil)
                    
                    break
                case .failure(let error):
                    print("error:\(error)")
                    finished(nil, error as NSError)
                    break
                }
        }

        
    }
}
