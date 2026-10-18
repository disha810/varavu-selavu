//
//  TemplatesView.swift
//  VaravuSelavu
//
//  Created by Divya on 18/10/26.
//

import SwiftUI
import SwiftData

struct TemplatesView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \ExpenseTemplate.name) private var templates: [ExpenseTemplate]
    @State private var editing: ExpenseTemplate?
    @State private var showNew = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(templates) { template in
                    Button { editing = template } label: {
                        LabeledContent {
                            Text(template.plannedAmount.money)
                        } label: {
                            VStack(alignment: .leading) {
                                Label(template.name, systemImage: template.category.symbol)
                                if !template.isActive {
                                    Text("Paused").font(.caption).foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                }
                .onDelete { offsets in
                    for index in offsets { context.delete(templates[index]) }
                }
            }
            .overlay {
                if templates.isEmpty {
                    ContentUnavailableView("No saved expenses", systemImage: "tray",
                        description: Text("Save rent, EMI, groceries and more once, then add them to any month."))
                }
            }
            .navigationTitle("Saved expenses")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add", systemImage: "plus") { showNew = true }
                }
            }
            .sheet(isPresented: $showNew) { TemplateEditor(template: nil) }
            .sheet(item: $editing) { TemplateEditor(template: $0) }
        }
    }
}

struct TemplateEditor: View {
    let template: ExpenseTemplate?
    @Environment(\.modelContext) private var context
    @State private var name: String
    @State private var category: ExpenseCategory
    @State private var amount: Decimal?
    @State private var note: String
    @State private var isActive: Bool

    init(template: ExpenseTemplate?) {
        self.template = template
        _name = State(initialValue: template?.name ?? "")
        _category = State(initialValue: template?.category ?? .other)
        _amount = State(initialValue: template?.plannedAmount)
        _note = State(initialValue: template?.note ?? "")
        _isActive = State(initialValue: template?.isActive ?? true)
    }

    var body: some View {
        FormSheet(title: template == nil ? "New saved expense" : "Edit saved expense",
                  canSave: !name.isEmpty && (amount ?? 0) > 0, onSave: save) {
            TextField("Name", text: $name)
            Picker("Category", selection: $category) {
                ForEach(ExpenseCategory.allCases) { cat in
                    Label(cat.title, systemImage: cat.symbol).tag(cat)
                }
            }
            AmountField(title: "Planned amount", value: $amount)
            TextField("Note", text: $note, axis: .vertical)
            Toggle("Available for new months", isOn: $isActive)
        }
    }

    private func save() {
        let planned = amount ?? 0
        if let template {
            template.name = name
            template.category = category
            template.plannedAmount = planned
            template.note = note
            template.isActive = isActive
        } else {
            let new = ExpenseTemplate(name: name, category: category, plannedAmount: planned, note: note)
            new.isActive = isActive
            context.insert(new)
        }
    }
}
