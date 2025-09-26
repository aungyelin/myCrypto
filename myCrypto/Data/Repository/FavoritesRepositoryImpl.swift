//
//  FavoritesRepositoryImpl.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 26/9/2568 BE.
//

import Foundation
import CoreData
import RxSwift

public final class FavoritesRepositoryImpl: FavoritesRepository {
    
    private let context = PersistenceController.shared.container.viewContext

    public init() {}

    public func isFavorite(id: String) -> Single<Bool> {
        return Single<Bool>.create { [weak self] single in
            guard let self = self else {
                single(.failure(NSError(domain: "CoreDataFavoritesRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return Disposables.create()
            }
            self.context.perform {
                do {
                    if let _ = try self.fetchFavoriteCoin(id: id) {
                        single(.success(true))
                    } else {
                        single(.success(false))
                    }
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }

    public func save(details: CurrencyDetails) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.error(NSError(domain: "CoreDataFavoritesRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return Disposables.create()
            }
            self.context.perform {
                do {
                    if try self.fetchFavoriteCoin(id: details.id) == nil {
                        let obj = FavoriteCoin(context: self.context)
                        obj.id = details.id
                        try self.context.save()
                    }
                    completable(.completed)
                } catch {
                    completable(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    public func remove(id: String) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.error(NSError(domain: "CoreDataFavoritesRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return Disposables.create()
            }
            self.context.perform {
                do {
                    if let object = try self.fetchFavoriteCoin(id: id) {
                        self.context.delete(object)
                        try self.context.save()
                    }
                    completable(.completed)
                } catch {
                    completable(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    private func fetchFavoriteCoin(id: String) throws -> FavoriteCoin? {
        let request: NSFetchRequest<FavoriteCoin> = NSFetchRequest(entityName: "FavoriteCoin")
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
}
