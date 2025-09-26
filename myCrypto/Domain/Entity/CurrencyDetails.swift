//
//  CurrencyDetails.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 26/9/2568 BE.
//

import Foundation

public struct CurrencyDetails: Codable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let marketCap: Double
    let marketCapRank: Int
    let totalVolume: Double
    let priceChangePercentage24H: Double
}
