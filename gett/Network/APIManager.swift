//
//  APIManager.swift
//  gett
//
//  Created by nathan on 14/01/2018.
//  Copyright © 2018 nathan. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper
import Moya_ObjectMapper

extension Response {
    func getResultsFromData() -> Response {
        guard let json = try? self.mapJSON() as? Dictionary<String, AnyObject>,
            let results = json?["results"],
            let newData = try? JSONSerialization.data(withJSONObject: results, options: .prettyPrinted) else {
                return self
        }
        
        let newResponse = Response(statusCode: self.statusCode,
                                   data: newData,
                                   response: self.response)
        return newResponse
    }
}

struct APIManager {
    let provider: MoyaProvider<API>
    let disposeBag = DisposeBag()
    
    init() {
        provider = MoyaProvider<API>()
        provider.manager.session.configuration.timeoutIntervalForRequest = 120
    }
}

extension APIManager {
    typealias AddAction = (() -> ())

    fileprivate func requestArray<T: Mappable>(_ token: API, type: T.Type,
                                  completion: @escaping ([T]?) -> Void,
                                  additionalSteps:  AddAction? = nil) {
        provider.rx.request(token)
            .debug()
            .map { response -> Response in
                return response.getResultsFromData()
            }
            .mapArray(T.self)
            .subscribe { event -> Void in
                switch event {
                case .success(let parsedArray):
                    completion(parsedArray)
                    additionalSteps?()
                case .error(let error):
                    print(error)
                    completion(nil)
                }
            }.disposed(by: disposeBag)
    }
}

protocol APICalls {
    func locationAddress(location: String!, completion: @escaping ([ReversedLocation]?) -> Void)
    func nearbyPlaces(location: String!, completion: @escaping ([Place]?) -> Void)
}

extension APIManager: APICalls {
    func nearbyPlaces(location: String!, completion: @escaping ([Place]?) -> Void) {
        requestArray(.nearbyPlaces(location), type: Place.self, completion: completion)
    }
    
    func locationAddress(location: String!, completion: @escaping ([ReversedLocation]?) -> Void) {
        requestArray(.locationAddress(location), type: ReversedLocation.self, completion: completion)
    }

}
