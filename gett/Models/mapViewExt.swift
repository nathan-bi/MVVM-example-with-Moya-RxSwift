//
//  mapViewExt.swift
//  gett
//
//  Created by nathan on 14/01/2018.
//  Copyright © 2018 nathan. All rights reserved.
//
import MapKit

extension MKMapView
{
    func addPoint(place: Place) {
        let point = Point(title: place.name,
                          locationName: place.name,
                          discipline: "",
                          coordinate: CLLocationCoordinate2D(latitude: place.lat, longitude: place.lng))
        addAnnotation(point)
    }
}

