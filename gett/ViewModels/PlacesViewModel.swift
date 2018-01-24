//
//  File.swift
//  gett
//
//  Created by nathan on 14/01/2018.
//  Copyright © 2018 nathan. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

final class PlacesViewModel :NSObject {
    let places: Variable<[Place]> = Variable([])
    let locationText = Variable("")
    
    private var apiManager: APICalls = APIManager()

    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        _locationManager.distanceFilter = 100.0
        _locationManager.allowsBackgroundLocationUpdates = true // allow in background
        return _locationManager
    }()
    
    var location: CLLocation? {
        didSet {
            guard let location = location else {
                return
            }
            getPlacesNearbyLocation(loc: location)
        }
    }
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func getPlacesNearbyLocation(loc: CLLocation!)
    {
        let location = "\(loc.coordinate.latitude),\(loc.coordinate.longitude)"
        apiManager.nearbyPlaces(location:location ) { [weak self] arr in
            self?.places.value = arr ?? []
        }
    }
    
    func reverseLocation(loc: CLLocation)
    {
        let location = "\(loc.coordinate.latitude),\(loc.coordinate.longitude)"
        apiManager.locationAddress(location: location) { [weak self] loc in
            self?.locationText.value = loc?.first?.address ?? ""
        }
    }
}

extension PlacesViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            reverseLocation(loc: location)
            self.location = location
            //    locationManager.stopUpdatingLocation()
        }
    }
}


