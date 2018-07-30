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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
