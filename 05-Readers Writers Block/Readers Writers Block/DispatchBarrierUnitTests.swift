//
//  DispatchBarrierUnitTests.swift
//  ReadersWritersProblem
//
//  Created by Chase Wang on 2/23/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import XCTest

class DispatchBarrierUnitTests: XCTestCase {
    
    let iterations = 200_000
    
    var user: DBUser!
    
    override func setUp() {
        super.setUp()
        user = DBUser.current
    }
    
    func testDispatchBarrierReadersWritersProblem() {
        // solve with dispatch barriers
        let expectation = self.expectation(description: "com.makeschool.expectation")
        
        let concurrentQueue = DispatchQueue(label: "com.queue.concurrent", attributes: .concurrent)
        
        for _ in 0..<iterations {
//            print("read: \(user.age)")
            concurrentQueue.async(flags: .barrier) {
                self.user.age += 1
            }
        }
        
        DispatchQueue.main.async {
            self.waitForExpectations(timeout: 10, handler: nil)
        }
        
        XCTAssertEqual(self.iterations, self.user.age)
        print("It is: \(self.iterations, self.user.age)")
        expectation.fulfill()
    }
}
