//
//  IncomeEditor.swift
//  VaravuSelavu
//
//  Created by Divya on 19/10/26.
//


import SwiftUI
import SwiftData

struct IncomeEditor: View {
    let month: YearMonth
    @Environment(\.modelContext) private var context
    @State private var source = "Salary"
    @State private var amount: Decimal?
    @State private var note = ""

    var body: some View {
        FormSheet(title: "Add income", canSave: !source.isEmpty && (amount ?? 0) > 0, onSave: save) {
            TextField("Source", text: $source)
            AmountField(title: "Amount", value: $amount)
            TextField("Note", text: $note, axis: .vertical)
        }
    }

    private func save() {
        context.insert(IncomeEntry(month: month, source: source, amount: amount ?? 0, note: note))
    }
}