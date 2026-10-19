//
//  SummaryCard.swift
//  VaravuSelavu
//
//  Created by Divya on 19/10/26.
//


import SwiftUI
import SwiftData

extension BudgetStatus {
    var color: Color {
        switch self {
        case .onTrack: .green
        case .nearLimit: .orange
        case .over: .red
        }
    }
}

struct SummaryCard: View {
    let summary: MonthSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Remaining this month").font(.subheadline).foregroundStyle(.secondary)
            Text(summary.remaining.money)
                .font(.largeTitle.bold())
                .foregroundStyle(summary.isDeficit ? Color.red : Color.primary)
                .contentTransition(.numericText())
            if summary.hasExtraSpending {
                Label("Extra spending: \(summary.extra.money)", systemImage: "flag.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.red)
            }
            HStack {
                metric("Income", summary.income)
                metric("Planned", summary.planned)
                metric("Extra", summary.extra, flagged: summary.hasExtraSpending)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }

    private func metric(_ title: String, _ value: Decimal, flagged: Bool = false) -> some View {
        VStack(alignment: .leading) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text(value.money)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(flagged ? Color.red : Color.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}