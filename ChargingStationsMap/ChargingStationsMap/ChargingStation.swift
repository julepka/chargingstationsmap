//
//  ChargingStation.swift
//  ChargingStationsMap
//
//  Created by Julia Potapenko on 12/11/16.
//  Copyright © 2016 Julia Potapenko. All rights reserved.
//

import Foundation
import MapKit

class ChargingStation: NSObject, MKAnnotation {
    var identifier = "ChargingStation"
    var operatorName: String?
    var usageType: String?
    var title: String?
    var address: String?
    let coordinate: CLLocationCoordinate2D
    
    init(latitude: Double, longitude: Double) {
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }
    
    var subtitle: String? {
        return address
    }
}
