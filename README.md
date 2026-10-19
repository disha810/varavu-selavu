# VaravuSelavu

VaravuSelavu (வரவு செலவு, "income and expenses") is a native iOS app for planning a monthly budget and staying on it.

## The idea
- Record your monthly income.
- Plan recurring expenses (rent, EMI, groceries, savings) once, and reuse them in any month.
- Log spending against each plan. Anything over the planned amount, or outside the plan, is flagged in red.
- See what is left for the month, and learn from where you overspent.

## Tech
- SwiftUI and SwiftData (iOS 17+)
- Swift Testing for unit tests
- A pure, UI-free domain layer for the budget maths

## Status
In progress. Milestone 1 (income, saved expenses, monthly plan, spending, red flags) is under development.

## Roadmap
1. Foundation: income, saved expenses, monthly plan, spending, red flags
2. Month close: carry leftovers into a permanent savings pool
3. Insights: charts, trends, suggestions
4. On-device intelligence for suggestions (where the device supports it)
5. Accessibility, localization, and CI
6. Family sharing (husband and wife) via CloudKit
7. Widgets and App Intents
