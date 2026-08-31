//
//  ApiService.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 25/9/2568 BE.
//

import Foundation
import RxSwift

protocol ApiServiceProtocol {
    func getAllCurrencies(page: Int) -> Single<CurrenciesResponse>
    func getCurrencyDetails(id: String) -> Single<CurrencyDetailsResponse>
    func getPriceHistory(id: String) -> Single<PriceHistoryResponse>
}

class ApiService: ApiServiceProtocol {
    
    static let shared = ApiService()
    
    private let networkManager = NetworkManager.shared
    
    func getAllCurrencies(page: Int = 1) -> Single<CurrenciesResponse> {
        return Single.create { single in
            let task = Task {
                do {
                    let response: CurrenciesResponse = try await self.networkManager.request(endpoint: "/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=\(page)&sparkline=true")
                    single(.success(response))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create { task.cancel() }
        }
    }
    
    func getCurrencyDetails(id: String) -> Single<CurrencyDetailsResponse> {
        return Single.create { single in
            let task = Task {
                do {
                    let response: CurrencyDetailsResponse = try await self.networkManager.request(endpoint: "/\(id)")
                    single(.success(response))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create { task.cancel() }
        }
    }
    
    func getPriceHistory(id: String) -> Single<PriceHistoryResponse> {
        return Single.create { single in
            let task = Task {
                do {
                    let response: PriceHistoryResponse = try await self.networkManager.request(endpoint: "/\(id)/market_chart?vs_currency=usd&days=7")
                    single(.success(response))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create { task.cancel() }
        }
    }
    
}
