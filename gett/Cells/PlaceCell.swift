//
//  PlaceCell.swift
//  gett
//
//  Created by nathan on 14/01/2018.
//  Copyright © 2018 nathan. All rights reserved.
//

import UIKit
import Reusable

class PlaceCell: UITableViewCell ,NibReusable{

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!

    var item: Place? {
        didSet {
            guard let item = item else {
                return
            }
            lblTitle?.text = item.name
            thumb?.download(image: item.icon )
        }
    }

    func setup(item: Place) {
        self.item = item
    }
}
