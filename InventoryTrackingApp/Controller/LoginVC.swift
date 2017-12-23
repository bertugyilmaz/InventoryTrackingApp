//
//  ViewController.swift
//  InventoryTracingApp
//
//  Created by onur hüseyin çantay on 8.12.2017.
//  Copyright © 2017 onur hüseyin çantay. All rights reserved.
//

import UIKit

class LoginVC : BaseVC {
    
    var userInfo: User!
    @IBOutlet weak var userNameTextField: loginTextFields!
    @IBOutlet weak var passwordTextField: loginTextFields!
    
    @IBOutlet weak var loginButton: roundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loggedinBefore()
        
        loginButton.addTarget(self, action: #selector(loginButtonAction(sender:)), for: .touchUpInside)

//        Test için kullanıcı oluşturuldu.
//        DataServices.ds.FIR_AUTH.createUser(withEmail: "ylmazbertug@gmail.com", password: "test123", completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        userNameTextField.text = ""
        passwordTextField.text = ""
    }
    
    func loginButtonAction(sender: roundedButton){
        let uName = userNameTextField.text!
        let passw = passwordTextField.text!
        
        self.checkUserOnFirebase(userName: uName , password: passw) { (success) in
            if !success {
               self.present(Helper.showAlertView(title: "Hata!", message: "Eksik veya yanlış bir değer girdiniz."), animated: true, completion: nil)
            }
        }
    }
    func checkUserOnFirebase(userName: String, password: String, completion: @escaping (Bool)->()){
        
        DataServices.ds.FIR_AUTH.signIn(withEmail: userName, password: password, completion: { (user, error) in
            
            if error != nil {
                completion(false)
            }
            
            if let usr = user {
                
                self.userInfo = User(userId: usr.uid, userName: usr.email!, isAdmin: true)
                
                self.setUserInfoOnUserDefaults()
             
//                Veritabanına kayıt edildi.
//                DataServices.ds.createFirebaseUser(uid: usr.uid, userData: self.userInfo.exportDictionary())
                
                let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainTabbarVC")
                self.navigationController?.pushViewController(mainVC!, animated: true)
                
                completion(true)
            }
        })
    }
    
    func setUserInfoOnUserDefaults(){
        print(self.userInfo.Id)
        UserDefaults.standard.set(self.userInfo.Id, forKey: "userId")
        UserDefaults.standard.set(self.userInfo.Name, forKey: "userEmail")
    }
    
    func loggedinBefore(){
        if UserDefaults.standard.value(forKey: "userId") != nil {
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainTabbarVC")
            self.navigationController?.pushViewController(mainVC!, animated: true)
        }else {
            print("agaaa daha önce girmemişsinn")
        }
    }
}

