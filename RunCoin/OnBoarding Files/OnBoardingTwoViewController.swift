//
//  OnBoardingTwoViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 9/2/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit

protocol chooseCharityDelegate {
    func deselectButtons()
}

class OnBoardingTwoViewController: UIViewController {
    
    @IBOutlet weak var roadHomeButton: UIButton!
    @IBOutlet weak var startRunningButton: UIButton!
    
    let defaults = UserDefaults.standard
    var delegate : chooseCharityDelegate?
    
    public var chosen = false
    
    @IBAction func roadHomeButtonPressed(_ sender: UIButton) {
        chosen = !chosen
        defaults.set(1, forKey: "charity")
        print(defaults.value(forKey: "charity") ?? "NOPE")
        if chosen == false {
            roadHomeButton.layer.backgroundColor = UIColor.white.cgColor
            roadHomeButton.setTitle("Choose Cause", for: .normal)
            roadHomeButton.setTitleColor(UIColor.offBlue, for: .normal)
            startRunningButton.isHidden = true
        } else {
            roadHomeButton.setTitleColor(UIColor.white, for: .normal)
            roadHomeButton.setTitle("Good Choice!", for: .normal)
            roadHomeButton.layer.backgroundColor = UIColor.offBlue.cgColor
            roadHomeButton.layer.borderColor = UIColor.white.cgColor
            roadHomeButton.layer.borderWidth = 2.0
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
        roadHomeButton.layer.cornerRadius = roadHomeButton.frame.size.height/2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func deselectButton(){
        chosen = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        roadHomeButton.layer.backgroundColor = UIColor.white.cgColor
        roadHomeButton.setTitle("Choose Cause", for: .normal)
        roadHomeButton.setTitleColor(UIColor.offBlue, for: .normal)
        startRunningButton.isHidden = true
    }
}
