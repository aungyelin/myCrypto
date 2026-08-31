//
//  PriceHistoryResponse.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 26/9/2568 BE.
//

import Foundation

typealias PriceHistoryResponse = PriceHistoryDto

struct PriceHistoryDto: Codable {
    let prices: [[Double]]?
}
