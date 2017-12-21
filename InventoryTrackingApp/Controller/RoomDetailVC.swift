//
//  RoomDetailVC.swift
//  InventoryTrackingApp
//
//  Created by onur hüseyin çantay on 9.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit
import Firebase

class RoomDetailVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var responsiblePersonLabel : UILabel!
    var room: Room!
    var AuthenticatedUser: User!
    var AuthenticatedUserKey: String = ""{
        didSet{
            self.getPersonDetails()
        }
    }
    var items = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getItemsForRoom()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.responsiblePersonLabel.text = self.room.AuthenticatedPerson.Name
    }
    var item : Item!
    func getPersonDetails()  {
        DispatchQueue.main.async {
            DataServices.ds.REF_USERS.child(self.AuthenticatedUserKey).observeSingleEvent(of: .value, with: { (snapshot) in
                if let user = snapshot.value as? Dictionary<String,AnyObject>{
                    let name  = user["UserName"] as! String
                    let id = self.AuthenticatedUserKey
                    let isAdmin = user["IsAdmin"] as! Bool
                    let nameArr = name.components(separatedBy: "@")
                    self.room.AuthenticatedPerson = User(userId: id, userName: nameArr[0], isAdmin: isAdmin)
                    self.responsiblePersonLabel.text = self.room.AuthenticatedPerson.Name
                }
            })
        }
    }
    func getItemsForRoom(){
        DataServices.ds.REF_CONTAINER.child(self.room.Id).observeSingleEvent(of: .value, with: { (snapshots) in
            if let snapshot = snapshots.children.allObjects as? [DataSnapshot]{
                var item : Item!
                for snap in snapshot{
                    print(snap)
                    print("Onur : \(snapshots)")
                    if let itemDict = snap.value as? Dictionary<String,AnyObject>{
 
                        if let availableNumber = NSNumber(value: itemDict["IsAvailable"] as! Bool) as? NSNumber{
                            
                            item = Item(ItemId: snap.key, ItemCount: itemDict["ItemCount"] as! String, ItemName: itemDict["ItemName"] as! String,               ItemPrice:itemDict["ItemPrice"] as! String, ItemType: itemDict["ItemType"] as! String, isavailable: Int(availableNumber))
                            self.items.append(item)
                        }else {
                            print("Something went wrong --> getItemsForRoom")
                        }
                    }
                }
                self.tableView.reloadData()
            }
        })
    }
    
    func DeleteItemFromRoom(index : IndexPath)  {
        DataServices.ds.REF_ROOMS.child(self.room.Id).child("Items").child(self.items[index.row].Id).removeValue(completionBlock: { (error, ref) in
            if error != nil {
                print("Onur : \(error.debugDescription)")
                return
            }
            self.items.remove(at: index.row)
            self.tableView.deleteRows(at: [index], with: .automatic)
        })
    }
}
extension RoomDetailVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RoomDetailCell
        cell.item = self.items[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let Delete = UITableViewRowAction(style: .default, title: "Atama Kaldır") { (action, indexPath) in
           print("GG")
           //  burasında user kontrolu yapılacak admin sadece odadan eşya çıkarabilir.
            self.DeleteItemFromRoom(index: indexPath)
            let count = Int(self.room.itemCount)! - 1
            DataServices.ds.REF_ROOMS.child(self.room.Id).updateChildValues(["ItemCounts" : "\(count)"])
            DataServices.ds.REF_ITEMS.child(self.items[indexPath.row].Id).updateChildValues(["IsAvailable" : 1])
        }
        return [Delete]
    }

    
}



