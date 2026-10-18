//
//  BudgetEngineTests.swift
//  VaravuSelavuTests
//
//  Created by Divya on 15/10/26.
//

import Testing
import Foundation
@testable import VaravuSelavu

@MainActor
struct BudgetEngineTests {
    @Test func remainingIsIncomeMinusPlannedMinusExtra() {
        let summary = BudgetEngine.summary(
            income: 50_000,
            lines: [PlanLine(planned: 10_000, spent: 12_000),
                    PlanLine(planned: 5_000, spent: 3_000)],
            unplannedSpend: 1_500
        )
        #expect(summary.planned == 15_000)
        #expect(summary.overspend == 2_000)
        #expect(summary.extra == 3_500)
        #expect(summary.remaining == 31_500)
        #expect(summary.unusedPlanned == 2_000)
    }

    @Test func statusThresholds() {
        #expect(PlanLine(planned: 100, spent: 79).status == .onTrack)
        #expect(PlanLine(planned: 100, spent: 80).status == .nearLimit)
        #expect(PlanLine(planned: 100, spent: 100).status == .nearLimit)
        #expect(PlanLine(planned: 100, spent: 101).status == .over)
    }

    @Test func noPlanMeansAnySpendIsOver() {
        #expect(PlanLine(planned: 0, spent: 10).status == .over)
        #expect(PlanLine(planned: 0, spent: 0).status == .onTrack)
    }

    @Test func deficitWhenExtraExceedsLeftover() {
        let summary = BudgetEngine.summary(income: 20_000,
                                           lines: [PlanLine(planned: 19_000, spent: 19_000)],
                                           unplannedSpend: 2_000)
        #expect(summary.isDeficit)
        #expect(summary.remaining == -1_000)
    }

    @Test func yearMonthRollsOverTheYear() {
        #expect(YearMonth(year: 2026, month: 12).next == YearMonth(year: 2027, month: 1))
        #expect(YearMonth(year: 2026, month: 1).previous == YearMonth(year: 2025, month: 12))
        #expect(YearMonth(key: 202610).key == 202610)
    }
}
