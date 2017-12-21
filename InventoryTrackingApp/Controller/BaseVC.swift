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
    var activityController: UIActivityViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navItem = self.navigationController?.visibleViewController?.navigationItem
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if(self.title != "Demirbaş Alımı"){
            self.navItem.rightBarButtonItem = nil
        }
        self.navItem.title = self.title
        self.setLeftBarButton()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func setLeftBarButton(){
        
        if self.restorationIdentifier == "RoomDetailVC"{
            navItem?.setLeftBarButton(UIBarButtonItem(customView: self.createButton(img: "back-button", action: #selector(backButtonAction(sender:)))), animated: false)
            navItem.setRightBarButton(UIBarButtonItem(customView: self.createButton(img: "print-icon", action: #selector(printButtonAction(sender:)))), animated: false)
        }else {
            navItem?.setLeftBarButton(UIBarButtonItem(customView: self.createButton(img: "exit-icon", action: #selector(logoutButtonAction(sender:)))), animated: false)
        }
    }

    func logoutButtonAction(sender: UIButton){
        UserDefaults.standard.removeObject(forKey: "userDict")
        self.navigationController?.popViewController(animated: true)    
    }
    
    func backButtonAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func printButtonAction(sender: UIButton){
        print("Selam ben print edicem seni")
        self.activityController = UIActivityViewController(activityItems: [], applicationActivities: nil)
        self.activityController.popoverPresentationController?.sourceView = self.view
        self.activityController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        self.present(self.activityController, animated: true, completion: nil)
    }
    
    func createButton(img: String, action: Selector )-> UIButton{
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        button.setImage(UIImage(named:img), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

}
