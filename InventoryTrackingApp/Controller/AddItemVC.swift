//
//  AddItemVC.swift
//  InventoryTrackingApp
//
//  Created by onur hüseyin çantay on 9.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit

class AddItemVC: BaseVC {
    @IBOutlet weak var stackType : UIStackView!
    @IBOutlet weak var stackName : UIStackView!
    @IBOutlet weak var stackCount : UIStackView!
    @IBOutlet weak var stackPrice : UIStackView!
    @IBOutlet weak var kaydetButton : UIButton!
    @IBOutlet weak var gestureType : UIGestureRecognizer!
    @IBOutlet weak var gestureName : UIGestureRecognizer!
    @IBOutlet weak var gestureCount : UIGestureRecognizer!
    @IBOutlet weak var gesturePrice : UIGestureRecognizer!

    var alertView: UIAlertController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createAlertView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("AddItemVC")
        setRightBarButtonItem()
        setGesturSelectors()
        HideStackVisibilty()
    }
    func setRightBarButtonItem()  {
        let rightButton : UIBarButtonItem = UIBarButtonItem(title: "Tür Ekle", style: .plain, target: self, action: #selector(turEkle))
        self.navItem.setRightBarButton(rightButton, animated: true)
    }
    func turEkle()  {
        self.present(alertView, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func HideStackVisibilty()  {
        self.stackPrice.isHidden = true
        self.stackName.isHidden = true
        self.stackCount.isHidden = true
        self.kaydetButton.isHidden = true
    }
    func setGesturSelectors()  {
        self.gestureType.addTarget(self, action: #selector(turPressed))
        self.gestureName.addTarget(self, action: #selector(namePressed))
        self.gestureCount.addTarget(self, action: #selector(countPressed))
        self.gesturePrice.addTarget(self, action: #selector(pricePressed))
    }
    func turPressed()  {
        self.stackName.isHidden = false
    }
    func namePressed()  {
         self.stackCount.isHidden = false
    }
    func countPressed()  {
         self.stackPrice.isHidden = false
    }
    func pricePressed()  {
        self.kaydetButton.isHidden = false
    }
    func createAlertView(){
        self.alertView = UIAlertController(title: "Tür Ekle", message: "Satın alacağınız demirbaş için tür ekleyiniz.", preferredStyle: .alert)
        alertView.addTextField { (getRoomTextFields) in
            getRoomTextFields.placeholder = "Tür adını giriniz"
        }
        alertView.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        
        let okButtonAction = UIAlertAction(title: "Seç", style: .default) { (alertAction) in
            let textField = self.alertView.textFields?[0] as! UITextField
            print(textField.text)
        }
        
        alertView.addAction(okButtonAction)
    }
}


