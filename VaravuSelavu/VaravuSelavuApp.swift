//
//  VaravuSelavuApp.swift
//  VaravuSelavu
//
//  Created by Divya on 15/10/26.
//

import SwiftUI
import SwiftData

@main
struct VaravuSelavuApp: App {
    var body: some Scene {
        WindowGroup { TemplatesView() }
            .modelContainer(for: [
                IncomeEntry.self, ExpenseTemplate.self, PlanItem.self, SpendEntry.self
            ])
    }
}
