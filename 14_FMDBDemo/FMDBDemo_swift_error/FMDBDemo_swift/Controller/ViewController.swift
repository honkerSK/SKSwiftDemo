//
//  ViewController.swift
//  FMDBDemo_swift
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var dataSource = [User]() {
        didSet {
            self.cellHeights = getCellHeight()
            tableView.reloadData()
        }
    }
    
    lazy var cellHeights: [CGFloat] = []
    
    func getCellHeight() -> [CGFloat] {
        return self.dataSource.map{
            let detailText = $0.detail?.text ?? ""
            let textHeight = detailText.boundingRect(with: CGSize(width: self.view.bounds.width - 20, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)], context: nil).size.height
            return detailText.isEmpty ? 0 : textHeight + 87
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 从数据库中获取数据
        User.dataSource {
            self.dataSource = $0
        }
        
        if dataSource.count != 0 {
            print("从缓存中获取")
            return
        }
        
        print("从网络获取数据")
        // 发起网络请求
        HttpTool.loadRequest(urlString: "http://api.budejie.com/api/api_open.php?a=list&c=data&type=29", method: .get) { (result, error) in
            if error != nil {
                return
            }
            
            guard let dictArray = result["list"] as? [[String : Any]] else {
                return
            }
            
            self.dataSource = dictArray.map{
                let user = User(dict: $0)
                user.insert()
                return user
            }
        }
    }
}


// MARK: - UITableView datasource
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.user = dataSource[indexPath.row]
        return cell
    }
}

// MARK: - UITableView delegate
extension ViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = dataSource[indexPath.row]
            user.detail?.delete()
            
            dataSource.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
}
