//
//  RoomDetailVC.swift
//  InventoryTrackingApp
//
//  Created by onur hüseyin çantay on 9.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import UIKit

class RoomDetailVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    var room : Room!
    var AuthenticatedUser : User!
    var AuthenticatedUserKey : String = ""{
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
        for key in room.itemsKeys{
            self.getItemsForEachRoom(itemId: key, completion: { (success) in
                guard success == true else{
                    return
                }
                self.tableView.reloadData()
            })
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    var item : Item!
    func getPersonDetails()  {
        DispatchQueue.main.async {
            DataServices.ds.REF_USERS.child(self.AuthenticatedUserKey).observeSingleEvent(of: .value, with: { (snapshot) in
                if let user = snapshot.value as? Dictionary<String,AnyObject>{
                    let name  = user["UserName"] as! String
                    let Id = self.AuthenticatedUserKey
                    let admin = user["IsAdmin"] as! Int
                    if(admin == 0){
                         self.AuthenticatedUser = User(userId: Id, userName: name, isAdmin: false)
                    }else{
                        self.AuthenticatedUser = User(userId: Id, userName: name, isAdmin: true)
                    }
                }
            })
        }
    }
    func getItemsForEachRoom(itemId:String,completion :@escaping (Bool) -> ()){
        DispatchQueue.main.async {
            DataServices.ds.REF_ITEMS.child(itemId).observeSingleEvent(of: .value, with: { (snapshot) in
                let id = snapshot.key
                if let dict = snapshot.value as? Dictionary<String,AnyObject> {
                    let count = dict["ItemCount"] as! String
                    let name = dict["ItemName"] as! String
                    let price = dict["ItemPrice"] as! String
                    let type = dict["ItemType"] as! String
                    let isAvailable = dict["IsAvailable"] as! Int
                    self.item = Item(ItemId: id, ItemCount: count, ItemName: name, ItemPrice: price, ItemType: type, isavailable: isAvailable)
                    self.items.append(self.item)
                    self.item = nil
                    completion(true)
                }
            }, withCancel: nil)
        }
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
        cell.ResponsiblePerson.text = AuthenticatedUser.Name
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



