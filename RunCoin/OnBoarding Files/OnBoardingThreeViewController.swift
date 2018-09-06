//
//  OnBoardingThreeViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 9/2/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit

class OnBoardingThreeViewController: UIViewController {
    
    @IBOutlet weak var imageRebornButton: UIButton!
    @IBOutlet weak var startRunningButton: UIButton!
    
    let defaults = UserDefaults.standard
    var chosen = false
    
    var firstVC : OnBoardingTwoViewController?

    @IBAction func imageRebornButtonPressed(_ sender: UIButton) {
        defaults.setValue(2, forKey: "charity")
        print(defaults.value(forKey: "charity") ?? "NOPE")
        chosen = !chosen
        
        if chosen == false {
            imageRebornButton.layer.backgroundColor = UIColor.white.cgColor
            imageRebornButton.setTitle("Choose Cause", for: .normal)
            imageRebornButton.setTitleColor(UIColor.offBlue, for: .normal)
            startRunningButton.isHidden = true
        } else {
            imageRebornButton.setTitleColor(UIColor.white, for: .normal)
            imageRebornButton.setTitle("Good Choice!", for: .normal)
            imageRebornButton.layer.backgroundColor = UIColor.offBlue.cgColor
            imageRebornButton.layer.borderColor = UIColor.white.cgColor
            imageRebornButton.layer.borderWidth = 2.0
            startRunningButton.isHidden = false
        }
    }
    
    @IBAction func startRunningButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(controller, animated: true, completion: nil)
        defaults.setValue(true, forKey: "onBoardingCompleted")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageRebornButton.layer.cornerRadius = imageRebornButton.frame.size.height/2
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
