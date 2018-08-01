//
//  OnBoardingFinalViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 7/30/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit

class OnBoardingFinalViewController: UIViewController {

    @IBAction func buttonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ExitOnBoarding", sender: self)
        UserDefaults.standard.setValue(true, forKey: "onBoardingCompleted")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
