//
//  PersonelVC.swift
//  InventoryTrackingApp
//
//  Created by onur hüseyin çantay on 9.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit
import Firebase

class PersonelVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var alertView: UIAlertController!
    var users = [User]()
    var rooms = [Room]()
    
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
    func getPersonels()  {
        DataServices.ds.REF_USERS.observe(.value, with: { (snapshots) in
            if let snapshot = snapshots.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if let personelDict = snap.value as? Dictionary<String,AnyObject>{
                        let id = snap.key
                        let username = personelDict["UserName"] as! String
                        let IsAdmin = personelDict["IsAdmin"] as! Int
                        let name = username.components(separatedBy: "@")[0]
                        let user = User(userId: id, userName: name, isAdmin: IsAdmin == 0 ? false : true)
                        self.users.append(user)
                    }
                }
            }
        }, withCancel: nil)
    }
    func createAlertView(){
        self.alertView = UIAlertController(title: "Oda Seçimi", message: "Atamak istediğiniz odayı yazınız.", preferredStyle: .alert)
        alertView.addTextField { (getRoomTextFields) in
            getRoomTextFields.placeholder = "Oda seçiniz"
        }
        alertView.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
//        pickerView oluştulucak, Firebase den çekilen odalar set edilecek
        let textField = self.alertView.textFields?[0] as! UITextField
        textField.inputView = UIPickerView()
        
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
extension PersonelVC: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rooms.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rooms[row].roomName
    }
    
    
}


