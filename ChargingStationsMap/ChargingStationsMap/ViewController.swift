//
//  ViewController.swift
//  ChargingStationsMap
//
//  Created by Julia Potapenko on 12/8/16.
//  Copyright © 2016 Julia Potapenko. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var centerLocationView: UIView!
    
    var userLocation = CLLocationCoordinate2D(latitude: 37.2482536, longitude: -122.014477);
    var dataLoader = DataLoader()
    
    @IBAction func centerMap() {
        mapView.setUserTrackingMode(.follow, animated: true)
        centerLocationView.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let location = mapView.userLocation.location {
            userLocation = location.coordinate
        }
        let region = MKCoordinateRegionMakeWithDistance(userLocation, 5000, 5000)
        mapView.setRegion(region, animated: true)
    }
    
    var updateOnLaunch = true
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if updateOnLaunch {
            if let location = mapView.userLocation.location {
                self.userLocation = location.coordinate
                mapView.setUserTrackingMode(.follow, animated: true)
                showStations()
                updateOnLaunch = false
            }
            mapView.centerCoordinate = self.userLocation
        }
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if mapView.userTrackingMode == .none {
            centerLocationView.isHidden = false
        }
    }
    
    func showStations() {
        let location = userLocation
        let latitudeDelta = mapView.region.span.latitudeDelta * 69.0 / 2
        let longitudeDelta = mapView.region.span.longitudeDelta * 69.0 * abs((cos(2 * M_PI * location.latitude / 360.0))) / 2
        let distance = latitudeDelta > longitudeDelta ? latitudeDelta : longitudeDelta
        //print(latitudeDelta)
        //print(longitudeDelta)
        dataLoader.downloadDataForLocation(latitude: location.latitude, longitude: location.longitude, distance: distance) { result in
            DispatchQueue.main.async {
                self.mapView.addAnnotations(result)
            }
        }
        
    }

}

