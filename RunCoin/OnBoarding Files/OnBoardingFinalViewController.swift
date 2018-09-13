//
//  OnBoardingFinalViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 7/30/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit

class OnBoardingFinalViewController: UIViewController {
    
    @IBOutlet weak var NACbutton: UIButton!
    @IBOutlet weak var startRunningButton: UIButton!
    
    let defaults = UserDefaults.standard
    var chosen = false
    
    @IBAction func nationalAbilityButtonPressed(_ sender: UIButton) {
        defaults.setValue(3, forKey: "charity")
        print(defaults.value(forKey: "charity") ?? "NOPE")
        
        
        chosen = !chosen
        
        if chosen == false {
            NACbutton.layer.backgroundColor = UIColor.white.cgColor
            NACbutton.setTitle("Choose Cause", for: .normal)
            NACbutton.setTitleColor(UIColor.offBlue, for: .normal)
            startRunningButton.isHidden = true
        } else {
            NACbutton.setTitleColor(UIColor.white, for: .normal)
            NACbutton.setTitle("Good Choice!", for: .normal)
            NACbutton.layer.backgroundColor = UIColor.offBlue.cgColor
            NACbutton.layer.borderColor = UIColor.white.cgColor
            NACbutton.layer.borderWidth = 2.0
            startRunningButton.isHidden = false
        }
    }
    
    @IBAction func startRunningButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(controller, animated: true, completion: nil)
        defaults.setValue(true, forKey: "onBoardingCompleted")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       NACbutton.layer.cornerRadius = NACbutton.frame.size.height/2
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NACbutton.layer.backgroundColor = UIColor.white.cgColor
        NACbutton.setTitle("Choose Cause", for: .normal)
        NACbutton.setTitleColor(UIColor.offBlue, for: .normal)
        startRunningButton.isHidden = true
    }
}
