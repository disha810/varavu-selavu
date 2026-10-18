//
//  YearMonth.swift
//  VaravuSelavu
//
//  Created by Divya on 18/10/26.
//


import Foundation

/// A calendar month without day or time. Models store it as `key` (e.g. 202610)
/// so it is cheap to filter and sort on.
struct YearMonth: Hashable, Comparable, Sendable {
    let year: Int
    let month: Int

    init(year: Int, month: Int) {
        self.year = year
        self.month = month
    }

    init(key: Int) { self.init(year: key / 100, month: key % 100) }

    init(_ date: Date, calendar: Calendar = .current) {
        let c = calendar.dateComponents([.year, .month], from: date)
        self.init(year: c.year ?? 1970, month: c.month ?? 1)
    }

    static var current: YearMonth { YearMonth(Date()) }

    var key: Int { year * 100 + month }

    func date(calendar: Calendar = .current) -> Date? {
        calendar.date(from: DateComponents(year: year, month: month, day: 1))
    }

    func adding(months: Int, calendar: Calendar = .current) -> YearMonth {
        guard let start = date(calendar: calendar),
              let moved = calendar.date(byAdding: .month, value: months, to: start)
        else { return self }
        return YearMonth(moved, calendar: calendar)
    }

    var next: YearMonth { adding(months: 1) }
    var previous: YearMonth { adding(months: -1) }

    var title: String {
        (date() ?? Date()).formatted(.dateTime.month(.wide).year())
    }

    static func < (lhs: YearMonth, rhs: YearMonth) -> Bool { lhs.key < rhs.key }
}
