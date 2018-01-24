//
//  Place.swift
//  gett
//
//  Created by nathan on 14/01/2018.
//  Copyright © 2018 nathan. All rights reserved.
//

import Foundation
import ObjectMapper

struct Place {
    var name: String = ""
    var id: String = ""
    var icon: String = ""
    var lat: Double = 0
    var lng: Double = 0
}

extension Place: Mappable {
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name    <- map["name"]
        id     <- map["id"]
        icon     <- map["icon"]
        lat     <- map["geometry.location.lat"]
        lng     <- map["geometry.location.lng"]
    }
    
}
