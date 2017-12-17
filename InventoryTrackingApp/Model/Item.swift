//
//  Item.swift
//  InventoryTrackingApp
//
//  Created by onur hüseyin çantay on 10.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import Foundation

class Item {
    private let Item_Id : String!
    private let Item_Count : String!
    private let Item_Name : String!
    private let Item_Price : String!
    private let Item_Type : String!
    private let IsAvailable : Int!
    var isAvailable : Bool {
        if IsAvailable == 0{
            return false
        }else{
            return true
        }
    }
    var Id : String!{
        return Item_Id
    }
    var count : String!{
        return Item_Count
    }
    var name :String!{
        return Item_Name
    }
    var price : String!{
        return Item_Price
    }
    var type : String!{
        return Item_Type
    }
    init(ItemId:String,ItemCount:String,ItemName:String,ItemPrice:String,ItemType:String,isavailable:Int) {
        self.Item_Id = ItemId
        self.Item_Count = ItemCount
        self.Item_Name = ItemName
        self.Item_Price = ItemPrice
        self.Item_Type = ItemType
        self.IsAvailable = isavailable
    }
    
    func exportDictionary() -> Dictionary<String,AnyObject>{
        let dummyDictionary: Dictionary<String,AnyObject> = [
            "ItemId": Item_Id as AnyObject,
            "ItemCount": Item_Count as AnyObject,
            "ItemName": Item_Name as AnyObject,
            "ItemPrice": Item_Price as AnyObject,
            "ItemType": Item_Type as AnyObject,
            "IsAvailable": isAvailable as AnyObject
        ]
        return dummyDictionary
    }
}
