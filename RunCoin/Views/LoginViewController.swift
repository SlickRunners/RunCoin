//
//  LoginViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 3/7/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit


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


class LoginViewController: UIViewController {
    @IBOutlet weak var emailLoginPressed: UIButton!
    @IBOutlet weak var googleLoginPressed: UIButton!
    @IBOutlet weak var facebookLoginPressed: UIButton!
    
    //MARK -- Buttons & Variables
    @IBAction func emailLoginPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToEmailSignIn", sender: self)
    }
    
    @IBAction func facebookLoginPressed(_ sender: UIButton) {
    }
    
    @IBAction func googleLoginPressed(_ sender: UIButton) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Google button attributes
        googleLoginPressed.setTitleColor(UIColor.googleGrey, for: .normal)
        googleLoginPressed.layer.shadowRadius = 3.0
        googleLoginPressed.layer.shadowColor = UIColor.black.cgColor
        googleLoginPressed.layer.backgroundColor = UIColor.white.cgColor
        googleLoginPressed.layer.shadowColor = UIColor.black.cgColor
        googleLoginPressed.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        googleLoginPressed.layer.masksToBounds = false
        googleLoginPressed.layer.shadowRadius = 1.0
        googleLoginPressed.layer.shadowOpacity = 0.5
        
        //Facebook button attributes
        facebookLoginPressed.layer.shadowRadius = 3.0
        facebookLoginPressed.layer.shadowColor = UIColor.black.cgColor
        facebookLoginPressed.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        facebookLoginPressed.layer.masksToBounds = false
        facebookLoginPressed.layer.shadowRadius = 1.0
        facebookLoginPressed.layer.shadowOpacity = 0.5
        facebookLoginPressed.layer.shadowRadius = 1.0
        
        // eMail button attributes
        emailLoginPressed.layer.shadowRadius = 1.0
        emailLoginPressed.layer.shadowColor = UIColor.black.cgColor
        emailLoginPressed.layer.masksToBounds = false
        emailLoginPressed.layer.shadowOpacity = 0.5
        emailLoginPressed.layer.cornerRadius = 24
        emailLoginPressed.layer.backgroundColor = UIColor.coral.cgColor
        emailLoginPressed.setTitleColor(UIColor.white, for: .normal)
        emailLoginPressed.layer.shadowColor = UIColor.black.cgColor
        emailLoginPressed.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
}
    
