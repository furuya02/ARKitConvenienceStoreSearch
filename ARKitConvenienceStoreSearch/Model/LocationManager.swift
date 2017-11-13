//
//  LocationManager.swift
//  ARKitConvenienceStoreSearch
//
//  Created by SIN on 2017/11/13.
//  Copyright © 2017年 SAPPOROWORKS. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate {
    func locationManagerDidUpdateLocation(location: CLLocation)
    func locationManagerDidUpdateHeading(trueHeading: CLLocationDirection, magneticHeading: CLLocationDirection, accuracy: CLLocationDirection)
}

class LocationManager: NSObject {
    
    private var locationManager: CLLocationManager?
    var delegate: LocationManagerDelegate?
    
    var location: CLLocation?
    var trueHeading: CLLocationDirection?
    var magneticHeading: CLLocationDirection?
    var accuracy: CLLocationDegrees? // 真北と磁北の偏差
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        if let lm = locationManager {
            lm.desiredAccuracy = kCLLocationAccuracyBest // 測位の精度
            lm.distanceFilter = kCLDistanceFilterNone // 取得間隔
            lm.headingFilter = kCLHeadingFilterNone // 取得角度
            lm.pausesLocationUpdatesAutomatically = false // true=バッテリー消費量を抑える
            lm.startUpdatingHeading() // 方位角の取得開始
            lm.delegate = self
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            delegate?.locationManagerDidUpdateLocation(location: location)
        }
        location = manager.location
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        trueHeading = newHeading.trueHeading
        magneticHeading = newHeading.magneticHeading
        accuracy = newHeading.headingAccuracy
        delegate?.locationManagerDidUpdateHeading(trueHeading: trueHeading!, magneticHeading: magneticHeading!, accuracy: accuracy!)
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // まだ選択されていない
            locationManager?.requestWhenInUseAuthorization() // 起動中のみの取得許可を求める
            break
        case .authorizedWhenInUse:
            print("位置情報取得(起動時のみ)が許可されました")
            locationManager?.startUpdatingLocation()
            break
        case .denied:
            print("位置情報取得が拒否されました")
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }
}

