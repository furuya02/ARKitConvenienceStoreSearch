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

class MainViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
}
