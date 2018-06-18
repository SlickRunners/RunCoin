//
//  ForgotPasswordViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 6/15/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func sendEmailPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        AuthService.sendPasswordReset(email: emailTextField.text!, onSuccess: {
            let alert = UIAlertController(title: "Check your email.", message: "We've sent you a verification email. Please check your email to reset your password.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            SVProgressHUD.dismiss()
            self.present(alert, animated: true)
        }) { (error) in
            let alert = UIAlertController(title: "Email not recognized.", message: "It doesn't appear that this email currently has an account with RunCoin. Please check your email for typos or create a new RunCoin account.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
            SVProgressHUD.dismiss()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.layer.borderColor = UIColor.coolGrey.cgColor
        emailTextField.layer.borderWidth = 1.0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
