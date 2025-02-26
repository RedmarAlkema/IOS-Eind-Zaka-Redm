//
//  Untitled.swift
//  IOS-Eind-Zaka-Redm
//
//  Created by Redmar Alkema on 25/02/2025.
//

import Foundation

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = []

    func addExpense(amount: Double, currency: String, description: String) {
        let newExpense = Expense(amount: amount, currency: currency, description: description, date: Date())
        expenses.append(newExpense)
    }

    func totalPerCurrency() -> [(key: String, value: Double)] {
        let grouped = Dictionary(grouping: expenses, by: { $0.currency })
        return grouped.map { (key: $0.key, value: $0.value.reduce(0) { $0 + $1.amount }) }
    }
}
