//
//  AccountViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 6/6/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import SVProgressHUD
import FirebaseDatabase
import FirebaseAuth

class AccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //Variables
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var user = User()
    var newSelectedImage : UIImage?
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose new profile photo.", message: "Pick a new photo from your photo library.", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Choose a new profile image.", style: .default) { (action) in
            self.handleSelectProfileImage()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadUserData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadUserData(){
        guard let currentUser = Auth.auth().currentUser else {return}
        let uid = currentUser.uid
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let profileImage = value?["profileImageUrl"] as? String ?? ""
            let imageUrl = URL(string: profileImage)
            self.profilePhoto.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "blankProfileImage"))
            print(username)
            self.userNameLabel.text = username
            
        }
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
            profilePhoto.image = image
            profilePhoto.layer.cornerRadius = 68
            profilePhoto.clipsToBounds = true
        }
        dismiss(animated: true, completion: nil)
        saveImageData()
    }
    
    func setupView(){
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowRadius = 5.0
        bottomView.layer.shadowOpacity = 0.25
        bottomView.layer.backgroundColor = UIColor.white.cgColor
        topView.layer.backgroundColor = UIColor.white.cgColor
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowRadius = 5.0
        topView.layer.shadowOpacity = 0.25
        //textfields
        emailTextField.layer.borderColor = UIColor.coolGrey.cgColor
        nameTextField.layer.borderColor = UIColor.coolGrey.cgColor
        emailTextField.layer.borderWidth = 1.0
        nameTextField.layer.borderWidth = 1.0
    }
    
    func saveImageData() {
        if profilePhoto != newSelectedImage {
            newSelectedImage = UIImage(named: "blankProfileImage")
        }
        if let profileImage = newSelectedImage, let imageData = UIImagePNGRepresentation(profileImage){
            guard let currentUser = Auth.auth().currentUser else {return}
            let uid = currentUser.uid
            let storageRef = Storage.storage().reference().child("profile_image").child(uid)
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if error != nil {
                    return
                }
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        return
                    }
                    guard let downloadedUrl = url else {return}
                    let profileUrlString = downloadedUrl.absoluteString
                    self.updateProfileImage(imageUrl: profileUrlString)
                })
                print("Done editing and updating user profile photo.")
            }
        }
    }
    
    
    func updateProfileImage(imageUrl: String){
        guard let currentUser = Auth.auth().currentUser else {return}
        let uid = currentUser.uid
        let databaseRef = Database.database().reference().child("profileImageUrl").child(uid)
        databaseRef.updateChildValues(["profileImageUrl": imageUrl])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "unwindToLogin", sender: self)
        }
        catch {
            print("Error logging out of Firebase.")
        }
    }
}
