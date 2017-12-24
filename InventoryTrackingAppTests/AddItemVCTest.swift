//
//  AddItemVC.swift
//  InventoryTrackingAppTests
//
//  Created by onur hüseyin çantay on 23.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//
import XCTest
@testable import Firebase
@testable import InventoryTrackingApp
class AddItemVCTest: XCTestCase {
    override func setUp() {
        super.setUp()
         // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    func testGetRoomIdTest()  {
        DataServices.ds.REF_ROOMS.observeSingleEvent(of: .value, with: { (snapshots) in
            if let snapshot = snapshots.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    print(snap.key)
                }
                XCTAssert(true, "Getting Room Id's Completed")
            }
        }) { (error) in
            XCTFail()
        }
    }
    func testGetItems()  {
        DataServices.ds.REF_ITEMS.observeSingleEvent(of: .value, with: { (snapshots) in
            if let snapshot = snapshots.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    print(snap.key)
                }
                XCTAssert(true, "Getting Item Id's Completed")
            }
        }) { (error) in
            XCTFail()
        }
    }
    
    
}
