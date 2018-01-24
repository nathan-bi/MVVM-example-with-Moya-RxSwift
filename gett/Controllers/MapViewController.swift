//
//  MapViewController.swift
//  gett
//
//  Created by nathan on 14/01/2018.
//  Copyright © 2018 nathan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import RxSwift

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblLocation: UILabel!
    
    var nearbyArr = [Place]()
    var location = CLLocation()
    let viewModel = PlacesViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        bind()
    }
    
    @IBAction func btnOpenList(_ sender: Any) {
        guard let nextController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListViewController") as? ListViewController else {
            return
        }
        nextController.nearbyArr = self.nearbyArr
        self.navigationController?.pushViewController(nextController, animated: true)
    }

    func bind(){
        viewModel.places.asObservable()
            .subscribe {[weak self] (places) in
                self?.nearbyArr = places.element ?? []
                for p in places.element ?? []{
                    self?.mapView.addPoint(place: p)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.locationText.asObservable()
            .subscribe {[weak self] (locName) in
                self?.lblLocation.text = locName.element
            }
            .disposed(by: disposeBag)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Point else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }
        return view
    }
}


