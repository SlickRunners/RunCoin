//
//  EnterPhotoViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 3/21/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import MobileCoreServices
import FirebaseStorage
import SVProgressHUD
import Firebase

class EnterPhotoViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    //Variables
    var newSelectedImage : UIImage?
    var placeHolderImage : UIImageView!
    var emailtext : String?
    var passwordtext : String?
    var usernameText : String?
    var birthdayText : String?
    var genderText : String?
    
    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var underImageLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var finishProfileButton: UIButton!
    
    @IBAction func finishProfileButtonPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        if let profileImage = self.newSelectedImage, let imageData = UIImageJPEGRepresentation(profileImage, 0.1){
            AuthService.signUp(email: emailtext!, username: usernameText!, password: passwordtext!, imageData: imageData, birthday: birthdayText!, gender: genderText!, onSuccess: {
                print("Successful creation of firebase user.")
                self.goToHomeScreen()
            }, onError: { (errorString) in
                print("Error creating firebase user", errorString!)
                SVProgressHUD.dismiss()
                let alertController = UIAlertController(title: "Invalid Email and/or Password", message: "Please enter a valid email. Password must be at least 6 characters.", preferredStyle: .alert)
                let alertActionTest = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertActionTest)
                self.present(alertController, animated: true)
                return
            })
        }
    }
    
    @IBAction func uploadPhotoPressed(_ sender: UIButton) {
        let myAlert = UIAlertController(title: "Select Image From", message: "", preferredStyle: .actionSheet)
        let cameraRollAction = UIAlertAction(title: "Choose photo from your library.", style: .default) { (action) in
            self.handleSelectProfileImage()
        }
        myAlert.addAction(cameraRollAction)
        self.present(myAlert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //photo properties
        photoImage.layer.cornerRadius = 75
        photoImage.clipsToBounds = true
        
        //button attributes
        uploadPhotoButton.layer.backgroundColor = UIColor.coral.cgColor
        finishProfileButton.isHidden = true
        
        let photoTapped = UITapGestureRecognizer(target: self, action: #selector(EnterPhotoViewController.handleSelectProfileImage))
        photoImage.isUserInteractionEnabled = true
        photoImage.addGestureRecognizer(photoTapped)
    }
    
    @objc func handleSelectProfileImage(){
        SVProgressHUD.show()
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            newSelectedImage = image
            photoImage.image = image
        }
        dismiss(animated: true, completion: nil)
        finishProfileButton.isHidden = false
        underImageLabel.text = "But you can always tap to change it."
        headlineLabel.text = "That's a great look!"
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func goToHomeScreen(){
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "HomeScreen") as! StartRunViewController
        let navController = UINavigationController(rootViewController: VC1)
        self.present(navController, animated:true, completion: nil)
        SVProgressHUD.dismiss()
    }

}
