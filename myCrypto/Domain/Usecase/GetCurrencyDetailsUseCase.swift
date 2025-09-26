//
//  GetCurrencyDetailsUseCase.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 26/9/2568 BE.
//

import Foundation
import RxSwift
import FactoryKit

protocol GetCurrencyDetailsUseCase {
    func execute(id: String) -> Single<CurrencyDetails>
}

final class GetCurrencyDetailsUseCaseImpl: GetCurrencyDetailsUseCase {
    
    @Injected(\.coinRepository) private var coinRepository
    
    func execute(id: String) -> Single<CurrencyDetails> {
        coinRepository.getCurrencyDetails(id: id)
    }
    
}
