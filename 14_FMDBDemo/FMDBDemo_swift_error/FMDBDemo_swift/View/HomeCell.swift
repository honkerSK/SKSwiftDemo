//
//  HomeCell.swift
//  FMDBDemo_swift
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    var user: User? {
        didSet {
            guard let user = user else {
                return
            }
            
            nameLabel.text = user.name
            guard let detail = user.detail else {
                return
            }
            
            timeLabel.text = detail.created_at
            contentLabel.text = detail.text
        }
    }

}
