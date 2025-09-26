//
//  CurrencyRepository.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 25/9/2568 BE.
//

import Foundation
import RxSwift

protocol CoinRepository {
    func getAllCurrencies() -> Single<[Currency]>
    func getCurrencyDetails(id: String) -> Single<CurrencyDetails>
    func getPriceHistory(id: String) -> Single<PriceHistory>
}
