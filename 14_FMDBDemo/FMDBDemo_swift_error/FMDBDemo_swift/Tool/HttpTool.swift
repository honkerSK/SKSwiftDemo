//
//  HttpTool.swift
//  FMDBDemo_swift
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
import Alamofire

//enum HttpToolMethod: String {
//    case options = "OPTIONS"
//    case get     = "GET"
//    case head    = "HEAD"
//    case post    = "POST"
//    case put     = "PUT"
//    case patch   = "PATCH"
//    case delete  = "DELETE"
//    case trace   = "TRACE"
//    case connect = "CONNECT"
//}

class HttpTool: NSObject {

    static func loadRequest(urlString: String, method: HTTPMethod, result: @escaping ([String : Any], Error?) -> ()) {
//        guard let method = HTTPMethod(rawValue: method.rawValue) else { return }
//
//        Alamofire.request(urlString, method: method).responseJSON { (response: DataResponse<Any>) in
//
//            switch response.result {
//            case .success(let value):
//                result((value as? [String : Any]) ?? [:] , nil)
//            case .failure(let error):
//                result([:], error)
//            }
//        }
        
        AF.request(urlString, method: method).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                result((value as? [String : Any]) ?? [:] , nil)
            case .failure(let error):
                result([:], error)
            }
        }
    }
}

