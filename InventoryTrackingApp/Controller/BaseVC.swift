//
//  BaseVC.swift
//  InventoryTrackingApp
//
//  Created by Bertuğ YILMAZ on 09/12/2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit

class BaseVC: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      self.tabBarController?.tabBar.backgroundColor = Colors.NAVBAR_TABBAR_COLOR
        self.tabBarController?.tabBar.tintColor =  UIColor.white
       self.navigationController?.navigationBar.backgroundColor = Colors.NAVBAR_TABBAR_COLOR
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.setNavbarAtributes()
        
    }
    func setNavbarAtributes()  {
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
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }


}
