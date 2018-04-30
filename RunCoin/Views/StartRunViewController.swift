//
//  StartRunViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 3/23/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class StartRunViewController: UIViewController {
    
    //Declared Variables
    private var run : Run?
    @IBOutlet weak var metricsStackView: UIStackView!
    @IBOutlet weak var launchPrompt: UIStackView!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    //Buttons & Actions
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Finished Running?",
                                                message: "Do you want to stop your workout?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.stopRun()
            //self.performSegue(withIdentifier: .details, sender: nil)
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.stopRun()
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        
        present(alertController, animated: true)
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        startRun()
    }
    
    private func startRun() {
        metricsStackView.isHidden = false
        launchPrompt.isHidden = true
        startButton.isHidden = true
        stopButton.isHidden = false
    }
    
    private func stopRun() {
        metricsStackView.isHidden = true
        launchPrompt.isHidden = false
        startButton.isHidden = false
        stopButton.isHidden = true
    }
    
    
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Successfully logged out of Firebase from home screen!")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        goToHomeScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metricsStackView.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToHomeScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(signInVC, animated: true, completion: nil)
    }
    
    
    
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destination = segue.destination as! RunStatsViewController
//
//
//    }
}
