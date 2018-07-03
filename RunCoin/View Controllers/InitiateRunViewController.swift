//
//  InitiateRunViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 5/16/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import MapKit

class InitiateRunViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func startButton(_ sender: UIButton) {
        performSegue(withIdentifier: "StartRun", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = .mutedStandard
        mapView.showsUserLocation = true
    }
}
