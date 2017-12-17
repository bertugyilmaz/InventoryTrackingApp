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
        
//        let standartUser = UserDefaults.standard.value(forKey: "userId")
//        let room = Room(roomId: "123123123", roomType: "Yemekhane", itemKeys: [], itemCount: "")
//        room.AuthenticatedPerson = User(userId: standartUser as! String  , userName: "Bertuğ")
//        DataServices.ds.addRoom(roomData: room.exportDictionary())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.Rooms.removeAll()
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
                        
                        if let roomdict = dict[roomId] as? Dictionary<String,AnyObject>{
                            
                            let roomtype = roomdict["RoomType"] as! String
                            let authId = roomdict["AuthenticatedPerson"] as! String
                            let room = Room(roomId: roomId, roomType: roomtype, itemKeys: [],itemCount: "")
                            room.AuthenticatedPerson = User(userId: authId, userName: "")
                        
                            self.Rooms.append(room)
                            
                            self.tableView.reloadData()
                            completion(true)
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
        if(!Rooms.isEmpty){
            cell.room = Rooms[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "RoomDetailVC") as! RoomDetailVC
        destinationVC.room = self.Rooms[indexPath.row]
        destinationVC.AuthenticatedUserKey = self.personKey[indexPath.row]
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}


