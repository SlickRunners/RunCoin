//
//  EnterPhotoViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 3/21/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import MobileCoreServices

class EnterPhotoViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    //Variables
    var newPic : Bool?
    var placeHolderImage : UIImageView!
    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var photoImage: UIImageView!
    
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
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let newImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            photoImage.image = newImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //button attributes
        uploadPhotoButton.layer.backgroundColor = UIColor.coral.cgColor
    }
}


