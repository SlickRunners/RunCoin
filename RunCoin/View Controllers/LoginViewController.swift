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
import Firebase
import FacebookCore
import SwiftyJSON
import FirebaseStorage
import SVProgressHUD
import FirebaseAuth
import FirebaseDatabase
class LoginViewController: UIViewController {
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser != nil {
            SVProgressHUD.show()
            self.performSegue(withIdentifier: "GoToHomeScreen", sender: nil)
        }
        SVProgressHUD.dismiss()
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
}
    
