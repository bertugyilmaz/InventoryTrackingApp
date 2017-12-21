//
//  User.swift
//  InventoryTrackingApp
//
//  Created by onur hüseyin çantay on 10.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import Foundation

class User  {
    private let user_Id : String!
    private let user_Name : String!
    private let isAdmin : Bool!
    var Id : String!{
        return user_Id
    }
    var Name : String!{
        return user_Name
    }
    var IsAdmin: Bool!{
        return isAdmin
    }
    init(userId:String!,userName:String,isAdmin:Bool = false) {
        self.user_Id = userId
        self.user_Name = userName
        self.isAdmin = isAdmin
    }
    
    func exportDictionary() -> Dictionary<String,AnyObject>{
       
        let dummyDictionary: Dictionary<String,AnyObject> = [
            "user_Id": user_Id as AnyObject,
            "UserName" : user_Name as AnyObject,
            "IsAdmin": isAdmin as AnyObject
        ]
        return dummyDictionary
    }
}
