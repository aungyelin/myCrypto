//
//  MyError.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 25/9/2568 BE.
//

import Foundation

struct MyError: Error, Equatable {
    enum ErrorType {
        case network
        case unknown
    }
    
    let type: ErrorType
    let message: String
}
