//
//  MonthView.swift
//  VaravuSelavu
//
//  Created by Divya on 19/10/26.
//

import SwiftUI
import SwiftData

struct MonthView: View {
    @State private var month = YearMonth.current

    var body: some View {
        NavigationStack {
            MonthContentView(month: month)
                .id(month.key)
                .navigationTitle(month.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button { month = month.previous } label: { Image(systemName: "chevron.left") }
                            .accessibilityLabel("Previous month")
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button { month = month.next } label: { Image(systemName: "chevron.right") }
                            .accessibilityLabel("Next month")
                    }
                }
        }
    }
}

struct MonthContentView: View {
    let month: YearMonth
    @Environment(\.modelContext) private var context
    @Query private var incomes: [IncomeEntry]
    @Query private var items: [PlanItem]
    @Query private var spends: [SpendEntry]
    @State private var sheet: Sheet?

    enum Sheet: Identifiable {
        case income
        var id: Self { self }
    }

    // The query depends on the month, so we build it in init.
    init(month: YearMonth) {
        self.month = month
        let key = month.key
        _incomes = Query(filter: #Predicate<IncomeEntry> { $0.monthKey == key },
                         sort: \IncomeEntry.createdAt)
        _items = Query(filter: #Predicate<PlanItem> { $0.monthKey == key },
                       sort: \PlanItem.name)
        _spends = Query(filter: #Predicate<SpendEntry> { $0.monthKey == key },
                        sort: \SpendEntry.date, order: .reverse)
    }

    private var unplanned: [SpendEntry] { spends.filter { $0.planItem == nil } }

    private var summary: MonthSummary {
        BudgetEngine.summary(
            income: incomes.map(\.amount).total,
            lines: items.map(\.line),
            unplannedSpend: unplanned.map(\.amount).total
        )
    }

    var body: some View {
        List {
            Section { SummaryCard(summary: summary) }

            Section("Income") {
                ForEach(incomes) { income in
                    LabeledContent {
                        Text(income.amount.money)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(income.source)
                            if !income.note.isEmpty {
                                Text(income.note).font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete { delete($0, from: incomes) }
                Button("Add income", systemImage: "plus") { sheet = .income }
            }
        }
        .sheet(item: $sheet) { which in
            switch which {
            case .income: IncomeEditor(month: month)
            }
        }
    }

    private func delete<T: PersistentModel>(_ offsets: IndexSet, from models: [T]) {
        for index in offsets { context.delete(models[index]) }
    }
}
