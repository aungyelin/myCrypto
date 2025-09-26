//
//  GetOnboardingStatusUseCase.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 26/9/2568 BE.
//

import Foundation
import FactoryKit

protocol GetOnboardingStatusUseCase {
    func execute() -> Bool
}

final class GetOnboardingStatusUseCaseImpl: GetOnboardingStatusUseCase {
    @Injected(\.onboardingRepository) private var onboardingRepository
    
    func execute() -> Bool {
        onboardingRepository.isOnboardingCompleted()
    }
}

protocol SetOnboardingCompletedUseCase {
    func execute(completed: Bool)
}

final class SetOnboardingCompletedUseCaseImpl: SetOnboardingCompletedUseCase {
    @Injected(\.onboardingRepository) private var onboardingRepository
    
    func execute(completed: Bool) {
        onboardingRepository.setOnboardingCompleted(completed: completed)
    }
}
