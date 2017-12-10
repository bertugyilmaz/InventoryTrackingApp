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
    private let Items : [Item]!
    var Id : String!{
        return room_Id
    }
    var roomType :String!{
        return room_Type
    }
    var items : [Item]!{
        return Items
    }
    init(roomId:String,roomType:String!,items:[Item]) {
        self.room_Id = roomId
        self.room_Type = roomType
        self.Items = items
    }
}
