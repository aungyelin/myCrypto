//
//  Data+Injection.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 25/9/2568 BE.
//

import Foundation
import FactoryKit

extension Container {
    
    var apiService: Factory<ApiServiceProtocol> {
        Factory(self) { @MainActor in ApiService.shared }
    }
    
    var coinRepository: Factory<CoinRepository> {
        Factory(self) { @MainActor in CoinRepositoryImpl() }
    }
    
    var favoritesRepository: Factory<FavoritesRepository> {
        Factory(self) { @MainActor in FavoritesRepositoryImpl() }
    }
    
    var onboardingRepository: Factory<OnboardingRepository> {
        Factory(self) { @MainActor in OnboardingRepositoryImpl() }
    }
    
}
