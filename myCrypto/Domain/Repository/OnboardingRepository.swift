//
//  OnboardingRepository.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 26/9/2568 BE.
//

import Foundation
import RxSwift

protocol OnboardingRepository {
    func isOnboardingCompleted() -> Bool
    func setOnboardingCompleted(completed: Bool)
}
