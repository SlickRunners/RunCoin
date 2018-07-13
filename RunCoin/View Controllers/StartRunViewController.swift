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
    var pastRunData = [Run]()
    var container: NSPersistentContainer!
    var runPredicate: NSPredicate?
    var globalRunCoin : Int?
    var coinSound : AVAudioPlayer!
    var earnedCoin : Bool!
    
    
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
    @IBOutlet weak var runCoinLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        startRun()
        fetchPastRunData()
        finishButton.layer.borderWidth = 0.5
        finishButton.layer.borderColor = UIColor.offBlue.cgColor
        mapView.showsUserLocation = true
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
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
        paceLabel.text = "--"
        stopRun()
        setVisibleMapArea()
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
        print("LOCATIONSCOUNT",locations.count)
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
            let edgeInsets = UIEdgeInsetsMake(50, 50, 50, 50)
            
            mapView.setVisibleMapRect(mapRect, edgePadding: edgeInsets, animated: true)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
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
        earnRunCoin()
    }
    
    private func stopRun() {
        locationManager.stopUpdatingLocation()
        
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
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerMile)
        
        distanceLabel.text = "\(formattedDistance)"
        timeDurationLabel.text = "\(formattedTime)"
        paceLabel.text = "\(formattedPace)"
        earnRunCoin()
        if earnedCoin == true {
            playCoinSound()
        }
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
        let newRun = Run(context: CoreDataStack.context)
        newRun.distance = distance.value
        newRun.duration = Int16(seconds)
        newRun.timestamp = Date()
        
        for location in locationList {
            let locationObject = Location(context: CoreDataStack.context)
            locationObject.timestamp = location.timestamp as NSDate
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newRun.addToLocations(locationObject)
        }
        
        CoreDataStack.saveContext()
        run = newRun
        
        let formattedDistance = FormatDisplay.distance(newRun.distance)
        let formattedDuration = FormatDisplay.time(seconds)
        let formattedDate = FormatDisplay.date(newRun.timestamp)
        let formattedPace = FormatDisplay.pace(distance: distance, seconds: seconds, outputUnit: UnitSpeed.minutesPerMile)
        
        guard let image = imageScreenshot(view: mapContainerView) else {
            print("image screenshot method did not work")
            return
        }
        configureGlobalStats(image: image, distance: formattedDistance, duration: formattedDuration, date: formattedDate, pace: formattedPace)
    }
    
    func fetchPastRunData(){
        let request = Run.createFetchRequest()
        let sort = NSSortDescriptor(key: "timestamp", ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = runPredicate
        do {
            pastRunData = try CoreDataStack.context.fetch(request)
            print("got \(pastRunData.count) for past runData.")
        } catch {
            print("error with fetch request for pastRunData")
        }
    }
    
    func configureGlobalStats(image: UIImage, distance: String, duration: String, date: String, pace: String){
        Api.User.observeGlobalStats(completion: { (user) in
            let finalRun = Run(context: CoreDataStack.context)
            finalRun.distance = self.distance.value
            let globalDistance = user.globalDistance! + finalRun.distance
            let globalDuration = user.globaleDuration! + self.seconds
            //HelperService Instance Methods Go Here
            HelperService.uploadDataToStorage(image: image, distance: distance, duration: duration, date: date, pace: pace, globalRunCoin: 0, globalDistance: globalDistance, globalDuration: globalDuration)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    func earnRunCoin(){
        coreDataDistanceCheck()
        let runCoinDistance = 8000.00000000000000
        let runDist = Run(context: CoreDataStack.context)
        runDist.distance = distance.value
        let runData = pastRunData.map { (run) -> Double in
            run.distance
        }
        let previousRuns = runData.suffix(5)
        print("PREVIOUS RUNS", previousRuns)
        let sumPastRuns = previousRuns.reduce(0) { $0 + $1 }
        print("SUM PAST RUNS", sumPastRuns)
        if sumPastRuns < runCoinDistance {
            let sumDistance = sumPastRuns + runDist.distance
            if sumDistance > runCoinDistance {
                earnedCoin = true
                runCoinLabel.text = "1"
            }
        }
    }
    
    func coreDataDistanceCheck(){
        let runCoinDistance = 8000.00
        //deletes core data for Run entity when distance property is past 8000 meteres
        let runData = pastRunData.map { (run) -> Double in
            run.distance
        }
        let previousRuns = runData.suffix(5)
        let sumPastRuns = previousRuns.reduce(0) { $0 + $1 }
        if sumPastRuns > runCoinDistance {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Run")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try CoreDataStack.context.execute(batchDeleteRequest)
                print(runData)
            } catch {
                print("error deleting persistent store from Core Data", error.localizedDescription)
            }
        }
    }
    
    func playCoinSound(){
        let audioFilePath = Bundle.main.path(forResource: "coins", ofType: ".m4r")
        let audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)
        do {
            try coinSound = AVAudioPlayer(contentsOf: audioFileUrl)
            coinSound.play()
            coinSound.volume = 1.0
            coinSound.numberOfLoops = 0
        }catch {
            print("error with playing coins.m4r sound")
            
        }
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
                
                let pace = delta / Double(seconds)
                let formatPace = Measurement(value: pace, unit: UnitSpeed.metersPerSecond)
                let topSpeed = Measurement(value: 9.00, unit: UnitSpeed.metersPerSecond)
                
//                if formatPace >= topSpeed {
//                    speedFailSafe()
//                }
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
        let ac = UIAlertController(title: "You're moving too fast!", message: "You've reached speeds above human capabilities! Either, you're in a car or you need to enter the Olympics. Please restart your run.", preferredStyle: .alert)
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

