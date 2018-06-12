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
    
    @nonobjc class var offBlue: UIColor {
        return UIColor(red: 84.0 / 255.0, green: 109.0 / 255.0, blue: 169.0 / 255.0, alpha: 1.0)
    }
    
}

import UIKit
import GoogleSignIn
import Firebase
import FBSDKLoginKit
import FacebookLogin
import FacebookCore
import SwiftyJSON
import FirebaseStorage
import SVProgressHUD


class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    var name : String?
    var email : String?
    var profilePicture : UIImage?
    
    //Buttons
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToLoginScreen", sender: self)
    }
    @IBOutlet weak var emailLoginPressed: UIButton!
    
    @IBAction func emailLoginPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToEmailSignIn", sender: self)
    }
    //Facebook button
    @IBAction func facebookLoginPressed(_ sender: UIButton) {
        facebookLoginButtonClicked()
    }
    
    @IBAction func googleLoginPressed(_ sender: UIButton) {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        if GIDSignIn.sharedInstance().currentUser == nil {
         GIDSignIn.sharedInstance().signIn()
            }
    }
    
    //    //Google Sign in method
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print("Error logging into Google: \(error.localizedDescription)")
            print("ERROR MOTHER FUCKER")
            return
        }
        guard let googleAuthentication = user.authentication.idToken else { return }
        guard let googleAccessToken = user.authentication.accessToken else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: googleAuthentication,
                                                       accessToken: googleAccessToken)
        // Pass to firebase
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("Failed to create Google/Firebase account: \(error.localizedDescription)")
                return
            }
            // User is signed into firebase using Google
            print("User has successfully logged into Firebase with Google!")
            self.moveToHomeScreen()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser != nil {
            SVProgressHUD.show()
                self.performSegue(withIdentifier: "GoToHomeScreen", sender: nil)
        }
        SVProgressHUD.dismiss()
    }
    
    
    @objc func facebookLoginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile, .email ], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                print("Successfully logged into Facebook.")
                self.signIntoFireBase()
                self.moveToHomeScreen()
            case .failed(let err):
                print(err)
            case .cancelled:
                print("User cancelled facebook login.")
            }
        }
    }
    
    fileprivate func signIntoFireBase() {
        guard let FBAccessToken = AccessToken.current?.authenticationToken else {return}
        let FBCredentials = FacebookAuthProvider.credential(withAccessToken: FBAccessToken)
        Auth.auth().signIn(with: FBCredentials) { (user, error) in
            if let error = error {
                print("Error logging Facebook credentials to Firebase: \(error.localizedDescription)")
                return
            }
            print("Facebook/Firebase authentication successfull")
        }
    }
    
    fileprivate func fetchFacebookUser() {
        let graphRequestConnection = GraphRequestConnection()
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, picture.type(large)"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)
        graphRequestConnection.add(graphRequest) { (httpResponse, result) in
            switch result {
            case .success(response: let response):
                guard let responseDictionary = response.dictionaryValue else { return }
                let json = JSON(responseDictionary)
                self.name = json["name"].string
                self.email = json["email"].string
                guard let profilePictureURL = json["profile"]["data"]["url"].string, let url = URL(string: profilePictureURL) else { return }
        
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, err) in
                    if let err = err {
                        print(err)
                    }
                    guard let data = data else { return }
                    self.profilePicture = UIImage(data: data)
                    self.saveUserIntoFirebase()
                }).resume()
                break
            case .failed(let err):
                print(err)
                break
            }
        }
        graphRequestConnection.start()
    }
    
    
    fileprivate func saveUserIntoFirebase() {
        let fileName = UUID().uuidString
        guard let profilePicture = self.profilePicture else { return }
        guard let uploadData = UIImageJPEGRepresentation(profilePicture, 0.3) else { return }
        Storage.storage().reference().child("profilePictures").child(fileName).putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error)
            }
            print("Succesfully saved profile image to Firebase Storage!")
            metadata?.storageReference?.downloadURL(completion: { (url, error) in
                if error != nil {
                    print("error with Storage reference download URL method")
                }
                let profilePictureURL = url?.absoluteString
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let dictionaryValues = ["name" : self.name, "email" : self.email, "profilePictureURL" : profilePictureURL]
                let values = [uid: dictionaryValues]
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, reference) in
                    if let error = error {
                        print(error)
                        return
                    }
                    print("Succesfully saved user profile image to Firebase!")
                })
            })
        }
    }
    
    func moveToHomeScreen() {
    performSegue(withIdentifier: "GoToHomeScreen", sender: facebookLoginPressed)
    }
    
    func moveToHomeScreenGoogle() {
        performSegue(withIdentifier: "GoToHomeScreen", sender: googleLoginPressed)
    }
    
    fileprivate func setUpViews(){
        //Nav attributes
        title = String("RunCoin")
        navigationController?.navigationBar.prefersLargeTitles = true
        //email login button attributes
        emailLoginPressed.layer.masksToBounds = false
        emailLoginPressed.layer.backgroundColor = UIColor.coral.cgColor
        emailLoginPressed.setTitleColor(UIColor.white, for: .normal)
        //Google login
        GIDSignIn.sharedInstance().uiDelegate = self
    }

}
    
