//
//  AccountViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 6/6/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    //Variables
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    }

}
