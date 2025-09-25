//
//  Currency.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 25/9/2568 BE.
//

import Foundation

struct Currency: Codable {
    var id: String
    var symbol: String
    var name: String
    var image: String
    var currentPrice: Double
    var priceChangePercentage24H: Double
}
