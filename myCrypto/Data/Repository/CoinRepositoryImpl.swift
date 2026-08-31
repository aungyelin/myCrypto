//
//  CoinRepositoryImpl.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 25/9/2568 BE.
//

import Foundation
import RxSwift
import FactoryKit

final class CoinRepositoryImpl: CoinRepository {
    
    @Injected(\.apiService) private var apiService
    
    func getAllCurrencies(page: Int = 1) -> Single<[Currency]> {
        return apiService.getAllCurrencies(page: page)
            .map { $0.map { dto in dto.toDomain() } }
            .catch { error in
                if let networkError = error as? NetworkError {
                    return Single.error(networkError.toDomain())
                } else {
                    return Single.error(error)
                }
            }
    }
    
    func getCurrencyDetails(id: String) -> Single<CurrencyDetails> {
        return apiService.getCurrencyDetails(id: id)
            .map { $0.toDomain() }
            .catch { error in
                if let networkError = error as? NetworkError {
                    return Single.error(networkError.toDomain())
                } else {
                    return Single.error(error)
                }
            }
    }
    
    func getPriceHistory(id: String) -> Single<PriceHistory> {
        return apiService.getPriceHistory(id: id)
            .map { $0.toDomain() }
            .catch { error in
                if let networkError = error as? NetworkError {
                    return Single.error(networkError.toDomain())
                } else {
                    return Single.error(error)
                }
            }
    }
    
}
