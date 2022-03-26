//
//  CurrencyConverterModel.swift
//  CurrencyConverter
//
//  Created by admin on 18/03/2022.
//

import Foundation

struct CurrencyConverterModel: Codable {
    let query: String
    let page: Int
}

struct Post: Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}
