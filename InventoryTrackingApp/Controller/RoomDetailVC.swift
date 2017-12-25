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
        self.getItemsInContainer()
        self.getItemDetail()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    func getItemsInContainer(){
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
        let currentItem = self.items[index.row]
        
        if currentItem.count == "0"{
            DataServices.ds.REF_CONTAINER.child(self.room.Id).child(currentItem.Id).removeValue()
        }else {
            let strCount = currentItem.count
//            print(strCount)
            DataServices.ds.REF_CONTAINER.child(self.room.Id).child(currentItem.Id).updateChildValues(["ItemCount": strCount])
        }
        
        var i = 0
        for item in self.stockItems{
            if item.Id == currentItem.Id{
                let first = Int(item.count)!
                let count = first + 1
                let strCount = String(count)
                print(strCount)
                
                self.stockItems.remove(at: i)
                self.stockItems.insert(Item(ItemId: item.Id, ItemCount: strCount, ItemName: item.Id, ItemPrice: item.price, ItemType: item.type, isavailable: item.isAvailable ? 1 : 0), at: i)
                
                DataServices.ds.REF_ITEMS.child(self.items[index.row].Id).updateChildValues(["ItemCount": strCount, "IsAvaiblable": currentItem.count == "0" ? true : false])
                self.tableView.reloadData()
                break
            }
            i = i+1
        }
        
        if currentItem.count == "0" {
            self.items.remove(at: index.row)
            self.tableView.deleteRows(at: [index], with: .automatic)
            self.tableView.reloadData()
        }

    }
    
    override func printButtonAction(sender: UIButton) {
        super.printButtonAction(sender: sender)
        if self.items.count != 0{
            let pdfUrl = Helper.createPdfFromTableView(self.tableView)
            
            self.activityController = UIActivityViewController(activityItems: [pdfUrl], applicationActivities: nil)
            self.activityController.popoverPresentationController?.sourceView = self.view
            self.activityController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
            
            self.present(self.activityController, animated: true, completion: nil)
        }else {
            self.present(Helper.showAlertView(title: "", message: "Demirbaşınız bulunmamakta"), animated: true, completion: nil)
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
                
            var selectedItem = self.items[indexPath.row]
            
            let countForContainer = Int(self.items[indexPath.row].count)! - 1
            let strCount = String(countForContainer)
            let insertItem = Item(ItemId: selectedItem.Id, ItemCount: strCount, ItemName: selectedItem.name, ItemPrice: selectedItem.price, ItemType: selectedItem.type, isavailable: selectedItem.isAvailable ? 1: 0 )
                
            self.items.remove(at: indexPath.row)
            self.items.insert(insertItem, at: indexPath.row)
            
            self.DeleteItemFromRoom(index: indexPath)
                
        }
        return [Delete]
    }
}



