//
//  CurrencyListResponse.swift
//  CurrencyConverter
//
//  Created by admin on 21/03/2022.
//

import Foundation


//struct BaseModel : Decodable{
//    
//}


struct CurrencyListResponse : Codable  {
    let success: Bool
    let rates: [String:Double]?
    let errorMsg: String?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case currencies = "rates"
        case error = "error"
        case info = "info"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        rates = try container.decodeIfPresent([String:Double].self, forKey: .currencies)
        
        if container.contains(.error) {
            let response = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .error)
            errorMsg = try response.decodeIfPresent(String.self, forKey: .info)
        } else {
            errorMsg = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
    
}

struct Currencies : Codable {
    let success: Bool
    var symbols: [String:String]?
    let errorMsg: String?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case symbols = "symbols"
        case error = "error"
        case info = "info"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        symbols = try container.decodeIfPresent([String:String].self, forKey: .symbols)
        
        
        if container.contains(.error) {
            let response = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .error)
            errorMsg = try response.decodeIfPresent(String.self, forKey: .info)
        } else {
            errorMsg = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
}


struct Convert : Codable {
    let success: Bool
    var query: [String:Any]?
    let errorMsg: String?
    let result:Int?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case query = "query"
        case error = "error"
        case info = "info"
        case result = "result"
        
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        result = try container.decodeIfPresent(Int.self, forKey: .result)
        query = try container.decodeIfPresent([String:String].self, forKey: .query)
        
        if container.contains(.error) {
            let response = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .error)
            errorMsg = try response.decodeIfPresent(String.self, forKey: .info)
        } else {
            errorMsg = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
}






//{
//    "success": true,
//    "query": {
//        "from": "GBP",
//        "to": "JPY",
//        "amount": 25
//    },
//    "info": {
//        "timestamp": 1519328414,
//        "rate": 148.972231
//    },
//    "historical": ""
//    "date": "2018-02-22"
//    "result": 3724.305775
//}
