//
//  InitiateRunViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 5/16/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import MapKit

class InitiateRunViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBAction func startButton(_ sender: UIButton) {
        performSegue(withIdentifier: "StartRun", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.mapType = .mutedStandard
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
}
