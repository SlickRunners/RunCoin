//
//  ViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 3/7/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import MobileCoreServices
import FirebaseStorage

class EmailLogInViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //variables
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var photoImage: UIImageView!
    var newSelectedImage : UIImage?
    
    //pickerview setup
    let myPickerView = UIPickerView()
    let myPickerData : [String] = ["" ,"Male", "Female", "Other"]
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func uploadPhotoPressed(_ sender: UIButton) {
        let myAlert = UIAlertController(title: "Select a profile image from your phone library.", message: "", preferredStyle: .actionSheet)
        let cameraRollAction = UIAlertAction(title: "Choose photo from", style: .default) { (action) in
            self.handleSelectProfileImage()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        myAlert.addAction(cameraRollAction)
        myAlert.addAction(cancelAction)
        self.present(myAlert, animated: true)
    }
    
    //MARK: -- PickerView DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myPickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myPickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = myPickerData[row]
    }
    @objc func pickerViewDoneButton(){
        genderTextField.resignFirstResponder()
    }
    
    @objc func editingChanged(_ textField: UITextField){
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let username = userNameTextField.text, !username.isEmpty,
            let birthday = birthdayTextField.text, !birthday.isEmpty
            //let gender = genderTextField.text, !gender.isEmpty
            else {
                self.saveButton.isEnabled = false
                self.saveButton.titleLabel?.isEnabled = false
                return
        }
        saveButton.isEnabled = true
        self.saveButton.titleLabel?.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLoginScreen()
        
        saveButton.isEnabled = false
        saveButton.titleLabel?.isEnabled = false
        emailTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        birthdayTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        //genderTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        let photoTapped = UITapGestureRecognizer(target: self, action: #selector(EmailLogInViewController.handleSelectProfileImage))
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
            photoImage.layer.cornerRadius = 68
            photoImage.clipsToBounds = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        saveImageData()
    }
    
    
    fileprivate func setUpLoginScreen() {
        //view attributes
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOpacity = 0.25
        topView.layer.shadowRadius = 5.0
        topView.layer.backgroundColor = UIColor.white.cgColor
        bottomView.layer.backgroundColor = UIColor.white.cgColor
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOpacity = 0.25
        bottomView.layer.shadowRadius = 5.0
        
        //Nav attributes
        title = String("Sign Up")
        navigationItem.largeTitleDisplayMode = .never
        
        genderTextField.inputView = myPickerView
        myPickerView.delegate = self
        myPickerView.showsSelectionIndicator = true
        myPickerView.endEditing(true)
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let donePickingGender = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(pickerViewDoneButton))
        toolBar.setItems([donePickingGender], animated: false)
        toolBar.isUserInteractionEnabled = true
        genderTextField.inputAccessoryView = toolBar
    }
    
    func saveImageData() {
        SVProgressHUD.show()
        if photoImage != newSelectedImage {
            newSelectedImage = UIImage(named: "blankProfileImage")
        }
        if let profileImage = newSelectedImage, let imageData = UIImagePNGRepresentation(profileImage){
            AuthService.signUp(email: emailTextField.text!, username: userNameTextField.text!, password: passwordTextField.text!, imageData: imageData, birthday: birthdayTextField.text!, gender: genderTextField.text!, onSuccess: {
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
    
    func goToHomeScreen(){
        performSegue(withIdentifier: "GoToStartTabController", sender: self)
        SVProgressHUD.dismiss()
    }
    
}
