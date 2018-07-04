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
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var user = User()
    var delegate : AccountViewControllerDelegate?
    var activeField : UITextField?
    
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
        registerForKeyboardNotifications()
        nameTextField.delegate = self
        emailTextField.delegate = self
        saveButton.isEnabled = false
        saveButton.titleLabel?.isEnabled = false
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
        //textfields
        emailTextField.layer.borderColor = UIColor.coolGrey.cgColor
        nameTextField.layer.borderColor = UIColor.coolGrey.cgColor
        emailTextField.layer.borderWidth = 1.0
        nameTextField.layer.borderWidth = 1.0
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        saveButton.titleLabel?.isEnabled = true
        saveButton.isEnabled = true
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

extension AccountViewController : UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
//        self.scrollView.isScrollEnabled = false
        self.scrollView.contentInset = UIEdgeInsets.zero
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
}
