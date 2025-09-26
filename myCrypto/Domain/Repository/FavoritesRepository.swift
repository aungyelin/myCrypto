//
//  FavoritesRepository.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 26/9/2568 BE.
//

import Foundation
import RxSwift

public protocol FavoritesRepository {
    func isFavorite(id: String) -> Single<Bool>
    func save(details: CurrencyDetails) -> Completable
    func remove(id: String) -> Completable
}
