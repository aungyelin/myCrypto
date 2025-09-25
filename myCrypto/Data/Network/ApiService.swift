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
}

class ApiService: ApiServiceProtocol {
    
    static let shared = ApiService()
    
    private let networkManager = NetworkManager.shared
    
    
    func getAllCurrencies() -> Single<CurrenciesResponse> {
        return networkManager.request(endpoint: "/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true")
    }
    
}
