//
//  DataService.swift
//  InventoryTrackingApp
//
//  Created by Bertuğ YILMAZ on 10/12/2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

let DB_BASE  = Database.database().reference()

public class DataServices {
    
    static let ds = DataServices()
    private var _REF_USERS = DB_BASE.child("Users")
    private var _FIR_AUTH = Auth.auth()
    private var _REF_ITEMS = DB_BASE.child("Items")
    private var _REF_ROOMS = DB_BASE.child("Rooms")
    private var _REF_CATEGORIES = DB_BASE.child("Categories")
    private var _REF_CONTAINER = DB_BASE.child("Container")
    var dataSnapshot = [DataSnapshot].self
  
    var REF_CONTAINER: DatabaseReference {
        return _REF_CONTAINER
    }
    
    var REF_CATEGORIES: DatabaseReference {
        return _REF_CATEGORIES
    }
    
    var REF_ITEMS: DatabaseReference {
        return _REF_ITEMS
    }
    
    var REF_ROOMS: DatabaseReference {
        return _REF_ROOMS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var FIR_AUTH: Auth {
        return _FIR_AUTH
    }
    
    func setEmployer(roomId: String, uId: String){
        _REF_ROOMS.child(roomId).updateChildValues(["AuthenticatedPerson": uId])
    }
    func createRoom(roomData : Dictionary<String,AnyObject>)  {
        _REF_ROOMS.childByAutoId().updateChildValues(roomData)
    }
    func deleteRoom(roomId: String){
        _REF_ROOMS.child(roomId).removeValue()
        _REF_CONTAINER.child(roomId).removeValue()
    }
    func createFirebaseUser(uid: String, userData: Dictionary<String,AnyObject>){
        _REF_USERS.child(uid).updateChildValues(userData)
    }
    func addCategories(name: String){
        _REF_CATEGORIES.updateChildValues([name:1])
    }
    func addItem(itemData : Dictionary<String,AnyObject>){
        REF_ITEMS.childByAutoId().updateChildValues(itemData)
    }
    func addRoom(id: String, roomData: Dictionary<String,AnyObject>){
        _REF_ROOMS.child(id).updateChildValues(roomData)
    }
    func addRoomsInContainer(roomId: String, itemData: Dictionary<String,AnyObject>){
        _REF_CONTAINER.child(roomId).child(itemData["ItemId"] as! String).updateChildValues(itemData)
    }
    func getUser(id: String, completion: @escaping (_ result: Bool, _ user: User) -> ()){
        var user: User!
         _REF_USERS.child(id).observeSingleEvent(of: .value, with: { (snapshots) in
            
            if let dict = snapshots.value as? Dictionary<String,AnyObject> {
                let id = snapshots.key
                let username = dict["UserName"] as! String
                let IsAdmin = dict["IsAdmin"] as! Bool
                let name = username.components(separatedBy: "@")[0]
                user = User(userId: id, userName: name, isAdmin: IsAdmin)
                completion(true,user)
            }
         }) { (error) in
            completion(false, user)
        }
    }
}
