//
//  PersonelVC.swift
//  InventoryTrackingApp
//
//  Created by onur hüseyin çantay on 9.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit

class PersonelVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var alertView: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.createAlertView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("PersonelVC")
    }
    
    func createAlertView(){
        self.alertView = UIAlertController(title: "Oda Seçimi", message: "Atamak istediğiniz odayı yazınız.", preferredStyle: .alert)
        alertView.addTextField { (getRoomTextFields) in
            getRoomTextFields.placeholder = "Oda seçiniz"
        }
        alertView.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
//        pickerView oluştulucak, Firebase den çekilen odalar set edilecek
//        let textField = self.alertView.textFields?[0] as! UITextField
//        textField.inputView = UIPickerView()
        
        let okButtonAction = UIAlertAction(title: "Seç", style: .default) { (alertAction) in
            let textField = self.alertView.textFields?[0] as! UITextField
            print(textField.text)
        }
        
        alertView.addAction(okButtonAction)
    }
}
extension PersonelVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PersonelTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.present(alertView, animated: true, completion: nil)
    }
}


