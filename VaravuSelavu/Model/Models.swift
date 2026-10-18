//
//  Models.swift
//  VaravuSelavu
//
//  Created by Divya on 18/10/26.
//

import Foundation
import SwiftData

enum ExpenseCategory: String, Codable, CaseIterable, Identifiable {
    case rent, savings, investment, grocery, emi, utilities, transport, insurance, health, other

    var id: String { rawValue }
    var title: String { self == .emi ? "EMI" : rawValue.capitalized }
    var symbol: String {
        switch self {
        case .rent: "house.fill"
        case .savings: "banknote.fill"
        case .investment: "chart.line.uptrend.xyaxis"
        case .grocery: "cart.fill"
        case .emi: "creditcard.fill"
        case .utilities: "bolt.fill"
        case .transport: "car.fill"
        case .insurance: "shield.fill"
        case .health: "cross.case.fill"
        case .other: "square.grid.2x2.fill"
        }
    }
}

// Design notes
// - Every property has a default value and there are no unique constraints, so iCloud
//   sync can be switched on later without reshaping the schema.
// - `memberID` is a plain UUID, not a relationship. Unused for now; it is the hook for
//   husband/wife tracking later.
// - Money is Decimal

@Model final class IncomeEntry {
    var id: UUID = UUID()
    var monthKey: Int = 0
    var source: String = "Salary"
    var amount: Decimal = 0
    var note: String = ""
    var memberID: UUID?
    var createdAt: Date = Date()

    init(month: YearMonth, source: String, amount: Decimal, note: String = "") {
        self.monthKey = month.key
        self.source = source
        self.amount = amount
        self.note = note
    }
}

/// A saved expense you can add to any month. Editing it never changes past months.
@Model final class ExpenseTemplate {
    var id: UUID = UUID()
    var name: String = ""
    var category: ExpenseCategory = ExpenseCategory.other
    var plannedAmount: Decimal = 0
    var note: String = ""
    var isActive: Bool = true
    var memberID: UUID?

    init(name: String, category: ExpenseCategory, plannedAmount: Decimal, note: String = "") {
        self.name = name
        self.category = category
        self.plannedAmount = plannedAmount
        self.note = note
    }
}

/// A planned expense in one specific month. Copied from a template (a snapshot),
/// or created as a one-off.
@Model final class PlanItem {
    var id: UUID = UUID()
    var monthKey: Int = 0
    var name: String = ""
    var category: ExpenseCategory = ExpenseCategory.other
    var plannedAmount: Decimal = 0
    var note: String = ""
    var templateID: UUID?
    @Relationship(deleteRule: .cascade, inverse: \SpendEntry.planItem)
    var spends: [SpendEntry] = []

    init(month: YearMonth, name: String, category: ExpenseCategory,
         plannedAmount: Decimal, note: String = "", templateID: UUID? = nil) {
        self.monthKey = month.key
        self.name = name
        self.category = category
        self.plannedAmount = plannedAmount
        self.note = note
        self.templateID = templateID
    }

    var spent: Decimal { spends.map(\.amount).total }
    var line: PlanLine { PlanLine(planned: plannedAmount, spent: spent) }
}

/// Money actually spent. With a `planItem` it counts against the plan;
/// without one it is unplanned (extra) spending.
@Model final class SpendEntry {
    var id: UUID = UUID()
    var monthKey: Int = 0
    var title: String = ""
    var amount: Decimal = 0
    var date: Date = Date()
    var note: String = ""
    var memberID: UUID?
    var planItem: PlanItem?

    init(monthKey: Int, title: String, amount: Decimal, date: Date = Date(), note: String = "") {
        self.monthKey = monthKey
        self.title = title
        self.amount = amount
        self.date = date
        self.note = note
    }
}
