//
//  StartRunViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 3/23/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
// * Copyright (c) 2017 Razeware LLC
// *
// * Permission is hereby granted, free of charge, to any person obtaining a copy
// * of this software and associated documentation files (the "Software"), to deal
// * in the Software without restriction, including without limitation the rights
// * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// * copies of the Software, and to permit persons to whom the Software is
// * furnished to do so, subject to the following conditions:
// *
// * The above copyright notice and this permission notice shall be included in
// * all copies or substantial portions of the Software.

import UIKit
import CoreLocation
import MapKit
import CoreData
import AVFoundation

class StartRunViewController: UIViewController {
    
    //Declared Variables
    private var run : Run?
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    var sumPastRunDistance : Double!
    var container: NSPersistentContainer!
    var usersRunCoin : Int = 0
    var coinSound : AVAudioPlayer!
    let finalRun = Run(context: CoreDataStack.context)
    var earnedRunCoin = false
    let runCoinDistance = 4023.36
    
    //Buttons & Actions
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeDurationLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var finishResumeStackView: UIStackView!
    @IBOutlet weak var runCoinLabel: UILabel!
    @IBOutlet weak var runCoinEarnedImage: UIImageView!
    @IBOutlet weak var runCoinZeroPlaceholder: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startRun()
        earnRunCoin()
        configureView()
    }
    
    func configureView(){
        finishButton.layer.borderWidth = 0.5
        finishButton.layer.borderColor = UIColor.offBlue.cgColor
        mapView.showsUserLocation = true
//        runCoinEarnedImage.isHidden = true
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
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
        
        stopRun()
        setVisibleMapArea()
        checkFinalDistance()
    }
    
    func setVisibleMapArea() {
        let runRect = Run(context: CoreDataStack.context)
        for location in locationList {
            let locationObject = Location(context: CoreDataStack.context)
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            runRect.addToLocations(locationObject)
        }
        
        let locations = runRect.locations
        if locations.count > 1 {
            
            let latitudes = locations.map { location -> Double in
                let location = location as! Location
                return location.latitude
            }
            
            let longitudes = locations.map { location -> Double in
                let location = location as! Location
                return location.longitude
            }
            
            let maxLat = latitudes.max()!
            let minLat = latitudes.min()!
            let maxLong = longitudes.max()!
            let minLong = longitudes.min()!
            
            let coord1 = CLLocationCoordinate2DMake(maxLat, maxLong)
            let coord2 = CLLocationCoordinate2DMake(minLat, minLong)
            let point1 = MKMapPointForCoordinate(coord1)
            let point2 = MKMapPointForCoordinate(coord2)
            
            let mapRect = MKMapRectMake(fmin(point1.x, point2.x), fmin(point1.y, point2.y), fabs(point1.x-point2.x), fabs(point1.y-point2.y))
            let edgeInsets = UIEdgeInsetsMake(70, 50, 70, 50)
            
            mapView.setVisibleMapRect(mapRect, edgePadding: edgeInsets, animated: true)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        saveRun()
        saveButton.isEnabled = false
    }
    
    private func startRun() {
        mapView.removeOverlays(mapView.overlays)
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        startLocationUpdates()
    }
    
    private func stopRun() {
        locationManager.stopUpdatingLocation()
        
        timer?.invalidate()
        mapView.showsUserLocation = false
        guard let lastLocation = locationList.last?.coordinate else {return}
        let stopAnnotation = CustomPointAnnotation()
        stopAnnotation.coordinate = lastLocation
        stopAnnotation.imageName = "stop"
        mapView.addAnnotation(stopAnnotation)
    }
    
    func eachSecond() {
        seconds += 1
        updateDisplay()
    }
    
    private func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance, seconds: seconds, outputUnit: UnitSpeed.minutesPerMile)
        
        distanceLabel.text = "\(formattedDistance)"
        timeDurationLabel.text = "\(formattedTime)"
        paceLabel.text = "\(formattedPace)"
        earnRunCoin()
    }
    
    func goToHomeScreen() {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navController = UINavigationController(rootViewController: VC1)
        self.present(navController, animated:true, completion: nil)
    }
    
    func imageScreenshot(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot
    }
    
    private func saveRun() {
        mapView.showsUserLocation = false
        finalRun.setValue(distance.value, forKey: "distance")
        finalRun.duration = Int16(seconds)
        finalRun.timestamp = Date()
        
        for location in locationList {
            let locationObject = Location(context: CoreDataStack.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            finalRun.addToLocations(locationObject)
        }
        
        CoreDataStack.saveContext()
        run = finalRun
        
        let formattedDistance = FormatDisplay.distance(finalRun.distance)
        let formattedDuration = FormatDisplay.time(seconds)
        let formattedDate = FormatDisplay.date(finalRun.timestamp)
        let formattedPace = FormatDisplay.pace(distance: distance, seconds: seconds, outputUnit: UnitSpeed.minutesPerMile)
        if earnedRunCoin == true {
            playCoinSound()
        }
        
        guard let image = imageScreenshot(view: mapContainerView) else {
            print("image screenshot method did not work")
            return
        }
        configureGlobalStats(image: image, distance: formattedDistance, duration: formattedDuration, date: formattedDate, pace: formattedPace, singleRunCoin: usersRunCoin)
    }
    
    func configureGlobalStats(image: UIImage, distance: String, duration: String, date: String, pace: String, singleRunCoin: Int){
        Api.User.observeGlobalStats(completion: { (user) in
            self.finalRun.distance = self.distance.value
            let globalDistance = user.globalDistance! + self.finalRun.distance
            let globalDuration = user.globaleDuration! + self.seconds
            let globalRunCoin = user.globalRunCoin! + self.usersRunCoin
            HelperService.uploadDataToStorage(image: image, distance: distance, duration: duration, date: date, pace: pace, singleRunCoin: singleRunCoin, globalRunCoin: globalRunCoin, globalDistance: globalDistance, globalDuration: globalDuration, onSuccess: {
                self.goToStats()
            })
        })
    }
    
    func goToStats(){
        performSegue(withIdentifier: .details, sender: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    //MARK: CoreData
    func earnRunCoin(){
        let runningDistance = sumPastRunDistance + distance.value
        if runningDistance >= runCoinDistance {
            runCoinLabel.isHidden = true
            runCoinEarnedImage.isHidden = false
            earnedRunCoin = true
        }
    }
    
    func playCoinSound(){
        let audioFilePath = Bundle.main.path(forResource: "coins", ofType: ".m4r")
        let audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)
        do {
            try coinSound = AVAudioPlayer(contentsOf: audioFileUrl)
        }catch {
            print("error with playing coins.m4r sound")
        }
        coinSound.play()
        coinSound.volume = 1.0
        coinSound.numberOfLoops = 0
    }
    
    func checkFinalDistance(){
        let distanceArray = [4023.0, 8046.0, 12070.0, 14484.0, 18507.0, 22530.0, 26554.0]
        for (index, number) in distanceArray.enumerated() {
            if number < distance.value.rounded() {
                usersRunCoin = index + 1
                print("usersRunCoin", usersRunCoin)
            }
        }
    }
}

//MARK: Extensions
extension StartRunViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 100 && abs(howRecent) < 10 else {
                continue
            }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.add(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
                mapView.setRegion(region, animated: true)
                
                let pace = delta / Double(seconds)
                let formatPace = Measurement(value: pace, unit: UnitSpeed.metersPerSecond)
                let topSpeed = Measurement(value: 12.00, unit: UnitSpeed.metersPerSecond)
                
                if formatPace >= topSpeed {
                    speedFailSafe()
                }
            }
            locationList.append(newLocation)
            
            let startAnnotation = CustomPointAnnotation()
            guard let startLocation = locationList.first?.coordinate else {return}
            startAnnotation.coordinate = startLocation
            startAnnotation.imageName = "start"
            mapView.addAnnotation(startAnnotation)
        }
    }
    
    func speedFailSafe(){
        let ac = UIAlertController(title: "You're moving too fast!", message: "You've reached speeds above human capabilities! Either, you're in a car or on a bike. Please restart your run.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .destructive) { (action) in
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        ac.addAction(action)
        present(ac, animated: true)
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "annotationId"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.canShowCallout = true
        }
        else {
            anView?.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        anView?.image = UIImage(named:cpa.imageName)
        
        return anView
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

