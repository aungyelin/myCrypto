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
    
    private let manualRefresh = PublishSubject<Void>()
    
    
    init() {
        bind()
    }
    
    func refresh() {
        manualRefresh.onNext(())
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
