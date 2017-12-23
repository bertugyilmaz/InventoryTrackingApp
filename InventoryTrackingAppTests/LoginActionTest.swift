//
//  LoginActionTest.swift
//  InventoryTrackingAppTests
//
//  Created by onur hüseyin çantay on 23.12.2017.
//  Copyright © 2017 Bertuğ YILMAZ. All rights reserved.
//

import XCTest
@testable import InventoryTrackingApp
class LoginActionTest: XCTestCase {
    var loginVc : LoginVC!
    var fakeUser : User!
    var realUser : User!
    var  storyboard : UIStoryboard!
    var textfield : loginTextFields!
    var button : roundedButton!
    override func setUp() {
        super.setUp()
        storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        
        loginVc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        
        fakeUser = User(userId: "asdmsmd", userName: "fake@gmail.com", isAdmin: true)
        realUser = User(userId: "pIGsnSuEXtMdtLBBmTwfEPAKjDh2", userName: "onur@gmail.com", isAdmin: true)
        textfield = loginTextFields()
        button = roundedButton()
        loginVc.passwordTextField = textfield
        loginVc.userNameTextField = textfield
        loginVc.loginButton = button
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        loginVc = nil
        fakeUser = nil
        realUser = nil
        storyboard = nil
        textfield = nil
        button = nil
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testForWrongUserLogin()  {
        loginVc.viewDidLoad()
        DataServices.ds.FIR_AUTH.signIn(withEmail: fakeUser.Name, password: "") { (user, err) in
            if err != nil{
                XCTAssert(true, "Kullanıcı Bulunamadı")
            }
        }
    }
    func testForRealuserLogin() {
        DataServices.ds.FIR_AUTH.signIn(withEmail: realUser.Name, password: "123456") { (user, err) in
            if err != nil{
                XCTFail("Kullanıcı Oldugu halde bulamadı Bir sıkıntı var")
            }
            XCTAssert(true, "Kullanıcı Bulundu")
        }
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
