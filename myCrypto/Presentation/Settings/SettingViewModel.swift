//
//  SettingViewModel.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 26/9/2568 BE.
//

import Foundation
import FactoryKit

final class SettingViewModel {
    
    @Injected(\.setOnboardingCompletedUseCase) private var setOnboardingCompletedUseCase
    
    
    func setOnboardingStatusAsUndone() {
        setOnboardingCompletedUseCase.execute(completed: false)
    }
    
}
