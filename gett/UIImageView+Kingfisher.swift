//
//  UIImage+Kingfisher.swift
//  gett
//
//  Created by nathan on 14/01/2018.
//  Copyright © 2018 nathan. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func download(image url: String) {
        guard let imageURL = URL(string:url) else {
            return
        }
        self.kf.setImage(with: ImageResource(downloadURL: imageURL))
    }
}
