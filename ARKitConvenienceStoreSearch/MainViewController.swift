//
//  ViewController.swift
//  ARKitConvenienceStoreSearch
//
//  Created by . SIN on 2017/11/12.
//  Copyright © 2017年 SAPPOROWORKS. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation

class MainViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var locationManager = LocationManager()
    let placeRepository = PlaceRepository()
    var location: CLLocation?
    var trueHeading: CLLocationDirection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        placeRepository.delegate = self
        
        sceneView.delegate = self
        sceneView.scene = SCNScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    
    @IBAction func tapPlaceSearchButton(_ sender: UIButton) {
        //performSegue(withIdentifier: "gotoPlaseSearchViewController", sender: nil)
    }
    
    @IBAction func tapClearButton(_ sender: UIButton) {
   
    }
    
    @IBAction func backFromPlaceSearchView(segue:UIStoryboardSegue){
        NSLog("backFromPalceSearchView")
    }
    
    @IBAction func tapButton(_ sender: Any) {
        let box = SCNBox(width: 3, height: 3, length: 3, chamferRadius: 0)
        let node = SCNNode(geometry: box)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        node.geometry?.materials = [material]
        
        if let trueHeading = trueHeading {
            let position = Calc.getPosition(trueHeading: trueHeading.magnitude, distance: 10, y: 0)
            print("t=\(trueHeading.magnitude) x=\(position.x) z=\(position.z) ")
            node.position = position
            sceneView.scene.rootNode.addChildNode(node)
            
        }

        // コンビニ再検索
        //        if let location = location {
        //            storeRepository.search(location: location)
        //        }
        
        //        if let location = location, let trueHeading = trueHeading {
        //            print("trueHeading = \(trueHeading)")
        //            let store = Store(name: "札幌駅", vicinity: "住所", lat: 43.068888, lng: 141.350723)
        //            let storeNode = StoreNode(store: store)
        //
        //            storeNode.position = SCNVector3(3, 0, -10)
        //
        //            sceneView.scene.rootNode.addChildNode(storeNode)
        //        }
        
        //        print("札幌駅 \(location.angle(to: CLLocation(latitude: 43.068888, longitude: 141.350723)))")
        //        print("定山渓温泉 \(location.angle(to: CLLocation(latitude: 42.968980, longitude: 141.166929)))")
        //        print("東京駅 \(location.angle(to: CLLocation(latitude: 35.681376, longitude: 139.767030)))")
        //        print("オホーツク \(location.angle(to: CLLocation(latitude: 43.995376, longitude: 144.241423)))")
        //        print("稚内 \(location.angle(to: CLLocation(latitude: 45.418549, longitude: 141.677240)))")
        //        print("釧路 \(location.angle(to: CLLocation(latitude: 42.990663, longitude: 144.381835)))")
        //        print("苫小牧 \(location.angle(to: CLLocation(latitude: 42.654652, longitude: 141.689278)))")
        //        print("小樽 \(location.angle(to: CLLocation(latitude: 43.200934, longitude: 141.018010)))")
    }

    
}

extension MainViewController: PlaceRepositoryDelegate {
    func finishSearch(error: Error?, Places places: [Place]) {
        if let error = error {
            print(error)
            return
        }
        for (i, place) in places.enumerated() {
            print("\(i) \(round(place.distance*100)/100)m \(place.name)")
        }
    }
}


extension MainViewController: LocationManagerDelegate {
    func locationManagerDidUpdateLocation(location: CLLocation) {
        print("😀　latitude(北緯)=\(location.coordinate.latitude) 　longitude（東経）=\(location.coordinate.longitude)")
        self.location = location
        
        
        //        print("札幌駅 \(location.angle(to: CLLocation(latitude: 43.068888, longitude: 141.350723)))")
        //        print("定山渓温泉 \(location.angle(to: CLLocation(latitude: 42.968980, longitude: 141.166929)))")
        //        print("東京駅 \(location.angle(to: CLLocation(latitude: 35.681376, longitude: 139.767030)))")
        //        print("オホーツク \(location.angle(to: CLLocation(latitude: 43.995376, longitude: 144.241423)))")
        //        print("稚内 \(location.angle(to: CLLocation(latitude: 45.418549, longitude: 141.677240)))")
        //        print("釧路 \(location.angle(to: CLLocation(latitude: 42.990663, longitude: 144.381835)))")
        //        print("苫小牧 \(location.angle(to: CLLocation(latitude: 42.654652, longitude: 141.689278)))")
        //        print("小樽 \(location.angle(to: CLLocation(latitude: 43.200934, longitude: 141.018010)))")
        
    }
    
    func locationManagerDidUpdateHeading(trueHeading: CLLocationDirection, magneticHeading: CLLocationDirection, accuracy: CLLocationDirection) {
        //print("😀 trueHeading = \(trueHeading) accuracy = \(accuracy)")
        self.trueHeading = trueHeading
    }
}


extension CLLocation {
    // 方角の取得
    func angle(to: CLLocation) -> Double {
        let longitudeDifference = to.coordinate.longitude - coordinate.longitude
        let latitudeDifference  = to.coordinate.latitude - coordinate.latitude
        var azimuth = (Double.pi * 0.5) - atan(latitudeDifference / longitudeDifference);
        
        if longitudeDifference > 0 {
        } else if longitudeDifference < 0 {
            azimuth += Double.pi
        } else if latitudeDifference < 0 {
            azimuth = Double.pi
        } else {
            azimuth = 0
        }
        return azimuth * 360 / (Double.pi * 2)
    }
}

class Calc {
    static func getPosition(trueHeading: Double, distance: Double, y: Double) -> SCNVector3 {
        let angle = trueHeading + 90.0
        let radian = Double.pi / 180 * Double(angle)
        let x = cos(radian) * distance
        let z = (sin(radian) * distance) * -1
        return SCNVector3(x, y, z)
    }
}


