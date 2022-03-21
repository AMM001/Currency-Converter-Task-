//
//  CurrencyConverterViewModel.swift
//  CurrencyConverter
//
//  Created by admin on 21/03/2022.
//

import Foundation

class CurrencyConverterViewModel {
    
    private let apiService: APIServiceProtocol
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    internal var currencyCount: Int {
        return cellViewModels.count
    }
    private var cellViewModels: [CurrencyDataViewModel] = [CurrencyDataViewModel]() {
        didSet {
            self.updataCurrListData?()
            self.updataCurrConvertData?()
        }
    }
    
    // Closure
    var showAlert: ((String) -> Void)?
    var updataCurrListData: (() -> ())?
    var updataCurrConvertData: (() -> ())?
    
    
  
    
    //MARK: - Private
    
    /// Create DataCellViewModel for collection view and append to cellViewModels
    /// - Parameter models: Array of Photo model
    private func processFetchedData(_ models: [String:String]) {
        self.cellViewModels = models.map { CurrencyDataViewModel(code: $0.key, name: $0.value)  }.sorted(by: ({ $0.name < $1.name }))
    }
    
    
    //MARK: - Public
    
    /// Get all available currencies list
    func getCurrenciesList() {
        
        self.apiService.getDataFromURL(.currencyList()) { [weak self] (result) in
            switch result {
            case .success(let data):
                do {
                    //                    print(String(decoding: data, as: UTF8.self))
                    let response = try JSONDecoder().decode(CurrencyListResponse.self, from: data)
                    guard response.success == true else {
                        self?.showAlert?(response.errorMsg ?? APIError.unknownError.rawValue)
                        return
                    }
                    if let currencies = response.currencies {
                        self?.processFetchedData(currencies)
                    }
                    
                } catch {
                    self?.showAlert?(APIError.decodeError.rawValue)
                }
            case .failure(let err):
                self?.showAlert?(err.rawValue)
                
            }
        }
    }
    
    /// Get DataCellViewModel from cellViewModels
    /// - Parameter index: query index number
    func getCellViewModel( at index: NSInteger ) -> CurrencyDataViewModel {
        return cellViewModels[index]
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

