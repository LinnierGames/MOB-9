//
//  Parallel_Map.swift
//  Parallel Map
//
//  Created by Erick Sanchez on 5/21/18.
//

import XCTest

class Parallel_Map: XCTestCase {
    
    func testParallelMap() {
        let arrayNumbers = [1,2,3,4,5,6,7,8,9]
        let expectedArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
        
        let newArray = arrayNumbers.parallelMap { String($0) }
        
        XCTAssertEqual(newArray, expectedArray)
    }
    
}
