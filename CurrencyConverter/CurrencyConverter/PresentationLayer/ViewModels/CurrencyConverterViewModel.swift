//
//  CurrencyConverterViewModel.swift
//  CurrencyConverter
//
//  Created by admin on 21/03/2022.
//

import Foundation
import RxSwift

class CurrencyConverterViewModel {
    
    private let apiService: APIServiceProtocol
    private let disposeBag = DisposeBag()
    
    //MARK:- OBSERVERS
    let currenciesObserver: PublishSubject<AvRxResult<[CurrencyDataViewModel]>> = PublishSubject()
    let convertObserver: PublishSubject<AvRxResult<Int>> = PublishSubject()

    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
        
    // Closure
    var showAlert: ((String) -> Void)?
   
    private func processFetchedData(_ models: [String:String]) -> [CurrencyDataViewModel] {
        return models.map { CurrencyDataViewModel(code: $0.key, name: $0.value)  }.sorted(by: ({ $0.name < $1.name }))
    }
    
    
    //MARK: - Public
    
    /// Get all available currencies list
    func getCurrenciesList() {
        CurrencyStore.getAvailableCountries()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { countries in
                print("List of countries:", countries)
                if let symbols = countries.symbols {
                    self.currenciesObserver.onNext(.success( self.processFetchedData(symbols)))
                }
            }, onError: { error in
                self.currenciesObserver.onNext(.failure(error))
                switch error {
                case ApiError.conflict:
                    self.showAlert?(error.localizedDescription)
                    print("Conflict error")
                case ApiError.forbidden:
                    print("Forbidden error")
                case ApiError.notFound:
                    print("Not found error")
                default:
                    print("Unknown error:", error)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func convertCurrency(from:String ,to:String , amount:String) {
        let param = ["from":from , "to":to , "amount":amount]
        CurrencyStore.convert(param)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { model in
                print("convert response:", model)
                if let result = model.result {
                    self.convertObserver.onNext(.success( result))
                }
            }, onError: { error in
                self.convertObserver.onNext(.failure(error))
                self.showAlert?(error.localizedDescription)
                switch error {
                case ApiError.conflict:
                    print("Conflict error")
                case ApiError.forbidden:
                    print("Forbidden error")
                case ApiError.notFound:
                    print("Not found error")
                default:
                    print("Unknown error:", error)
                }
            })
            .disposed(by: disposeBag)
        
    }
}

// MARK:- DataCellViewModel

struct CurrencyDataViewModel {
    let code, name: String
    var amount, symbol: String?
    
    init(code: String, name: String) {
        self.code = code
        self.name = name
        self.symbol = Utilities.getCurrencySymbol(code)
    }
}

