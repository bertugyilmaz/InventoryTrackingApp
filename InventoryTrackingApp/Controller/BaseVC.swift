//
//  BaseVC.swift
//  InventoryTrackingApp
//
//  Created by Bertuğ YILMAZ on 09/12/2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit

class BaseVC: UIViewController{

    var navItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navItem = self.navigationController?.visibleViewController?.navigationItem
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//      self.tabBarController?.tabBar.backgroundColor = Colors.NAVBAR_TABBAR_COLOR
//        self.tabBarController?.tabBar.tintColor =  UIColor.white
//       self.navigationController?.navigationBar.backgroundColor = Colors.NAVBAR_TABBAR_COLOR
//        self.navigationController?.navigationBar.tintColor = UIColor.white
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
//        self.setTabbarAtributes()
        
        self.setLeftBarButton()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func setTabbarAtributes()  {
        self.tabBarController?.tabBar.items![0].title = "Odalar"
        let odaImage = UIImage(named: "home.png")
        self.tabBarController?.tabBar.items![0].image =  odaImage?.scaleImage(width: 30, height: 30, scaleMode: .AspectFill, trim: false)
        self.tabBarController?.tabBar.items![1].title = "Personeller"
        let personelImage = UIImage(named: "Employer.png")
        self.tabBarController?.tabBar.items![1].image = personelImage?.scaleImage(width: 30, height: 30, scaleMode: .AspectFill, trim: false)
        self.tabBarController?.tabBar.items![2].title = "Demirbaş Alımı"
        let demirbasAlımImage = UIImage(named: "Dolar.png")
        self.tabBarController?.tabBar.items![2].image = demirbasAlımImage?.scaleImage(width: 30, height: 30, scaleMode: .AspectFill, trim: false)
        self.tabBarController?.tabBar.items![3].title = "Demirbaş Ataması"
        let demirbasSatımImage = UIImage(named: "arrow.png")
        self.tabBarController?.tabBar.items![3].image = demirbasSatımImage?.scaleImage(width: 30, height: 30, scaleMode: .AspectFill, trim: false)
    }
    
    func setLeftBarButton(){
        let logoutButton = UIButton(type: .custom)
        logoutButton.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        logoutButton.setImage(UIImage(named: "exit-icon"), for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonAction(sender:)), for: .touchUpInside)
        
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        backButton.setImage(UIImage(named: "back-button"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction(sender:)), for: .touchUpInside)
        
        if self.restorationIdentifier == "RoomDetailVC"{
            navItem?.setLeftBarButton(UIBarButtonItem(customView: backButton), animated: false)
        }else {
            navItem?.setLeftBarButton(UIBarButtonItem(customView: logoutButton), animated: false)
        }
    }
    
    func logoutButtonAction(sender: UIButton){
           print("Selam ben logout edicem seni")
    }
    
    func backButtonAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

}
