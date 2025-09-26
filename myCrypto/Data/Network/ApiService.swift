//
//  ApiService.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 25/9/2568 BE.
//

import Foundation
import RxSwift

protocol ApiServiceProtocol {
    func getAllCurrencies() -> Single<CurrenciesResponse>
    func getCurrencyDetails(id: String) -> Single<CurrencyDetailsResponse>
    func getPriceHistory(id: String) -> Single<PriceHistoryResponse>
}

class ApiService: ApiServiceProtocol {
    
    static let shared = ApiService()
    
    private let networkManager = NetworkManager.shared
    
    
    func getAllCurrencies() -> Single<CurrenciesResponse> {
        return networkManager.request(endpoint: "/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true")
    }
    
    func getCurrencyDetails(id: String) -> Single<CurrencyDetailsResponse> {
        return networkManager.request(endpoint: "/\(id)")
    }
    
    func getPriceHistory(id: String) -> Single<PriceHistoryResponse> {
        return networkManager.request(endpoint: "/\(id)/market_chart?vs_currency=usd&days=7")
    }
    
}
