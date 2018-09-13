//
//  OnBoardingOneViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 9/2/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit

class OnBoardingOneViewController: UIViewController {

    @IBOutlet weak var imageRebornImage: UIImageView!
    @IBOutlet weak var NACImage: UIImageView!
    @IBOutlet weak var roadHomeImage: UIImageView!
    @IBOutlet weak var arrowImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        imageRebornImage.center.x -= view.bounds.width
        NACImage.center.x -= view.bounds.width
        roadHomeImage.center.x -= view.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2) {
            self.imageRebornImage.center.x += self.view.bounds.width
        }
        
        UIView.animate(withDuration: 2, delay: 0.7, options: [], animations: {
            self.NACImage.center.x += self.view.bounds.width
        }, completion: nil)
        
        UIView.animate(withDuration: 2, delay: 1.4, options: [], animations: {
            self.roadHomeImage.center.x += self.view.bounds.width
        }, completion: nil)
        
        UIView.animate(withDuration: 0.85, delay: 5.0, options: [.repeat, .autoreverse], animations: {
            self.arrowImage.center.x += 16
            UIView.setAnimationDelay(1.5)
            UIView.setAnimationRepeatCount(4.0)
            UIView.setAnimationRepeatAutoreverses(true)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
