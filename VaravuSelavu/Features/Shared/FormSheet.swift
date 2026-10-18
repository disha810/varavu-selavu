//
//  FormSheet.swift
//  VaravuSelavu
//
//  Created by Divya on 18/10/26.
//


import SwiftUI

/// Reusable sheet: title, Cancel, Save.
struct FormSheet<Content: View>: View {
    let title: String
    let canSave: Bool
    let onSave: () -> Void
    @ViewBuilder var content: Content
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form { content }
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") { onSave(); dismiss() }
                            .disabled(!canSave)
                    }
                }
        }
    }
}

struct AmountField: View {
    let title: String
    @Binding var value: Decimal?

    var body: some View {
        TextField(title, value: $value, format: .number)
            .keyboardType(.decimalPad)
    }
}
