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

final class HomeViewModel: ObservableObject {
    
    @Injected(\.getAllCurrenciesUseCase) private var getAllCurrenciesUseCase
    
    private let disposeBag = DisposeBag()
    
    @Published private(set) var marketStats: [Currency] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    @Published private(set) var portfolioBalance: Double = 12550.50
    @Published private(set) var portfolioChange: Double = 1204.12
    @Published private(set) var portfolioChangePct: Double = 10.75
    @Published private(set) var selectedPortfolioIndices: [Int] = []
    @Published private(set) var sparklineData: [Int: [Double]] = [:]
    
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
        selectedPortfolioIndices = Array(indices)
        
        var newSpark: [Int: [Double]] = [:]
        for idx in selectedPortfolioIndices {
            guard idx >= 0 && idx < stats.count else { continue }
            let upward = Bool.random()
            newSpark[idx] = randomSparkline(upward: upward)
        }
        sparklineData = newSpark
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
    
    func portfolioCurrencies() -> [Currency] {
        selectedPortfolioIndices.compactMap { idx in
            guard idx >= 0 && idx < marketStats.count else { return nil }
            return marketStats[idx]
        }
    }
    
    func indexForCurrency(_ currency: Currency) -> Int {
        return marketStats.firstIndex(where: { $0.id == currency.id }) ?? -1
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
                    if self?.selectedPortfolioIndices.isEmpty == true {
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
