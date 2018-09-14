//
//  RunStatsViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 4/30/18.
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
import MapKit

class RunStatsViewController: UIViewController {

    //Variables
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var charityLabel: UILabel!
    @IBOutlet weak var charityImage: UIImageView!
    
    let defaults = UserDefaults.standard
    var run : Run!
    var passedData : Int!
    var charityName : String!
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "UITabBarController")
        present(homeVC, animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name("NotificationIdentifier"), object: nil)
        var runCount = defaults.integer(forKey: "RUN_COUNT")
        runCount += 1
        defaults.setValue(runCount, forKey: "RUN_COUNT")
        print("runCount value", runCount)
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        guard let image = imageScreenshot(view: mapViewContainer) else {return}
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMap()
        configureCharityImage()
        shareButton.layer.cornerRadius = shareButton.frame.size.height / 2

    }
    
    func imageScreenshot(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot
    }
    
    private func mapRegion() -> MKCoordinateRegion? {
        let locations = run.locations
        if locations.count < 1 {
            return nil
        }
        
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
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        
        return MKCoordinateRegion(center: center, span: span)
    }
    
    private func polyLine() -> [MulticolorPolyline] {
        
        // 1
        let locations = run.locations.array as! [Location]
        var coordinates: [(CLLocation, CLLocation)] = []
        var speeds: [Double] = []
        var minSpeed = Double.greatestFiniteMagnitude
        var maxSpeed = 0.0
        
        // 2
        for (first, second) in zip(locations, locations.dropFirst()) {
            let start = CLLocation(latitude: first.latitude, longitude: first.longitude)
            let end = CLLocation(latitude: second.latitude, longitude: second.longitude)
            coordinates.append((start, end))
            
            //3
            let distance = end.distance(from: start)
            let time = second.timestamp.timeIntervalSince(first.timestamp as Date)
            let speed = time > 0 ? distance / time : 0
            speeds.append(speed)
            minSpeed = min(minSpeed, speed)
            maxSpeed = max(maxSpeed, speed)
        }
        
        //4
        let midSpeed = speeds.reduce(0, +) / Double(speeds.count)
        
        //5
        var segments: [MulticolorPolyline] = []
        for ((start, end), speed) in zip(coordinates, speeds) {
            let coords = [start.coordinate, end.coordinate]
            let segment = MulticolorPolyline(coordinates: coords, count: 2)
            segment.color = segmentColor(speed: speed, midSpeed: midSpeed, slowestSpeed: minSpeed, fastestSpeed: maxSpeed)
            segments.append(segment)
        }
        return segments
    }
    
    
    private func loadMap() {
        let locations = run.locations
        if locations.count > 0 {
            let region = mapRegion()
            mapView.setRegion(region!, animated: true)
            mapView.addOverlays(polyLine())
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Sorry, this run has no locations saved.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
        }
    }
    private func segmentColor(speed: Double, midSpeed: Double, slowestSpeed: Double, fastestSpeed: Double) -> UIColor {
        enum BaseColors {
            static let r_red: CGFloat = 1
            static let r_green: CGFloat = 20 / 255
            static let r_blue: CGFloat = 44 / 255
            
            static let y_red: CGFloat = 1
            static let y_green: CGFloat = 215 / 255
            static let y_blue: CGFloat = 0
            
            static let g_red: CGFloat = 0
            static let g_green: CGFloat = 146 / 255
            static let g_blue: CGFloat = 78 / 255
        }
        
        let red, green, blue: CGFloat
        
        if speed < midSpeed {
            let ratio = CGFloat((speed - slowestSpeed) / (midSpeed - slowestSpeed))
            red = BaseColors.r_red + ratio * (BaseColors.y_red - BaseColors.r_red)
            green = BaseColors.r_green + ratio * (BaseColors.y_green - BaseColors.r_green)
            blue = BaseColors.r_blue + ratio * (BaseColors.y_blue - BaseColors.r_blue)
        } else {
            let ratio = CGFloat((speed - midSpeed) / (fastestSpeed - midSpeed))
            red = BaseColors.y_red + ratio * (BaseColors.g_red - BaseColors.y_red)
            green = BaseColors.y_green + ratio * (BaseColors.g_green - BaseColors.y_green)
            blue = BaseColors.y_blue + ratio * (BaseColors.g_blue - BaseColors.y_blue)
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    func configureCharityImage(){
        let charityInt = defaults.integer(forKey: "charity")
        
        if charityInt == 1 {
            charityName = "The Road Home"
            charityImage.image = UIImage(named: "RoadHome-Choose")
            charityLabel.text = "Nice Job! You've earned \(passedData!) RunCoin for \(charityName!)! Tap below and show off to your friends."
        } else if charityInt == 2 {
            charityName = "The Image Reborn Foundation"
            charityImage.image = UIImage(named: "ImageReborn-Choose")
            charityLabel.text = "Nice Job! You've earned \(passedData!) RunCoin for \(charityName!)! Tap below and show off to your friends."
        } else {
            charityName = "The National Ability Center"
            charityImage.image = UIImage(named: "NAC-Choose")
            charityLabel.text = "Nice Job! You've earned \(passedData!) RunCoin for \(charityName!)! Tap below and show off to your friends."
        }
    }
}

//Extensions
extension RunStatsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MulticolorPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = polyline.color
        renderer.lineWidth = 5
        return renderer
    }
}


