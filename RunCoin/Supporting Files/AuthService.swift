//
//  AuthService.swift
//  RunCoin
//
//  Created by Roland Christensen on 4/20/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    
    static func signInToAccount(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError("Error logging user into Firebase with existing credentials \(error!.localizedDescription)")
                return
            }
            onSuccess()
        })
    }
    
    
    
    
    
}
