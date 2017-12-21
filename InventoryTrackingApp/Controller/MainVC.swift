//
//  MainVC.swift
//  InventoryTrackingApp
//
//  Created by onur hüseyin çantay on 9.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit

class MainVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    var Rooms = [Room]()
    var alertView : UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
//        Database e örnek data eklendi
//        let standartUser = UserDefaults.standard.value(forKey: "userId")
//        let room = Room(roomId: "123123123", roomType: "Yemekhane", itemKeys: [], itemCount: "")
//        room.AuthenticatedPerson = User(userId: standartUser as! String  , userName: "Bertuğ")
//        DataServices.ds.addRoom(roomData: room.exportDictionary())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.Rooms = [Room]()
        self.getRooms()
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRoom(sender:)))
        self.navItem.setRightBarButton(rightButton, animated: true)
    }

    func addRoom(sender: UIBarButtonItem) {
        self.CreateAlertForAddRoom()
        self.present(self.alertView, animated: true, completion: nil)
    }
    
    func CreateAlertForAddRoom()  {
        self.alertView = UIAlertController(title: "Oda Ekle", message: "Ekleyeceğiniz oda bilgilerini giriniz.", preferredStyle: .alert)
        alertView.addTextField { (textfield) in
            textfield.placeholder = "Oda Adını Giriniz"
        }
        alertView.addTextField { (texfield) in
            texfield.placeholder = "Oda Tipini Giriniz"
        }
        alertView.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        
        let okButtonAction = UIAlertAction(title: "Seç", style: .default) { (alertAction) in
            if let textField = self.alertView.textFields?[0] as? UITextField {
                if let txt = textField.text as? String{
                    if txt.isEmpty{
                        self.present(Helper.showAlertView(title: "Eksik Bilgi", message: "Tüm alanları doldurunuz"), animated: true, completion: nil)
                    }else {
                        let id = DataServices.ds.REF_ROOMS.childByAutoId()
                        
                        let name = self.alertView.textFields![0].text
                        let tip  = self.alertView.textFields![1].text
                        let room = Room(roomId: id.key, roomType: tip, itemKeys: [], itemCount: "", name: name!)
                        id.updateChildValues(room.exportDictionary())
                        self.Rooms.append(room)
                        self.tableView.reloadData()
                    }
                }
            }
        }
        alertView.addAction(okButtonAction)
    }
    
    func getRooms()  {
        DataServices.ds.REF_ROOMS.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value)
            print(snapshot.key)
            if let dict = snapshot.value as? Dictionary<String,AnyObject>{
                for roomId in dict.keys{
                    print(dict.keys.count)
                    var room : Room!
                    if let roomdict = dict[roomId] as? Dictionary<String,AnyObject>{
                        
                        let roomtype = roomdict["RoomType"] as! String
                        let authId = roomdict["AuthenticatedPerson"] as! String
                        let roomname = roomdict["RoomName"] as! String
                        room = Room(roomId: roomId, roomType: roomtype, itemKeys: [],itemCount: "",name : roomname)
                        if (authId != "-1"){
                            room.AuthenticatedPerson = User(userId: authId, userName: "")
                        }
                    }
                    self.Rooms.append(room)
                }
                self.tableView.reloadData()
            }
        })
    }
}
extension MainVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RoomTableViewCell
        if(!Rooms.isEmpty){
            cell.room = Rooms[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "RoomDetailVC") as! RoomDetailVC
        destinationVC.room = self.Rooms[indexPath.row]
        destinationVC.AuthenticatedUserKey = self.Rooms[indexPath.row].AuthenticatedPerson.Id
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}


