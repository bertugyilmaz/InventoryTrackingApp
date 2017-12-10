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

class DataServices {
    static let ds = DataServices()
    private var _REF_USERS = DB_BASE.child("Users")
    private var _FIR_AUTH = Auth.auth()
    private var _REF_ITEMS = DB_BASE.child("Items")
    private var _REF_ROOMS = DB_BASE.child("Rooms")
    
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
    
    func createFirebaseUser(uid: String, userData: Dictionary<String,AnyObject>){
        _REF_USERS.child(uid).updateChildValues(userData)
    }
}
