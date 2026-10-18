//
//  BudgetEngine.swift
//  Tally
//
//  Created by Divya on 18/10/26.
//


import Foundation

enum BudgetStatus: Sendable { case onTrack, nearLimit, over }

/// One planned expense and what has been spent against it.
struct PlanLine: Sendable {
    var planned: Decimal
    var spent: Decimal

    var overspend: Decimal { max(spent - planned, 0) }
    var unused: Decimal { max(planned - spent, 0) }

    var status: BudgetStatus {
        if spent > planned { return .over }
        if spent * 10 >= planned * 8, planned > 0 { return .nearLimit } // 80%+ used
        return .onTrack
    }

    /// 0...1 for progress bars.
    var fraction: Double {
        guard planned > 0 else { return spent > 0 ? 1 : 0 }
        return min(Double(truncating: (spent / planned) as NSDecimalNumber), 1)
    }
}

struct MonthSummary: Equatable, Sendable {
    let income: Decimal
    let planned: Decimal
    /// Spent above the planned amount on planned items.
    let overspend: Decimal
    /// Spent on things that were not in the plan at all.
    let unplanned: Decimal
    /// Planned money not spent (shown, but not counted as surplus in the MVP).
    let unusedPlanned: Decimal

    var extra: Decimal { overspend + unplanned }
    /// Income, minus the plan, minus extra spending: the money to protect until month end.
    var remaining: Decimal { income - planned - extra }
    var hasExtraSpending: Bool { extra > 0 }
    var isDeficit: Bool { remaining < 0 }
}

/// Pure, UI-free budget maths. Easy to unit test.
enum BudgetEngine {
    static func summary(income: Decimal, lines: [PlanLine], unplannedSpend: Decimal) -> MonthSummary {
        MonthSummary(
            income: income,
            planned: lines.map(\.planned).total,
            overspend: lines.map(\.overspend).total,
            unplanned: unplannedSpend,
            unusedPlanned: lines.map(\.unused).total
        )
    }
}
