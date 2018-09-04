//
//  CharitySettingsViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 9/2/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import ProgressHUD

class CharitySettingsViewController: UIViewController {
    
    @IBOutlet weak var roadHomeButton: UIButton!
    @IBOutlet weak var imageRebornButton: UIButton!
    @IBOutlet weak var NACButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    @IBAction func charityButtonPressed(_ sender: UIButton) {
        ProgressHUD.show()
        if sender.tag == 1 {
            defaults.setValue(1, forKey: "charity")
            let charity1 = defaults.integer(forKey: "charity")
            print(charity1, "ROAD HOME")
            changeRoadState()
        } else if sender.tag == 2 {
            defaults.setValue(2, forKey: "charity")
            let charity2 = defaults.integer(forKey: "charity")
            print(charity2, "IMAGE REBORN")
            changeImageState()
        } else if sender.tag == 3 {
            defaults.setValue(3, forKey: "charity")
            let charity3 = defaults.integer(forKey: "charity")
            print(charity3, "NAC")
            changeNACState()
        }
        ProgressHUD.showSuccess("Success!")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonRadius()
        configureButtons()
        
        // Do any additional setup after loading the view.
    }

    
    func configureButtons(){
        if defaults.integer(forKey: "charity") == 1 {
            roadHomeButton.layer.borderColor = UIColor.offBlue.cgColor
            roadHomeButton.layer.borderWidth = 2.0
            roadHomeButton.setTitle("Current", for: .normal)
            roadHomeButton.setTitleColor(UIColor.offBlue, for: .normal)
            roadHomeButton.layer.backgroundColor = UIColor.white.cgColor
        } else if defaults.integer(forKey: "charity") == 2 {
            imageRebornButton.layer.borderColor = UIColor.offBlue.cgColor
            imageRebornButton.layer.borderWidth = 2.0
            imageRebornButton.setTitle("Current", for: .normal)
            imageRebornButton.setTitleColor(UIColor.offBlue, for: .normal)
            imageRebornButton.layer.backgroundColor = UIColor.white.cgColor
        } else {
            NACButton.layer.borderColor = UIColor.offBlue.cgColor
            NACButton.layer.borderWidth = 2.0
            NACButton.setTitle("Current", for: .normal)
            NACButton.setTitleColor(UIColor.offBlue, for: .normal)
            NACButton.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    
    func normalButtonStates(){
        roadHomeButton.layer.borderColor = UIColor.white.cgColor
        roadHomeButton.layer.borderWidth = 2.0
        roadHomeButton.setTitle("Choose", for: .normal)
        roadHomeButton.setTitleColor(UIColor.white, for: .normal)
        roadHomeButton.layer.backgroundColor = UIColor.offBlue.cgColor
        
        imageRebornButton.layer.borderColor = UIColor.white.cgColor
        imageRebornButton.layer.borderWidth = 2.0
        imageRebornButton.setTitle("Choose", for: .normal)
        imageRebornButton.setTitleColor(UIColor.white, for: .normal)
        imageRebornButton.layer.backgroundColor = UIColor.offBlue.cgColor
        
        NACButton.layer.borderColor = UIColor.white.cgColor
        NACButton.layer.borderWidth = 2.0
        NACButton.setTitle("Choose", for: .normal)
        NACButton.setTitleColor(UIColor.white, for: .normal)
        NACButton.layer.backgroundColor = UIColor.offBlue.cgColor
    }
    
    func changeRoadState(){
        normalButtonStates()
        roadHomeButton.layer.borderColor = UIColor.offBlue.cgColor
        roadHomeButton.layer.borderWidth = 2.0
        roadHomeButton.setTitle("Current", for: .normal)
        roadHomeButton.setTitleColor(UIColor.offBlue, for: .normal)
        roadHomeButton.layer.backgroundColor = UIColor.white.cgColor
    }
    
    func changeImageState(){
        normalButtonStates()
        imageRebornButton.layer.borderColor = UIColor.offBlue.cgColor
        imageRebornButton.layer.borderWidth = 2.0
        imageRebornButton.setTitle("Current", for: .normal)
        imageRebornButton.setTitleColor(UIColor.offBlue, for: .normal)
        imageRebornButton.layer.backgroundColor = UIColor.white.cgColor
    }
    
    func changeNACState(){
        normalButtonStates()
        NACButton.layer.borderColor = UIColor.offBlue.cgColor
        NACButton.layer.borderWidth = 2.0
        NACButton.setTitle("Current", for: .normal)
        NACButton.setTitleColor(UIColor.offBlue, for: .normal)
        NACButton.layer.backgroundColor = UIColor.white.cgColor
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonRadius(){
        roadHomeButton.layer.cornerRadius = roadHomeButton.frame.size.height/2
        imageRebornButton.layer.cornerRadius = imageRebornButton.frame.size.height/2
        NACButton.layer.cornerRadius = NACButton.frame.size.height/2
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
