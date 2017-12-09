//
//  ViewController.swift
//  InventoryTracingApp
//
//  Created by onur hüseyin çantay on 8.12.2017.
//  Copyright © 2017 onur hüseyin çantay. All rights reserved.
//

import UIKit

class LoginVC : BaseVC {
    @IBOutlet weak var userName : UITextField!
    
    @IBOutlet weak var loginButton: roundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        loginButton.addTarget(self, action: #selector(loginButtonAction(sender:)), for: .touchUpInside)
    }
    
    func loginButtonAction(sender: roundedButton){
        let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainTabbarVC")
        self.navigationController?.pushViewController(mainVC!, animated: true)
    }
}

