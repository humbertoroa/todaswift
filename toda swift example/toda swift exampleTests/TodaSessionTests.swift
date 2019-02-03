//
//  TodaSessionTests.swift
//  toda swift exampleTests
//
//  Created by Humberto Roa on 2/3/19.
//  Copyright © 2019 Humberto Roa. All rights reserved.
//

import XCTest

class TodaSessionTests: XCTestCase {

    var accountId1: String!
    var accountId2: String!
    var fileId: String!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        accountId1 = "b89b6ac4-5db6-4af5-80ff-6e46a2d57e0a"
        accountId2 = "ea24b282-35d5-4a11-be76-8bb9556a9092"
        fileId = "ac00b1e55ab5e576cd6314703dff431dab49c8888c78866a6bf3151e98fe3227"
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateAccount(){
        let firstName = "Jimmy"
        let lastName = "User"
        let accountEmail = "joe@example.com"
        
        let accountData =
            [
                "account-type": "individual",
                "admin-email": "\(accountEmail)",
                "contact": [
                    "email": "\(accountEmail)",
                    "phone": "555-555-5323",
                    "last-name": "\(firstName)",
                    "first-name": "\(lastName)",
                    "address": [
                        "city": "Seattle",
                        "country": "WA",
                        "postal-code": "99999",
                        "province-region": "Washington",
                        "street-address-1": "1st ave",
                        "street-address-2": ""
                    ]
                ]
                ] as [String : Any]
        
        let jsonData = [
            "type": "account",
            "data": [
                "attributes": accountData
            ]
            ] as [String : Any]
        
        let expectation = XCTestExpectation(description: "Create account")
        Session.createAccount(accountData: jsonData){ (result, response) in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetAccounts(){
        let expectation = XCTestExpectation(description: "Get accounts")
        Session.getAccounts(){ (result, response) in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    func testGetAccount(){
        XCTFail()
    }
    
    func testGetItemFile(){
        let expectation = XCTestExpectation(description: "Get item")
        let fileId = "772e3a6708ed8f6c1ac9d955efd39a0512001fe730edb9a96fcd584f1d99c23e"
        Session.getFile(id: fileId){ (result, response) in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testCreateItemFile(){
        let itemData =
            [
                "name": "My Coin",
                "points": 100
                ] as [String : Any]
        
        let itemType = "game-coin-new"
        
        let jsonData = [
            "data": [
                "type": "file",
                "attributes": [
                    "payload": itemData
                ],
                "relationships": [
                    "file-type": [
                        "data": [
                            "id": itemType
                        ]
                    ],
                    "initial-account": [
                        "data": [
                            "type": "account",
                            "id": accountId1
                        ]
                    ],
                ]
            ]
            ] as [String : Any]
        
        let expectation = XCTestExpectation(description: "Create item")
        Session.createFile(fileData: jsonData){ (result, response) in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testAccountFilesAccount1(){
        let expectation = XCTestExpectation(description: "Get account items")
        Session.getAccountFiles(id: self.accountId1){ (result, response) in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testAccountFilesAccount2(){
        let expectation = XCTestExpectation(description: "Get account items")
        Session.getAccountFiles(id: self.accountId2){ (result, response) in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetTransaction(){
        let expectation = XCTestExpectation(description: "Get account items")
        let transactionId = "dd7e94d84a4918ad61301a46f113d93aa7d865d57e54d6a7c5d697fbc4a0e9c8"
        Session.getTransaction(id: transactionId){ (result, response) in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testTransferItemFile(){
        let senderId  = self.accountId1
        let recipientId = self.accountId2
        let fileId = self.fileId
        let fileType = "file"
        
        let jsonData = [
            "data": [
                "relationships":[
                    "sender": [
                        "data": [
                            "type": "account",
                            "id": "\(senderId!)"
                        ]
                    ],
                    "recipient": [
                        "data": [
                            "type": "account",
                            "id": "\(recipientId!)"
                        ]
                    ],
                    "files": [
                        "data": [[
                            "type": "\(fileType)",
                            "id": "\(fileId!)"
                            ]]
                    ],
                    
                    
                ]
            ]
            ] as [String : Any]
        
        let expectation = XCTestExpectation(description: "Create item")
        Session.transferFile(transactionData: jsonData){ (result, response) in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }

}
