//
//  PlaceRepository.swift
//  ARKitConveniencePlaceSearch
//
//  Created by SIN on 2017/11/13.
//  Copyright © 2017年 SAPPOROWORKS. All rights reserved.
//

import Foundation

/**
 近隣の位置情報を検索するクラス
 */

import UIKit
import CoreLocation

enum PlaceRepositoryError : Error {
    case query
    case parse
    case url
}

protocol PlaceRepositoryDelegate {
    func finishSearch(error: Error?, Places:[Place])
}

class PlaceRepository {
    
    var delegate: PlaceRepositoryDelegate?
    
    let max = 10
    //    let GOOGLE_API_KEY = "xxxxxxxxxxxxxxxxxxxxxx" <= 別ファイル（SecretKey.swift）に定義されており、github上では、公開されていません
    let googleApyKey = GOOGLE_API_KEY
    let type = "convenience_Place"
    
    private var Places: [Place] = []
    private var keep: [Place] = []
    
    func search(location: CLLocation) {
        let radius:CGFloat = 3000
        let mode = 0 // スタート:0 範囲を拡大:1 範囲を縮小:-1
        keep = []
        query(location: location, radius: radius, mode: mode)
    }
    
    private func query(location: CLLocation, radius: CGFloat , mode: Int) {
        
        var _mode = mode
        var _radius = radius

        //https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=軽度,緯度&radius=距離（ｍ）&types=convenience_store&key=APIキー

        let longitude = location.coordinate.longitude
        let latitude = location.coordinate.latitude
        print("◼︎Google Place nearbysearch mode=\(mode) radius=\(radius)m")
        guard let url = URL(string:"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&types=\(type)&key=\(googleApyKey)") else {
            self.delegate?.finishSearch(error: PlaceRepositoryError.url, Places: [])
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if error != nil {
                self.delegate?.finishSearch(error: PlaceRepositoryError.query, Places: [])
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                let results = self.parse(json: json)
                // 距離の設定
                results.forEach{ $0.setDistance(toLocation: location)}
                
                if results.count >= self.max {
                    if _mode == 1 {
                        self.marge(results: results)
                    } else {
                        _radius /= 2
                        if _radius < 10 { // 10m以下は検索しない
                            self.marge(results: results)
                        } else {
                            _mode = -1;
                            // １つ前の検索データを保存しておく
                            self.keep = results
                            // 再起処理
                            self.query(location: location, radius: _radius, mode: _mode)
                        }
                    }
                } else {
                    if _mode == -1 {
                        self.marge(results: results)
                    } else {
                        _radius *= 2
                        if _radius > 10000 { // 10km以上は検索しない
                            self.marge(results: results)
                        } else {
                            _mode = 1
                            // １つ前の検索データを保存しておく
                            self.keep = results
                            // 再起処理
                            self.query(location: location, radius: _radius, mode: _mode)
                        }
                    }
                }
            } catch {
                self.delegate?.finishSearch(error: PlaceRepositoryError.parse, Places: [])
            }
        })
        task.resume()
    }
    
    private func marge(results: [Place]) {
        // １つ前の検索データとマージする
        Places = keep
        for result in results {
            if Places.filter({ $0.name == result.name }).count == 0 {
                Places.append(result)
            }
        }
        // 距離でソート
        Places.sort{ $0.distance < $1.distance }
        // 近くのmax件を選出する
        Places = Places.prefix(max).map { $0 }
        
        delegate?.finishSearch(error: nil, Places: Places)
    }
    
    private func parse(json: NSDictionary) -> [Place] {
        var Places: [Place] = []
        if let results = json.object(forKey: "results") {
            for result in results as! NSArray {
                let name = (result as! NSDictionary).object(forKey: "name") as! String
                let vicinity = (result as! NSDictionary).object(forKey: "vicinity") as! String
                if let geometry = (result as! NSDictionary).object(forKey: "geometry") {
                    if let location = (geometry as! NSDictionary).object(forKey: "location") {
                        if let lat = (location as! NSDictionary).object(forKey: "lat"), let lng = (location as! NSDictionary).object(forKey: "lng") {
                            let stor = Place(name: name, vicinity: vicinity, lat: lat as! Double, lng: lng as! Double)
                            Places.append(stor)
                        }
                    }
                }
            }
        }
        return Places
    }
}

