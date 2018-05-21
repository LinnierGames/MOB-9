//
//  SemaphoreUnitTests.swift
//  ReadersWritersProblem
//
//  Created by Chase Wang on 2/23/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import XCTest

class SemaphoreUnitTests: XCTestCase {
    
    let iterations = 200_000
    
    var user: SUser!
    
    override func setUp() {
        super.setUp()
        user = SUser.current
    }
    
    func testSemaphoreReadersWritersProblem() {
        // solve with semaphores
    }
    
}
