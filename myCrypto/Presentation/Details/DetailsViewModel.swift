//
//  DetailsViewModel.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 26/9/2568 BE.
//

import Foundation
import Combine
import RxSwift
import RxCocoa
import FactoryKit
import CoreData

final class DetailsViewModel: ObservableObject {
    
    struct PricePoint: Identifiable, Hashable {
        let id = UUID()
        let date: Date
        let price: Double
    }
    
    @Injected(\.getCurrencyDetailsUseCase) private var getCurrencyDetailsUseCase
    @Injected(\.getPriceHistoryUseCase) private var getPriceHistoryUseCase
    @Injected(\.isFavoriteUseCase) private var isFavoriteUseCase
    @Injected(\.saveFavoriteUseCase) private var saveFavoriteUseCase
    @Injected(\.removeFavoriteUseCase) private var removeFavoriteUseCase
    
    private let disposeBag = DisposeBag()
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var details: CurrencyDetails? = nil
    @Published var pricePoints: [PricePoint] = []
    @Published var minPrice: Double? = nil
    @Published var maxPrice: Double? = nil
    @Published var isFavorite: Bool = false
    
    
    func load(id: String) {
        isLoading = true
        errorMessage = nil
        
        Single.zip(
            getCurrencyDetailsUseCase.execute(id: id),
            getPriceHistoryUseCase.execute(id: id)
        )
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { [weak self] details, history in
            guard let self = self else { return }
            self.details = details
            
            self.isFavoriteUseCase.execute(id: id)
                .observe(on: MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] value in
                    self?.isFavorite = value
                })
                .disposed(by: self.disposeBag)
            
            let points = history.prices.compactMap { arr -> PricePoint? in
                guard arr.count >= 2 else { return nil }
                let ts = arr[0] / 1000.0
                let date = Date(timeIntervalSince1970: ts)
                let price = arr[1]
                return PricePoint(date: date, price: price)
            }
            
            self.pricePoints = points
            self.minPrice = points.map(\.price).min()
            self.maxPrice = points.map(\.price).max()
            
            self.isLoading = false
        }, onFailure: { [weak self] error in
            if let myError = error as? MyError {
                self?.errorMessage = myError.message
            } else {
                self?.errorMessage = error.localizedDescription
            }
            self?.isLoading = false
        })
        .disposed(by: disposeBag)
    }
    
    func refresh(id: String) {
        load(id: id)
    }
    
    func toggleFavorite() {
        guard let details = details else { return }
        if isFavorite {
            removeFavoriteUseCase.execute(id: details.id)
                .observe(on: MainScheduler.instance)
                .subscribe(onCompleted: { [weak self] in
                    self?.isFavorite = false
                }, onError: { error in
                    print("Failed to remove favorite: \(error)")
                })
                .disposed(by: disposeBag)
        } else {
            saveFavoriteUseCase.execute(details: details)
                .observe(on: MainScheduler.instance)
                .subscribe(onCompleted: { [weak self] in
                    self?.isFavorite = true
                }, onError: { error in
                    print("Failed to save favorite: \(error)")
                })
                .disposed(by: disposeBag)
        }
    }
    
}
