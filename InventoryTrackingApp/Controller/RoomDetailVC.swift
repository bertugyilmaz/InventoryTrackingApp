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
    var stockItems = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getItemsForRoom()
        self.getItemDetail()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.responsiblePersonLabel.text = self.room.AuthenticatedPerson.Name
    }
    var deletedItem : Item!
    
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
    var gettingDetailCompleted : Bool = false
    func getItemDetail() {
        DataServices.ds.REF_ITEMS.observeSingleEvent(of: .value, with: { (snapshots) in
            if let snapshot = snapshots.children.allObjects as? [DataSnapshot]{
                var item : Item!
                for snap in snapshot{
                    print(snap)
                    print("Onur : \(snapshots)")
                    if let itemDict = snap.value as? Dictionary<String,AnyObject>{
                        
                        if let availableNumber = NSNumber(value: itemDict["IsAvailable"] as! Bool) as? NSNumber{
                            
                            item = Item(ItemId: snap.key, ItemCount: itemDict["ItemCount"] as! String, ItemName: itemDict["ItemName"] as! String,               ItemPrice:itemDict["ItemPrice"] as! String, ItemType: itemDict["ItemType"] as! String, isavailable: Int(availableNumber))
                            self.stockItems.append(item)
                        }else {
                            print("Something went wrong --> getItemsForRoom")
                        }
                    }
                }
                
                self.tableView.reloadData()
            }
        
        })
       
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
        
        var count : Int!
        for item in self.stockItems{ // burayı completiondan çıkar daha once gerçekleştir
            if item.Id == self.items[index.row].Id{
                let first = Int(item.count)!
                count = first + 1
                break
            }
            
        }

        if(self.room.itemCount == "0"){
            DataServices.ds.REF_CONTAINER.child(self.room.Id).child(self.items[index.row].Id).removeValue(completionBlock: { (error, ref) in
                if error != nil{
                    print("birşeyler oldu")
                    return
                }
                for item in self.stockItems{
                    if item.Id == self.items[index.row].Id{
                        let first = Int(item.count)!
                        let count = first + 1
                        DataServices.ds.REF_ITEMS.child(self.items[index.row].Id).updateChildValues(["ItemCount":String(count)])
                        self.items[index.row] = Item(ItemId: self.items[index.row].Id, ItemCount: self.room.itemCount, ItemName: self.items[index.row].name, ItemPrice: self.items[index.row].price, ItemType: self.items[index.row].type, isavailable: self.items[index.row].isAvailable == true ? 1 : 0)
                        self.tableView.reloadData()
                        break
                    }
                }
                if self.room.itemCount == "0" {
                    self.items.remove(at: index.row)
                    self.tableView.deleteRows(at: [index], with: .automatic)
                    self.tableView.reloadData()
                }
            })
        }else{
            //https://firebase.google.com/docs/database/ios/read-and-write#update_specific_fields buraya bakıcan uykun geldi o yuzden bıraktın tek atıcak bu soruna
            DataServices.ds.REF_CONTAINER.child(self.room.Id).child(self.items[index.row].Id).updateChildValues(["ItemCount":self.room.itemCount], withCompletionBlock: { (error, ref) in
                if error != nil{
                    print("birşeyler oldu")
                    return
                }
                DataServices.ds.REF_ITEMS.child(self.items[index.row].Id).updateChildValues(["ItemCount":String(count)], withCompletionBlock: { (error, ref) in
                            if error != nil{
                                print("birşeyler oldu")
                                return
                            }
                            self.items[index.row] = Item(ItemId: self.items[index.row].Id, ItemCount: self.room.itemCount, ItemName: self.items[index.row].name, ItemPrice: self.items[index.row].price, ItemType: self.items[index.row].type, isavailable: self.items[index.row].isAvailable == true ? 1 : 0)
                            self.tableView.reloadData()
                            
                        })
                    
                
            
        })
        
        
    }
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
                
                    let countForCOntainer = Int(self.items[indexPath.row].count)! - 1
                    self.room = Room(roomId: self.room.Id, roomType: self.room.roomType, itemKeys: self.room.itemsKeys, itemCount: String(countForCOntainer), name: self.room.roomName)
                    self.DeleteItemFromRoom(index: indexPath)
                
        }
        return [Delete]
    }

    
}



