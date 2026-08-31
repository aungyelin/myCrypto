//
//  PriceHistoryMapper.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 26/9/2568 BE.
//

import Foundation

extension PriceHistoryDto: DomainMappable {
    
    typealias T = PriceHistory
    
    func toDomain() -> PriceHistory {
        return PriceHistory(prices: self.prices ?? [])
    }
    
}
