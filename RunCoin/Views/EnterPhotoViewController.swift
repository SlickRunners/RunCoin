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

class EnterPhotoViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    //Variables
    var newPic : Bool?
    var placeHolderImage : UIImageView!
    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var underImageLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var finishProfileButton: UIButton!
    
    @IBAction func finishProfileButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func uploadPhotoPressed(_ sender: UIButton) {
        let myAlert = UIAlertController(title: "Select Image From", message: "", preferredStyle: .actionSheet)
        let cameraRollAction = UIAlertAction(title: "Choose photo from your library.", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                self.newPic = false
            }
        }
        myAlert.addAction(cameraRollAction)
        self.present(myAlert, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            photoImage.image = image
        }
        //photoImage.image = infoPhoto
        dismiss(animated: true, completion: nil)
    }
    
//    finishProfileButton.isHidden = false
//    underImageLabel.text = "But you can always tap to change it."
//    headlineLabel.text = "That's a great look!"
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}


