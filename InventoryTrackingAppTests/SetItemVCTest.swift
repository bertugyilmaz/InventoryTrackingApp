//
//  SetItemVC.swift
//  InventoryTrackingAppTests
//
//  Created by onur hüseyin çantay on 24.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import XCTest
@testable import InventoryTrackingApp
class SetItemVC: XCTestCase {
    var item : Item!
    var room : Room!
    override func setUp() {
        super.setUp()
        item = Item(ItemId: "", ItemCount: "12", ItemName: "TestItem", ItemPrice: "123", ItemType: "Test", isavailable: 1)
        room  = Room(roomId: "", roomType: "testRoom", itemKeys: [], itemCount: "111", name: "TestRoom")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        item = nil
        room = nil
    }
    func testGetRoomsForSettingİtem()  {
        DataServices.ds.REF_ROOMS.observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.value as? Dictionary<String,AnyObject>) != nil{
                XCTAssert(true, "Data Alımı Gerçekleşti Test Başarılı")
            }
        }) { (error) in
            XCTFail()
        }
    }
    
    func testSetItemToDatabaseTest()   {
        DataServices.ds.REF_CONTAINER.childByAutoId().updateChildValues(item.exportDictionary()) { (error, ref) in
            if error != nil{
                XCTFail("İtem Ekleme Başarısız")
                return
            }
            XCTAssert(true, "İtem Ekleme Başarıyla Gerçekleşti")
        }
    }
    
    
    
}
