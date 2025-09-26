//
//  OnboardingRepositoryImpl.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 26/9/2568 BE.
//

import Foundation
import RxSwift

final class OnboardingRepositoryImpl: OnboardingRepository {
    
    private let defaults: UserDefaults
    private let key = "onboarding.completed"
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func isOnboardingCompleted() -> Bool {
        defaults.bool(forKey: key)
    }
    
    func setOnboardingCompleted(completed: Bool) {
        defaults.set(completed, forKey: key)
    }
    
}
