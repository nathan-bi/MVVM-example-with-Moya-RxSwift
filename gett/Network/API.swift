//
//  API.swift
//  gett
//
//  Created by nathan on 14/01/2018.
//  Copyright © 2018 nathan. All rights reserved.
//

import Foundation
import Moya

let apiKey = "AIzaSyBnjE2xxY81U_fXB7wgQbXUeYZZU8_JQrA"

enum API {
    case locationAddress(String)
    case nearbyPlaces(String)
}
extension API: TargetType {
    var headers: [String : String]? {
       return ["Content-Type":"application/json"]
    }

    var baseURL: URL { return URL(string: "https://maps.googleapis.com/maps/api/")!}
    var path: String {
        switch self {
        case .locationAddress(let location):
            return "geocode/json"
        case .nearbyPlaces(let location):
            return "place/nearbysearch/json"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
  
    var task: Task {
        
        var params = [String:String]();
        switch self {
        case .locationAddress(let location):
            params = [
                "latlng" : location,
                "key": apiKey
            ]
        case .nearbyPlaces(let location):
            params = [
                "location" : location,
                "radius" : "500",
                "type":"",
                "key": apiKey
            ]
            
        }
        return .requestParameters(parameters: params , encoding: URLEncoding.default)
    }
    
    var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }
}
