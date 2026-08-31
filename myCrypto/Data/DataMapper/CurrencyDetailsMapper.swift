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
            currentPrice: self.marketData?.currentPrice?.usd ?? 0.0,
            marketCap: self.marketData?.marketCap?.usd ?? 0.0,
            marketCapRank: self.marketData?.marketCapRank ?? 0,
            totalVolume: self.marketData?.totalVolume?.usd ?? 0.0,
            priceChangePercentage24H: self.marketData?.priceChangePercentage24H?.usd ?? 0.0
        )
    }
    
}
