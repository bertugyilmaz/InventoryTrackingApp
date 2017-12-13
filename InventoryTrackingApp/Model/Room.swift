//
//  Room.swift
//  InventoryTrackingApp
//
//  Created by onur hüseyin çantay on 10.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import Foundation

class Room {
    private let room_Id : String!
    private let room_Type : String!
    private let ItemKeys : [String]?
    private let ItemCounts : String!
    private var user : User?
    var AuthenticatedPerson :User!{
        get{
            if(user ==
                nil){
                return User(userId: "-1", userName: "Kullanıcı Atanmadı")
            }
            return user
        }set{
            return self.user = newValue
        }
    }
    
    var itemCount : String!{
        return ItemCounts
    }
    var Id : String!{
        return room_Id
    }
    var roomType :String!{
        return room_Type
    }
    var itemsKeys : [String]!{
        return ItemKeys
    }
    init(roomId:String,roomType:String!,itemKeys:[String],itemCount : String) {
        self.room_Id = roomId
        self.room_Type = roomType
        self.ItemKeys = itemKeys
        self.ItemCounts = itemCount
    }
}
