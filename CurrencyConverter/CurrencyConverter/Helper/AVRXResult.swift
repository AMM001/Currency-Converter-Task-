//
//  AVRXResult.swift
//  CurrencyConverter
//
//  Created by admin on 26/03/2022.
//

import Foundation
import RxCocoa
import RxSwift

public enum AvRxResult<T>  {
    case success(T)
    case failure(Error?)
    
    var successResult:T? {
        switch self {
        case .success(let result):
            return result
        default:
            return nil
        }
    }
    
    var failureResult :Error?  {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
    
    
    static func getGenericError() -> AvRxResult<T> {
            return .failure(nil)
    }
}

