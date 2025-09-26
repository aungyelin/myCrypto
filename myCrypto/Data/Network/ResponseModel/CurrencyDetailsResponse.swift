//
//  CurrencyDetailsResponse.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 26/9/2568 BE.
//

import Foundation

typealias CurrencyDetailsResponse = CurrencyDetailsDto

struct CurrencyDetailsDto: Codable {
    let id: String
    let symbol: String
    let name: String
    let image: ImageDto
    let marketData: MarketDataDto
    
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case image
        case marketData = "market_data"
    }
}

struct ImageDto: Codable {
    let thumb: String
    let small: String
    let large: String
}

struct MarketDataDto: Codable {
    let currentPrice: PriceDto
    let marketCap: PriceDto
    let marketCapRank: Int
    let totalVolume: PriceDto
    let priceChangePercentage24H: PriceDto
    
    enum CodingKeys: String, CodingKey {
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case totalVolume = "total_volume"
        case priceChangePercentage24H = "price_change_24h_in_currency"
    }
}

struct PriceDto: Codable {
    let usd: Double
}
