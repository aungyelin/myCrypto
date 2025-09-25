//
//  ErrorMaper.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 25/9/2568 BE.
//

import Foundation

extension NetworkError: DomainMappable {
    
    typealias T = MyError
    
    func toDomain() -> MyError {
        return MyError(type: .network, message: self.message)
    }
    
}
