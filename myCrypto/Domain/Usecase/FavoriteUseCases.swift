//
//  FavoriteUseCases.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 26/9/2568 BE.
//

import Foundation
import RxSwift
import FactoryKit

protocol IsFavoriteUseCase {
    func execute(id: String) -> Single<Bool>
}

final class IsFavoriteUseCaseImpl: IsFavoriteUseCase {
    @Injected(\.favoritesRepository) private var favoritesRepository
    
    func execute(id: String) -> Single<Bool> {
        favoritesRepository.isFavorite(id: id)
    }
}

protocol SaveFavoriteUseCase {
    func execute(details: CurrencyDetails) -> Completable
}

final class SaveFavoriteUseCaseImpl: SaveFavoriteUseCase {
    @Injected(\.favoritesRepository) private var favoritesRepository
    
    func execute(details: CurrencyDetails) -> Completable {
        favoritesRepository.save(details: details)
    }
}

protocol RemoveFavoriteUseCase {
    func execute(id: String) -> Completable
}

final class RemoveFavoriteUseCaseImpl: RemoveFavoriteUseCase {
    @Injected(\.favoritesRepository) private var favoritesRepository
    
    func execute(id: String) -> Completable {
        favoritesRepository.remove(id: id)
    }
}
