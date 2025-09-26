//
//  RootViewModel.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 26/9/2568 BE.
//

import Foundation
import FactoryKit

final class RootViewModel {
    
    @Injected(\.getOnboardingStatusUseCase) private var getOnboardingStatusUseCase
    
    
    func isOnboardingDone() -> Bool {
        return getOnboardingStatusUseCase.execute()
    }
    
}
