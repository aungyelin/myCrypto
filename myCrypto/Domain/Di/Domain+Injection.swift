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
    
    var getCurrencyDetailsUseCase: Factory<GetCurrencyDetailsUseCase> {
        Factory(self) { @MainActor in GetCurrencyDetailsUseCaseImpl() }
    }
    
    var getPriceHistoryUseCase: Factory<GetPriceHistoryUseCase> {
        Factory(self) { @MainActor in GetPriceHistoryUseCaseImpl() }
    }
    
    var isFavoriteUseCase: Factory<IsFavoriteUseCase> {
        Factory(self) { @MainActor in IsFavoriteUseCaseImpl() }
    }
    
    var saveFavoriteUseCase: Factory<SaveFavoriteUseCase> {
        Factory(self) { @MainActor in SaveFavoriteUseCaseImpl() }
    }
    
    var removeFavoriteUseCase: Factory<RemoveFavoriteUseCase> {
        Factory(self) { @MainActor in RemoveFavoriteUseCaseImpl() }
    }
    
    var getOnboardingStatusUseCase: Factory<GetOnboardingStatusUseCase> {
        Factory(self) { @MainActor in GetOnboardingStatusUseCaseImpl() }
    }
    
    var setOnboardingCompletedUseCase: Factory<SetOnboardingCompletedUseCase> {
        Factory(self) { @MainActor in SetOnboardingCompletedUseCaseImpl() }
    }
    
}
