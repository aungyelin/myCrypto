//
//  MarketPresponse.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 25/9/2568 BE.
//

import Foundation

typealias CurrenciesResponse = [CurrencyDto]

struct CurrencyDto: Codable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double?
    let priceChangePercentage24H: Double?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case priceChangePercentage24H = "price_change_percentage_24h"
    }
}
