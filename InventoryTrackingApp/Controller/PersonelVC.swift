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
    var pickerView = UIPickerView()
    var users = [User]()
    var rooms = [Room]()
    var selectedUser = ""
    var alert = Helper.showAlertView(title: "", message: "İşleminiz Başarılı")    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.createAlertView()
        self.getPersonels()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("PersonelVC")
        self.rooms.removeAll()
        self.getRooms()
    }
    
    func getRooms(){
        DataServices.ds.REF_ROOMS.observe(.value, with: { (snapshots) in
            if let snapshot = snapshots.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    
                    if let dict = snap.value as? Dictionary<String,AnyObject>{
                        let id = snap.key
                        let type = dict["RoomType"] as! String
//                        let auth = dict["AuthenticatedPerson"] as! String
                        let name = dict["RoomName"] as! String

                        let room = Room(roomId: id, roomType: type, itemKeys: [], itemCount: "", name: name)
                        self.rooms.append(room)
                    }
                }
            }
        }, withCancel: nil)
    }
    
    func getPersonels()  {
        DataServices.ds.REF_USERS.observe(.value, with: { (snapshots) in
            if let snapshot = snapshots.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if let personelDict = snap.value as? Dictionary<String,AnyObject>{
                        let id = snap.key
                        let username = personelDict["UserName"] as! String
                        let IsAdmin = personelDict["IsAdmin"] as! Bool
                        let name = username.components(separatedBy: "@")[0]
                        let user = User(userId: id, userName: name, isAdmin: IsAdmin)
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

        let textField = self.alertView.textFields?[0] as! UITextField
        textField.inputView = self.pickerView
        
        let okButtonAction = UIAlertAction(title: "Seç", style: .default) { (alertAction) in
            if let textField = self.alertView.textFields?[0] as? UITextField {
                if let inputText = textField.text as? String {
                    let index = self.pickerView.selectedRow(inComponent: 0)
                    
                    DataServices.ds.setEmployer(roomId: self.rooms[index].Id, uId: self.selectedUser)
                    self.present(self.alert, animated: true, completion: nil)
                }
            }
        }
        
        alertView.addAction(okButtonAction)
    }
}
extension PersonelVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PersonelTableViewCell
        let user: User = self.users[indexPath.row]
        
        cell.idLabel.text = user.Id
        cell.nameLabel.text = user.Name
        cell.rooterLabel.text = user.IsAdmin ? "Admin" : "Personel"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user: User = self.users[indexPath.row]
        self.present(alertView, animated: true, completion: nil)
        self.selectedUser = user.Id
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
        if let textField = self.alertView.textFields?[0] as? UITextField {
            textField.text = rooms[row].roomName
        }
        return rooms[row].roomName
    }
}


