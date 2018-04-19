//
//  AccountLoginViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 4/18/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import Firebase

class AccountLoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func LoginButtonPressed(_ sender: UIButton) {        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print("Error logging user into Firebase with existing credentials", error!)
                return
            } else {
                self.performSegue(withIdentifier: "GoToStartScreen", sender: self)
            }
        }
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
        let password = passwordTextField.text, !password.isEmpty
            else {
                self.loginButton.isEnabled = false
                self.loginButton.titleLabel?.isEnabled = false
                return
        }
        self.loginButton.isEnabled = true
        self.loginButton.titleLabel?.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
        loginButton.titleLabel?.isEnabled = false
        emailTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
}
