//
//  StartRunViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 3/23/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import CoreLocation
import MapKit

class StartRunViewController: UIViewController {
    
    //Declared Variables
    private var run : Run?
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    //Buttons & Actions
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeDurationLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var metricsStackView: UIStackView!
    @IBOutlet weak var launchPrompt: UIStackView!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Finished Running?",
                                                message: "Do you want to stop your workout?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.stopRun()
            self.saveRun()
            self.performSegue(withIdentifier: .details, sender: nil)
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.stopRun()
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        
        present(alertController, animated: true)
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        startRun()
    }
    
    private func startRun() {
        mapContainerView.isHidden = false
        mapView.removeOverlays(mapView.overlays)
        
        metricsStackView.isHidden = false
        launchPrompt.isHidden = true
        startButton.isHidden = true
        stopButton.isHidden = false
        
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        startLocationUpdates()
    }
    
    private func stopRun() {
        mapContainerView.isHidden = true
        
        metricsStackView.isHidden = true
        launchPrompt.isHidden = false
        startButton.isHidden = false
        stopButton.isHidden = true
        
        locationManager.stopUpdatingLocation()
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        GIDSignIn.sharedInstance().signOut()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Successfully logged out of Firebase from home screen!")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        goToHomeScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        metricsStackView.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func eachSecond() {
        seconds += 1
        updateDisplay()
    }
    
    private func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerMile)
        
        distanceLabel.text = "Distance:  \(formattedDistance)"
        timeDurationLabel.text = "Time:  \(formattedTime)"
        paceLabel.text = "Pace:  \(formattedPace)"
    }
    
    func goToHomeScreen() {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navController = UINavigationController(rootViewController: VC1)
        self.present(navController, animated:true, completion: nil)
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    private func saveRun() {
        let newRun = Run(context: CoreDataStack.context)
        newRun.distance = distance.value
        newRun.duration = Int16(seconds)
        newRun.timestamp = Date()
        
        for location in locationList {
            let locationObject = Location(context: CoreDataStack.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newRun.addToLocations(locationObject)
        }
        CoreDataStack.saveContext()
        run = newRun
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "GoToRunStats" {
//            let destination = segue.destination as! RunStatsViewController
//            destination.run = run
//        }
//    }
}
//Extensions
extension StartRunViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case details = "GoToRunStats"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .details:
            let destination = segue.destination as! RunStatsViewController
            destination.run = run
        }
    }
}

extension StartRunViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.add(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
                mapView.setRegion(region, animated: true)
            }
            
            locationList.append(newLocation)
        }
    }
}

extension StartRunViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}
