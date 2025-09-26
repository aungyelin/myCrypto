//
//  MainViewModel.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 26/9/2568 BE.
//

import Foundation
import FactoryKit

final class MainViewModel {
    
    @Injected(\.setOnboardingCompletedUseCase) private var setOnboardingCompletedUseCase
    
    
    func markOnboardingCompleted() {
        setOnboardingCompletedUseCase.execute(completed: true)
    }
    
}
