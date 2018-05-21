//
//  Array+ParallelMap.swift
//  Parallel Map
//
//  Created by Erick Sanchez on 5/21/18.
//

import Foundation

extension Array {
    func parallelMap<T>(_ mapper: (Element) -> T) -> [T] {
        var newArray = [T!].init(repeating: nil, count: self.count)
        DispatchQueue.concurrentPerform(iterations: self.count) { (index) in
            newArray[index] = mapper(self[index])
        }
        
        return newArray
    }
}
