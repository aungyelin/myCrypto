//
//  GetAllCurrenciesUseCase.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 25/9/2568 BE.
//

import Foundation
import RxSwift
import FactoryKit

protocol GetAllCurrenciesUseCase {
    func execute(page: Int) -> Single<[Currency]>
}

final class GetAllCurrenciesUseCaseImpl: GetAllCurrenciesUseCase {
    
    @Injected(\.coinRepository) private var coinRepository
    
    func execute(page: Int = 1) -> Single<[Currency]> {
        coinRepository.getAllCurrencies(page: page)
    }
    
}
