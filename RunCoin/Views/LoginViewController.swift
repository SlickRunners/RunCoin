//
//  LoginViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 3/7/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//
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






import UIKit
import GoogleSignIn
import Firebase
import FBSDKLoginKit
import FacebookLogin


class LoginViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    
    //Buttons
    @IBOutlet weak var emailLoginPressed: UIButton!
    @IBOutlet weak var googleLoginPressed: GIDSignInButton!
    @IBOutlet weak var facebookLoginPressed: FBSDKLoginButton!
    @IBAction func emailLoginPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToEmailSignIn", sender: self)
    }
    //Facebook button
    @IBAction func facebookLoginPressed(_ sender: FBSDKLoginButton) {
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        let FBAccessToken = FBSDKAccessToken.current()
        guard let FBAccessTokenString = FBAccessToken?.tokenString else {return}
        let FBCredentials = FacebookAuthProvider.credential(withAccessToken: FBAccessTokenString)
        Auth.auth().signIn(with: FBCredentials) { (user, error) in
            if error != nil {
                print("Error logging Facebook credentials to Firebase")
                return
            }
             print("Facebook/Firebase authentication successfull")
        }
    }
    //FB LogOUT Button
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log user out of Facebook.")
    }
    //FB LogIN Button
    func loginButton(_ loginButton: FBSDKLoginButton, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Error, FB login failed: \(error.localizedDescription)")
            return
        }
        print("User successfully logged in with Facebook.")
    }
    
    
    @IBAction func googleLoginPressed(_ sender: GIDSignInButton) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Google login
        GIDSignIn.sharedInstance().uiDelegate = self
            //Configure the sign-in button look/feel
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
    
    func moveToHomeScreen() {
    performSegue(withIdentifier: "GoToHomeScreen", sender: facebookLoginPressed)
    }
    
    
    
    //logout unwind segue
    @IBAction func unwindToVCHome(segue:UIStoryboardSegue) { }

}
    
