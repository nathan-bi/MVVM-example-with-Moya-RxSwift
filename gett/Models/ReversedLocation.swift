//
//  ReversedLocation.swift
//  gett
//
//  Created by nathan on 14/01/2018.
//  Copyright © 2018 nathan. All rights reserved.
//

import Foundation
import ObjectMapper

struct ReversedLocation {
    var address: String = ""
}

extension ReversedLocation: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        address    <- map["formatted_address"]
    }
}
