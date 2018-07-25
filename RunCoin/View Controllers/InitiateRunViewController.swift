//
//  InitiateRunViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 5/16/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class InitiateRunViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var sumPastRuns : Double!
    
    @IBAction func startButton(_ sender: UIButton) {
        performSegue(withIdentifier: "StartRun", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = .mutedStandard
        mapView.showsUserLocation = true
        fetchPastRunData()
    }
    
    func fetchPastRunData(){
        var pastRunDistance : [Double] = []
        let request = Run.createFetchRequest()
        let sort = NSSortDescriptor(key: "timestamp", ascending: false)
        request.sortDescriptors = [sort]
        do {
            let pastRuns = try CoreDataStack.context.fetch(request)
            for data in pastRuns {
                pastRunDistance.append(data.distance)
                
            }
        } catch let error as NSError{
            print("error with fetch request for pastRunData", error.localizedDescription)
        }
        
        let filteredData = pastRunDistance.filter{$0 != 0.0}
        print("filtered distance data", filteredData)
        
        let runCoinDistance = 1000.00
        
        sumPastRuns = pastRunDistance.reduce(0) { (x, y) -> Double in
            x + y
        }
        print("Sum of past runs", sumPastRuns)
        
        if sumPastRuns > runCoinDistance {
            let fetchRunRequest = Run.fetchRequest()
            let fetchLocationRequst = Location.fetchRequest()
            let batchLocationRequest = NSBatchDeleteRequest(fetchRequest: fetchLocationRequst)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRunRequest)
            do {
                try CoreDataStack.context.execute(batchDeleteRequest)
                try CoreDataStack.context.execute(batchLocationRequest)
                CoreDataStack.context.automaticallyMergesChangesFromParent = true
                CoreDataStack.saveContext()
            } catch {
                print("error deleting persistent store from Core Data", error.localizedDescription)
            }
            CoreDataStack.context.refreshAllObjects()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartRun" {
            let destinationVC = segue.destination as! StartRunViewController
            destinationVC.sumPastRunDistance = sumPastRuns
        }
    }
}
