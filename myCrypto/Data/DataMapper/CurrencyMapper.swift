//
//  Currency.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 25/9/2568 BE.
//

import Foundation

extension CurrencyDto: DomainMappable {
    
    typealias T = Currency
    
    func toDomain() -> Currency {
        return Currency(
            id: self.id,
            symbol: self.symbol,
            name: self.name,
            image: self.image,
            currentPrice: self.currentPrice ?? 0.0,
            priceChangePercentage24H: self.priceChangePercentage24H ?? 0.0
        )
    }
    
}
