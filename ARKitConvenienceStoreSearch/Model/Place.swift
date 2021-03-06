//
//  PlaceSearch.swift
//  ARKitConvenienceStoreSearch
//
//  Created by SIN on 2017/11/13.
//  Copyright © 2017年 SAPPOROWORKS. All rights reserved.
//

import Foundation
import CoreLocation

class Place {
    var name: String = ""
    var vicinity: String = ""
    var location: CLLocation
    var distance: Double = -1
    init(name: String, vicinity: String, lat: Double, lng: Double) {
        self.name = name
        self.vicinity = vicinity
        self.location = CLLocation(latitude: lat, longitude: lng)
    }
    func setDistance(toLocation: CLLocation) {
        distance = location.distance(from: toLocation)
    }
    
}
