//
//  StartRunViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 3/23/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GameplayKit

class StartRunViewController: UIViewController {
    
    //Declared Variables
    private var run : Run?
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    var runCoinsEarned : Int = 0
    private var coins : RunCoins?
    
    
    //Buttons & Actions
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeDurationLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var finishResumeStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startRun()
        finishButton.layer.borderWidth = 0.5
        finishButton.layer.borderColor = UIColor.offBlue.cgColor
        mapView.showsUserLocation = true
        let userLocation = mapView.userLocation.coordinate
        let region = MKCoordinateRegionMakeWithDistance(userLocation, 500, 500)
        mapView.setRegion(region, animated: true)
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        stopButton.isHidden = true
        finishResumeStackView.isHidden = false
        resumeButton.isHidden = false
        finishButton.isHidden = false
    }
    
    @IBAction func discardButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    
    @IBAction func resumeButtonPressed(_ sender: UIButton) {
        stopButton.isHidden = false
        finishResumeStackView.isHidden = true
        resumeButton.isHidden = true
        finishButton.isHidden = true
    }
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        saveButton.isHidden = false
        finishResumeStackView.isHidden = true
        resumeButton.isHidden = true
        finishButton.isHidden = true
        stopButton.isHidden = true
        paceLabel.text = "--"
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        stopRun()
        saveRun()
        performSegue(withIdentifier: .details, sender: nil)
    }
    
    private func startRun() {
        mapView.removeOverlays(mapView.overlays)
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
        locationManager.stopUpdatingLocation()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        timer?.invalidate()
//        locationManager.stopUpdatingLocation()
//    }

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
        
        distanceLabel.text = "\(formattedDistance)"
        timeDurationLabel.text = "\(formattedTime)"
        paceLabel.text = "\(formattedPace)"
    }
    
    func goToHomeScreen() {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navController = UINavigationController(rootViewController: VC1)
        self.present(navController, animated:true, completion: nil)
    }
    
//    private func startLocationUpdates() {
//        locationManager.delegate = self
//        locationManager.activityType = .fitness
//        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
//        locationManager.startUpdatingLocation()
//        locationManager.allowsBackgroundLocationUpdates = true
//    }
    
    func imageScreenshot(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot
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
        
        let stringDistance = FormatDisplay.distance(newRun.distance).description
        let stringDuration = FormatDisplay.time(seconds).description
        let stringDate = FormatDisplay.date(newRun.timestamp).description
        let stringPace = FormatDisplay.pace(distance: distance, seconds: seconds, outputUnit: UnitSpeed.minutesPerMile).description
        
        guard let image = imageScreenshot(view: mapContainerView) else {
            print("image screenshot method did not work")
            return
        }
        //HelperService Instance Methods Go Here
        HelperService.uploadDataToStorage(image: image, distance: stringDistance, duration: stringDuration, date: stringDate, pace: stringPace)
    }
    
    func runCoinEarned() {
    }
    
    
}
//MARK: Extensions
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
        renderer.strokeColor = UIColor.offBlue
        renderer.lineWidth = 4
        return renderer
    }
}

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

