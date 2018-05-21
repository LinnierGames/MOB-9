//
//  DispatchQueueUnitTest.swift
//  ReadersWritersProblem
//
//  Created by Chase Wang on 2/23/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import XCTest

class DispatchQueueUnitTests: XCTestCase {
    
    let iterations = 200_000
    
    var user: DQUser!
    
    override func setUp() {
        super.setUp()
        user = DQUser.current
    }
    
    func testDispatchQueueReadersWritersProblem() {
        // solve with dispatch queues
        let expectation = self.expectation(description: "com.makeschool.expectation")
        
        let dispatchGroup = DispatchGroup()
        
        for _ in 0..<iterations {
            print("read: \(user.age)")
            self.user.age += 1
        }
        
        dispatchGroup.notify(queue: .main) {
            expectation.fulfill()
            
            XCTAssertEqual(self.iterations, self.user.age)
        }
        
        waitForExpectations(timeout: 15, handler: nil)
    }
    
}
