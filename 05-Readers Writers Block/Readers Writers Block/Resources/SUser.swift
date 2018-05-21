//
//  SUser.swift
//  ReadersWritersProblem
//
//  Created by Chase Wang on 2/23/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation

class SUser {
    
    // MARK: - Singleton
    
    static let current = SUser()
    
    // MARK: - Properties
    
    var age: Int
    
    // MARK: - Init
    
    private init(age: Int = 0) {
        self.age = age
    }
}
