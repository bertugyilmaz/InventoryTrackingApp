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
    typealias getItemCompleted = () -> ()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getRooms { (success) in
            guard success == true else{
                return
            }
        }
    }
    var personKey = [String]()
    func getRooms(completion: @escaping (Bool)->())  {
        DispatchQueue.main.async {
            DataServices.ds.REF_ROOMS.observe(.value, with: { (snapshot) in
                print(snapshot.value)
                print(snapshot.key)
                if let dict = snapshot.value as? Dictionary<String,AnyObject>{
                    for roomId in dict.keys{
                        print("Onur :\(roomId)")
                        if let roomdict = dict[roomId] as? Dictionary<String,AnyObject>{
                            let roomItemCount = roomdict["ItemCounts"] as! String
                            if let itemsdict = roomdict["Items"] as? Dictionary<String,AnyObject>{
                                let roomtype = roomdict["RoomType"] as! String
                                self.personKey.append(roomdict["AuthenticatedPerson"] as! String)
                                let itemIds = itemsdict.keys
                                var itemKeys = [String]()
                                for key in itemIds{
                                    itemKeys.append(key)
                                }
                                    self.Rooms.append(Room(roomId: roomId, roomType: roomtype, itemKeys: itemKeys,itemCount: roomItemCount))
                                self.tableView.reloadData()
                                completion(true)
                            }
                        }
                    }
                }
            }, withCancel: nil)
        }
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
        cell.room = Rooms[indexPath.row]
        cell.countLabel.text = Rooms[indexPath.row].itemCount
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "RoomDetailVC") as! RoomDetailVC
        destinationVC.room = self.Rooms[indexPath.row]
        destinationVC.AuthenticatedUserKey = self.personKey[indexPath.row]
        self.navigationController?.pushViewController(destinationVC, animated: true)
        self.Rooms.removeAll()
    }
    
}


