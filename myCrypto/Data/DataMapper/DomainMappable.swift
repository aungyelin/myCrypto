//
//  DomainMappable.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 25/9/2568 BE.
//

import Foundation

protocol DomainMappable {
    associatedtype T
    func toDomain() -> T
}
