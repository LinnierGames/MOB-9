//
//  DeadlockUnitTest.swift
//  ReadersWritersProblemUnitTests
//
//  Created by Erick Sanchez on 5/9/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import XCTest

extension DispatchQueue {
    static func lock(resource: Any!) {
        objc_sync_enter(resource)
    }
    
    static func unlock(resource: Any!) {
        objc_sync_exit(resource)
    }
}

class DeadlockUnitTest: XCTestCase {
    
    var firstName = "erick"
    var lastName = "sanchez"
    
    func testNetworkCall() {
        let session = URLSession.shared
        
        var googlePage: Data!
        var gmailPage: Data!
        
        let group = DispatchGroup()
        let exception = self.expectation(description: "network call")
        
        group.enter()
        session.dataTask(with: URL(string: "https://www.google.com/")!) { (data, response, error) in
            guard error == nil,
                let data = data else {
                    fatalError("error was found")
            }
            
            googlePage = data
            
            group.leave()
        }.resume()
        
        group.enter()
        session.dataTask(with: URL(string: "https://www.gmail.com/")!) { (data, response, error) in
            guard error == nil,
                let data = data else {
                    fatalError("error was found")
            }
            
            gmailPage = data
            
            group.leave()
        }.resume()
        
        group.notify(queue: .main) {
//            print("google data: \(String(data: googlePage, encoding: .utf8)!)")
//            print("gmail data: \(String(data: gmailPage, encoding: .utf8)!)")
            exception.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testPriorityInversion() {
        let myClass = DQUser.current
        
        let lowerPriorityException = self.expectation(description: "low priority")
        let highPriorityException = self.expectation(description: "high priority")
        highPriorityException.isInverted = true
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.lock(resource: myClass)
            
            lowerPriorityException.fulfill()
            sleep(10)
            DispatchQueue.unlock(resource: myClass)
        }
        
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
            DispatchQueue.lock(resource: myClass)
            
            highPriorityException.fulfill()
            sleep(10)
            DispatchQueue.unlock(resource: myClass)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDeadlock() {
        let enterException = self.expectation(description: "Enter")
        enterException.expectedFulfillmentCount = 2
        let mustFail = self.expectation(description: "must fail")
        mustFail.isInverted = true
        
        let firstName = DBUser.current
        let lastName = DQUser.current
        
        let queue = DispatchQueue(label: "concurrent", attributes: DispatchQueue.Attributes.concurrent)
        
        queue.async {
            DispatchQueue.lock(resource: firstName)
            enterException.fulfill()
            sleep(1)
            
            DispatchQueue.lock(resource: lastName)
            mustFail.fulfill()
            DispatchQueue.unlock(resource: lastName)
            DispatchQueue.unlock(resource: firstName)
        }
        
        queue.async {
            DispatchQueue.lock(resource: lastName)
            enterException.fulfill()
            sleep(1)
            
            DispatchQueue.lock(resource: firstName)
            mustFail.fulfill()
            DispatchQueue.unlock(resource: firstName)
            DispatchQueue.unlock(resource: lastName)
        }
            
        waitForExpectations(timeout: 2, handler: nil)
    }
}
