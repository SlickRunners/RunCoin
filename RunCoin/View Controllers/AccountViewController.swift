//
//  AccountViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 6/6/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

protocol AccountViewControllerDelegate {
    func updateUserInformation()
}


class AccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //Variables
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var user = User()
    var delegate : AccountViewControllerDelegate?
    
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
        fetchCurrentUser()
        nameTextField.delegate = self
        emailTextField.delegate = self
    }
    
    func fetchCurrentUser(){
        Api.User.oberserveCurrentUser { (user) in
            self.userNameLabel.text = user.username
            self.nameTextField.text = user.username
            self.emailTextField.text = user.email
            
            if let photoUrl = URL(string: user.profileImageUrl!) {
                self.profilePhoto.sd_setImage(with: photoUrl)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            profilePhoto.image = image
            profilePhoto.layer.cornerRadius = 65
            profilePhoto.clipsToBounds = true
        }
        dismiss(animated: true, completion: nil)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        AuthService.logout(onSuccess: {
            self.performSegue(withIdentifier: "unwindToLogin", sender: self)
        }) { (error) in
            if error != nil {
                return
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        if let profileImage = profilePhoto.image {
            let profileImageData = UIImagePNGRepresentation(profileImage)
            AuthService.updateUserInfo(email: emailTextField.text!, username: nameTextField.text!, profileImageData: profileImageData!, onSuccess: {
                SVProgressHUD.dismiss()
                self.delegate?.updateUserInformation()
                print("successfully updated user info data and stuff")
            }) { (errorString) in
                if errorString != nil {
                    print(errorString!)
                    SVProgressHUD.dismiss()
                    return
                }
            }
        }
    }
}

extension AccountViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
