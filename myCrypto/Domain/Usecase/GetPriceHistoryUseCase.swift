//
//  GetPriceHistoryUseCase.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 26/9/2568 BE.
//

import Foundation
import RxSwift
import FactoryKit

protocol GetPriceHistoryUseCase {
    func execute(id: String) -> Single<PriceHistory>
}

final class GetPriceHistoryUseCaseImpl: GetPriceHistoryUseCase {
    
    @Injected(\.coinRepository) private var coinRepository
    
    func execute(id: String) -> Single<PriceHistory> {
        coinRepository.getPriceHistory(id: id)
    }
    
}
