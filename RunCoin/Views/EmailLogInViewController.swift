//
//  ViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 3/7/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit

class EmailLogInViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //variables
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBAction func doneButtonPressed(_ sender: UIButton) {
    }
    
    
    let myPickerData : [String] = ["Male", "Female", "Other"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //pickerview setup
        let myPickerView = UIPickerView()
        genderTextField.inputView = myPickerView
        myPickerView.delegate = self
        
        //textfield style properties
        emailTextField.layer.shadowColor = UIColor.googleGrey.cgColor
        emailTextField.layer.masksToBounds = false
        emailTextField.layer.shadowRadius = 1.0
        emailTextField.layer.shadowOpacity = 0.5
        emailTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        emailTextField.borderStyle = UITextBorderStyle.roundedRect
        emailTextField.adjustsFontSizeToFitWidth = true
        
        //textfield height properties
        emailTextField.widthAnchor.constraint(equalToConstant: 287).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 34).isActive = true
        emailTextField.frame.size.height = 75
        userNameTextField.frame.size.height = 75
        genderTextField.frame.size.height = 75
        birthdayTextField.frame.size.height = 75
        
        emailTextField.frame.size.width = 300
        userNameTextField.frame.size.width = 300
        genderTextField.frame.size.width = 300
        birthdayTextField.frame.size.width = 300
        
        emailTextField.center.x = self.view.center.x
        userNameTextField.center.x = self.view.center.x
        userNameTextField.center.x = self.view.center.x
        genderTextField.center.x = self.view.center.x
        birthdayTextField.center.x = self.view.center.x
        
        //done button attributes
        doneButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        doneButton.backgroundColor = UIColor.coral
        doneButton.layer.cornerRadius = 30
        
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
        self.view.endEditing(true)
        
    }
}


