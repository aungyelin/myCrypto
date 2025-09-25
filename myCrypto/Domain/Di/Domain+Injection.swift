//
//  Domain+Injection.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 25/9/2568 BE.
//

import Foundation
import FactoryKit

extension Container {
    
    var getAllCurrenciesUseCase: Factory<GetAllCurrenciesUseCase> {
        Factory(self) { @MainActor in GetAllCurrenciesUseCaseImpl() }
    }
    
}
