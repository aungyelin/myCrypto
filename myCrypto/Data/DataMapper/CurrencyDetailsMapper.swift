//
//  CurrencyDetailsMapper.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 26/9/2568 BE.
//

import Foundation

extension CurrencyDetailsDto: DomainMappable {
    
    typealias T = CurrencyDetails
    
    func toDomain() -> CurrencyDetails {
        return CurrencyDetails(
            id: self.id,
            symbol: self.symbol,
            name: self.name,
            image: self.image.large,
            currentPrice: self.marketData.currentPrice.usd,
            marketCap: self.marketData.marketCap.usd,
            marketCapRank: self.marketData.marketCapRank,
            totalVolume: self.marketData.totalVolume.usd,
            priceChangePercentage24H: self.marketData.priceChangePercentage24H.usd
        )
    }
    
}
