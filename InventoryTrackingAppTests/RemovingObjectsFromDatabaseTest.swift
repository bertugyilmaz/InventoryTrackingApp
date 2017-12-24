//
//  RemovingObjectsFromDatabaseTest.swift
//  InventoryTrackingAppTests
//
//  Created by onur hüseyin çantay on 24.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import XCTest
import Firebase
@testable   import InventoryTrackingApp
class RemovingObjectsFromDatabaseTest: XCTestCase {
    var roomFromContainer : Room!
    var item : Item!
    var roomFromFaculty : Room!
    var Items : [Item]!
    override func setUp() {
        super.setUp()
        //setting Rooms
        self.roomFromFaculty = Room(roomId: "-L17cdezD0K9Y2ncdvQ0", roomType: "Class", itemKeys: [], itemCount: "", name: "Yzm3102")
        self.roomFromContainer =  Room(roomId: "-L175YnL89SxogSivYpN", roomType: "denebe", itemKeys: [], itemCount: "", name: "dnenee")
        self.item = Item(ItemId: "-L13H16K6jdbycnu1Pua", ItemCount: "12", ItemName: "TestItem", ItemPrice: "123", ItemType: "Test", isavailable: 1)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        self.item = nil
        self.Items = nil
        self.roomFromContainer = nil
        self.roomFromContainer = nil
    }
    
    func testRemoveItemFromRoom() {
        DataServices.ds.REF_CONTAINER.child(self.roomFromContainer.Id).child(self.item.Id).removeValue(completionBlock: { (error, ref) in
            if error != nil {
                XCTFail("Test Failed Ma Boy")
                return
            }
            XCTAssert(true, "Item Removed From room")
        })
    }
    func testRemoveRoomFromDatabase()  {
        DataServices.ds.REF_CONTAINER.child(self.roomFromContainer.Id).removeValue(completionBlock: { (error, ref) in
            if error != nil {
                XCTFail("Test Failed Ma Boy")
                return
            }
            XCTAssert(true, "Item Removed From room")
        })
    }
    func testRemoveItemFromInventory() {
        DataServices.ds.REF_ITEMS.child(self.item.Id).removeValue(completionBlock: { (error, ref) in
            if error != nil {
                XCTFail("Test Failed Ma Boy")
                return
            }
            XCTAssert(true, "Item Removed From room")
        })
    }
    
   
    
}
