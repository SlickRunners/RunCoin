//
//  LoginViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 3/7/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FacebookLogin
import FBSDKLoginKit


extension UIColor {
    
    @nonobjc class var greenyBlue: UIColor {
        return UIColor(red: 73.0 / 255.0, green: 196.0 / 255.0, blue: 186.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var brownishGrey: UIColor {
        return UIColor(white: 104.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var lipstick: UIColor {
        return UIColor(red: 227.0 / 255.0, green: 31.0 / 255.0, blue: 55.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var apple: UIColor {
        return UIColor(red: 158.0 / 255.0, green: 210.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var whiteTwo: UIColor {
        return UIColor(white: 223.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var white: UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
    }
    
    @nonobjc class var greyish: UIColor {
        return UIColor(white: 164.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var black: UIColor {
        return UIColor(white: 0.0, alpha: 1.0)
    }
    
    @nonobjc class var coral: UIColor {
        return UIColor(red: 253.0 / 255.0, green: 87.0 / 255.0, blue: 55.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var midBlue: UIColor {
        return UIColor(red: 37.0 / 255.0, green: 83.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var black12: UIColor {
        return UIColor(white: 0.0, alpha: 0.12)
    }
    
    @nonobjc class var buttonShadow: UIColor {
        return UIColor(white: 0.0, alpha: 0.24)
    }
    
    @nonobjc class var googleGrey: UIColor {
        return UIColor(white: 0.0, alpha: 0.54)
    }
    
}


class LoginViewController: UIViewController, GIDSignInUIDelegate {
    //Buttons
    @IBOutlet weak var emailLoginPressed: UIButton!
    @IBOutlet weak var googleLoginPressed: GIDSignInButton!
    @IBOutlet weak var facebookLoginPressed: UIButton!
    @IBAction func emailLoginPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToEmailSignIn", sender: self)
    }
    
    @IBAction func facebookLoginPressed(_ sender: UIButton) {
    }
    
    @IBAction func googleLoginPressed(_ sender: GIDSignInButton) {
        GIDSignIn.sharedInstance().signIn()
        performSegue(withIdentifier: "GoToHomeScreen", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Google login
        GIDSignIn.sharedInstance().uiDelegate = self
            //Configure the sign-in button look/feel
        googleLoginPressed.style = .wide
            // Uncomment to automatically sign in the user.
            //GIDSignIn.sharedInstance().signInSilently()
        
        //Nav attributes
        title = String("RunCoin")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //email login button attributes
        emailLoginPressed.layer.masksToBounds = false
        emailLoginPressed.layer.backgroundColor = UIColor.coral.cgColor
        emailLoginPressed.setTitleColor(UIColor.white, for: .normal)
    }
    
}
    
