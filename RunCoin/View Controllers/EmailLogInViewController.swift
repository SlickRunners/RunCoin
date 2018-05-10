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
import Presentr

class EmailLogInViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    //variables
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //Presentr
    let presenter = Presentr(presentationType: .alert)
    
    //pickerview setup
    let myPickerView = UIPickerView()
    let myPickerData : [String] = ["" ,"Male", "Female", "Other"]
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
                self.doneButton.isEnabled = false
                self.doneButton.titleLabel?.isEnabled = false
                return
        }
        doneButton.isEnabled = true
        self.doneButton.titleLabel?.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLoginScreen()
        
        doneButton.isEnabled = false
        doneButton.titleLabel?.isEnabled = false
        emailTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        birthdayTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        //genderTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EnterPhotoViewController {
            let destinationVC = segue.destination as? EnterPhotoViewController
            destinationVC?.emailtext = emailTextField.text
            destinationVC?.usernameText = userNameTextField.text
            destinationVC?.passwordtext = passwordTextField.text
            destinationVC?.birthdayText = birthdayTextField.text
            destinationVC?.genderText = genderTextField.text
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        self.performSegue(withIdentifier: "GoToPhotoPage", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    fileprivate func setUpLoginScreen() {
        //textfield style properties
        emailTextField.layer.shadowColor = UIColor.googleGrey.cgColor
        //emailTextField.layer.masksToBounds = false
        emailTextField.layer.shadowRadius = 1.0
        emailTextField.layer.shadowOpacity = 0.5
        emailTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        emailTextField.borderStyle = UITextBorderStyle.roundedRect
        
        passwordTextField.layer.shadowColor = UIColor.googleGrey.cgColor
        //passwordTextField.layer.masksToBounds = false
        passwordTextField.layer.shadowRadius = 1.0
        passwordTextField.layer.shadowOpacity = 0.5
        passwordTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        passwordTextField.borderStyle = UITextBorderStyle.roundedRect
        
        userNameTextField.layer.shadowColor = UIColor.googleGrey.cgColor
        //userNameTextField.layer.masksToBounds = false
        userNameTextField.layer.shadowRadius = 1.0
        userNameTextField.layer.shadowOpacity = 0.5
        userNameTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        userNameTextField.borderStyle = UITextBorderStyle.roundedRect
        userNameTextField.adjustsFontSizeToFitWidth = true
        
        birthdayTextField.layer.shadowColor = UIColor.googleGrey.cgColor
        birthdayTextField.layer.masksToBounds = false
        birthdayTextField.layer.shadowRadius = 1.0
        birthdayTextField.layer.shadowOpacity = 0.5
        birthdayTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        birthdayTextField.borderStyle = UITextBorderStyle.roundedRect
        birthdayTextField.adjustsFontSizeToFitWidth = true
        
        genderTextField.layer.shadowColor = UIColor.googleGrey.cgColor
        //genderTextField.layer.masksToBounds = false
        genderTextField.layer.shadowRadius = 1.0
        genderTextField.layer.shadowOpacity = 0.5
        genderTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        genderTextField.borderStyle = UITextBorderStyle.roundedRect
        
        //done button attributes
        doneButton.backgroundColor = UIColor.coral
        
        //Nav attributes
        title = String("Set Up Your Profile")
        navigationItem.largeTitleDisplayMode = .never
        
        genderTextField.inputView = myPickerView
        myPickerView.delegate = self
        myPickerView.showsSelectionIndicator = true
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
    
}
