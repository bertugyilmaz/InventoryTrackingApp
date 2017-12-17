//
//  AddItemVC.swift
//  InventoryTrackingApp
//
//  Created by onur hüseyin çantay on 9.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit

class AddItemVC: BaseVC {
 
    @IBOutlet weak var tableView: UITableView!
    var alertView: UIAlertController!
    var cellArr: [[String]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("AddItemVC")
        self.cellArr = [["Demirbaş Türü", "Demirbaş Adı", "Demirbaş Adedi", "Demirbaş Fiyatı"],
                        ["roomType","itemName","itemCount","search"],
                        ["extended","","",""]]
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        
        self.setRightBarButtonItem()
    }
    
    func setRightBarButtonItem()  {
        let rightButton : UIBarButtonItem = UIBarButtonItem(title: "Tür Ekle", style: .plain, target: self, action: #selector(turEkle))
        self.navItem.setRightBarButton(rightButton, animated: true)
    }
    
    func turEkle()  {
        self.createAlertView(index: -1)
        self.present(alertView, animated: true, completion: nil)
    }
   
    func createAlertView(index: Int){
        
        self.alertView = UIAlertController(title: "Tür Ekle", message: "Satın alacağınız demirbaş için tür ekleyiniz.", preferredStyle: .alert)
        alertView.addTextField { (getRoomTextFields) in
            getRoomTextFields.placeholder = "Tür adını giriniz"
        }
        alertView.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        
        let okButtonAction = UIAlertAction(title: "Seç", style: .default) { (alertAction) in
            let textField = self.alertView.textFields?[0] as! UITextField
            if self.cellArr[2].count - 1 != index && index != -1 {
                self.cellArr[2][index + 1] = "extended"
                print(self.cellArr[2][index])
                self.tableView.reloadData()
            }
            
        }
        
        alertView.addAction(okButtonAction)
    }
}

extension AddItemVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArr[0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cellArr[0][indexPath.row]
        cell.imageView?.image = UIImage(named: cellArr[1][indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cellArr[2][indexPath.row] != "" {
            self.createAlertView(index: indexPath.row)
            
            self.alertView.title = "Seçim Gerçekleştirin"
            self.alertView.message = self.cellArr[0][indexPath.row]
            
            self.present(self.alertView, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if cellArr[2][indexPath.row] == "" {
            return 0
        }else {
            return 60
        }
    }
}


