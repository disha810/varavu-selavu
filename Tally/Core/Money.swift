//
//  Money.swift
//  Tally
//
//  Created by Divya on 18/10/26.
//


import Foundation

enum AppConfig {
    /// One place to change the currency. Later: a per-household setting.
    static let currencyCode = "INR"
}

extension Decimal {
    var money: String { formatted(.currency(code: AppConfig.currencyCode)) }
}

extension Sequence where Element == Decimal {
    var total: Decimal { reduce(0, +) }
}
