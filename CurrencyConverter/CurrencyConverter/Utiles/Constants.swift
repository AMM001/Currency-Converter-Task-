//
//  Constants.swift
//  CurrencyConverter
//
//  Created by admin on 21/03/2022.
//

import Foundation

/// API Constants
struct APP_URL {
    static let scheme = "http"
    static let host = "data.fixer.io/api" // http://data.fixer.io/api/
}

/// HTTPMethod type
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

/// Error
enum APIError: String, Error {
    case invalidURL             = "Invalid url"
    case invalidResponse        = "Invalid response"
    case decodeError            = "Decode error"
    case pageNotFound           = "Requested page not found!"
    case noNetwork              = "Internet connection not available!"
    case noData                 = "Oops! There are no matches for entered text."
    case unknownError           = "Unknown error"
    case serverError            = "Server error"
    case conversionIssue        = "Oops! Getting some conversion issue."

    static func checkErrorCode(_ errorCode: Int = 0) -> APIError {
        switch errorCode {
        case 400:
            return .invalidURL
        case 500:
            return .serverError
        case 404:
            return .pageNotFound
        default:
            return .unknownError
        }
    }
}


/// App Constants
struct AppConstants {
    
    /// SDK keys
    struct Keys {
        static let currencyLayerAPIKey = "c6a7eb2238c9291a548f713fa91c03e0"
        
    }
    
    /// URL Query Parameters
    struct APIParams {
        static let accessKey = "access_key"
        static let format = "1"
    }

}

struct LocalizableStrings {
    
    /// Screen title
    static let currencyTitle = "Currency Conversion"
    
    /// Common
    static let alert = "Alert"
    static let error = "Error"
    static let ok = "Ok"
    static let cancel = "Cancel"
    static let done = "Done"

    static let enterAmount = "Enter amount"
    static let selectCurrency = "Currency"

}
