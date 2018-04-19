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
    var firebaseUserID: String?
    
    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var underImageLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var finishProfileButton: UIButton!
    
    @IBAction func finishProfileButtonPressed(_ sender: UIButton) {
        let userID = firebaseUserID
        let storageRef = Storage.storage().reference(forURL: "gs://runcoin-c565b.appspot.com").child("profile_image").child(userID!)
        if let profileImage = newSelectedImage, let imageData = UIImageJPEGRepresentation(profileImage, 0.1){
            storageRef.putData(imageData, metadata: nil
                , completion: { (metaData, error) in
                    if error != nil {
                        print("There was an error saving user's profile image to Firebase:", error!)
                        return
                    }
                    let ref = Database.database().reference()
                    let userRef = ref.child("users")
                    let newUserRef = userRef.child(userID!)
                    let profileImageURL = metaData?.downloadURL()?.absoluteString
                    
                    newUserRef.value
                    //newUserRef.updateChildValues(["profile_image" : profileImageURL!])
                    //newUserRef.setValue(["profileImageUrl": profileImageURL])
            })
        }
        
    }
    
//    @IBAction func uploadPhotoPressed(_ sender: UIButton) {
//        let myAlert = UIAlertController(title: "Select Image From", message: "", preferredStyle: .actionSheet)
//        let cameraRollAction = UIAlertAction(title: "Choose photo from your library.", style: .default) { (action) in
//
//        }
//        myAlert.addAction(cameraRollAction)
//        self.present(myAlert, animated: true)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("successful pass of uid", firebaseUserID!)
        //button attributes
        uploadPhotoButton.layer.backgroundColor = UIColor.coral.cgColor
        finishProfileButton.isHidden = true
        
        let photoTapped = UITapGestureRecognizer(target: self, action: #selector(EnterPhotoViewController.handleSelectProfileImage))
        photoImage.isUserInteractionEnabled = true
        photoImage.addGestureRecognizer(photoTapped)
    }
    
    @objc func handleSelectProfileImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            newSelectedImage = image
            photoImage.image = image
        }
        //photoImage.image = infoPhoto
        dismiss(animated: true, completion: nil)
        finishProfileButton.isHidden = false
        underImageLabel.text = "But you can always tap to change it."
        headlineLabel.text = "That's a great look!"
    }
    
    //    finishProfileButton.isHidden = false
    //    underImageLabel.text = "But you can always tap to change it."
    //    headlineLabel.text = "That's a great look!"
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


