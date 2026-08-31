//
//  HomeViewModel.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 25/9/2568 BE.
//

import Foundation
import Combine
import RxSwift
import RxCocoa
import FactoryKit

struct PortfolioItem: Identifiable {
    let id: String
    let currency: Currency
    let sparkline: [Double]
    let mockPrice: Double
    let mockChangePct: Double
}

final class HomeViewModel: ObservableObject {
    
    @Injected(\.getAllCurrenciesUseCase) private var getAllCurrenciesUseCase
    
    private let disposeBag = DisposeBag()
    
    @Published private(set) var marketStats: [Currency] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    @Published private(set) var portfolioBalance: Double = 12550.50
    @Published private(set) var portfolioChange: Double = 1204.12
    @Published private(set) var portfolioChangePct: Double = 10.75
    
    @Published private(set) var portfolioItems: [PortfolioItem] = []
    
    private let manualRefresh = PublishSubject<Void>()
    
    init() {
        bind()
    }
    
    func refresh() {
        manualRefresh.onNext(())
    }
    
    func generatePortfolio() {
        let stats = marketStats
        guard !stats.isEmpty else { return }
        let count = min(5, stats.count)
        let indices = Array(0..<stats.count).shuffled().prefix(count)
        
        var newItems: [PortfolioItem] = []
        for idx in indices {
            guard idx >= 0 && idx < stats.count else { continue }
            let currency = stats[idx]
            let upward = Bool.random()
            let sparkline = randomSparkline(upward: upward)
            
            let mockPrice = Double.random(in: 50...20_000)
            let sign: Double = Bool.random() ? 1 : -1
            let mockChangePct = sign * Double.random(in: 0.1...20.0)
            
            newItems.append(PortfolioItem(
                id: currency.id,
                currency: currency,
                sparkline: sparkline,
                mockPrice: mockPrice,
                mockChangePct: mockChangePct
            ))
        }
        portfolioItems = newItems
    }
    
    private func randomSparkline(upward: Bool, count: Int = 20) -> [Double] {
        var values: [Double] = []
        var current = Double.random(in: 0.9...1.1)
        for _ in 0..<count {
            let step = Double.random(in: 0.0...0.04)
            current += (upward ? step : -step) + Double.random(in: -0.02...0.02)
            current = max(0.1, current)
            values.append(current)
        }
        if let minV = values.min(), let maxV = values.max(), maxV > minV {
            return values.map { ($0 - minV) / (maxV - minV) }
        }
        return values
    }

    
    private func bind() {
        let timer = Observable<Int>
            .interval(.seconds(30), scheduler: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .map { _ in () }
            .startWith(())
        
        Observable<Void>
            .merge(timer, manualRefresh.asObservable())
            .do(onNext: { [weak self] in
                DispatchQueue.main.async {
                    self?.isLoading = true
                }
            })
            .flatMapLatest {
                self.getAllCurrenciesUseCase.execute()
                    .asObservable()
                    .materialize()
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .next(let currencies):
                    self?.marketStats = currencies
                    if self?.portfolioItems.isEmpty == true {
                        self?.generatePortfolio()
                    }
                    self?.errorMessage = nil
                    self?.isLoading = false
                case .error(let error):
                    if let myError = error as? MyError {
                        self?.errorMessage = myError.message
                    } else {
                        self?.errorMessage = error.localizedDescription
                    }
                    self?.isLoading = false
                case .completed:
                    self?.isLoading = false
                }
            })
            .disposed(by: disposeBag)
    }
    
}
