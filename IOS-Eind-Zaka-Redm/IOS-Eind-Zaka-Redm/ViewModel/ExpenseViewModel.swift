import Foundation
import CoreLocation

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    private let transactionController = TransactionController()

    init() {
        loadExpenses()
    }

    private func loadExpenses() {
        expenses = transactionController.loadExpenses()
    }

    func addExpense(amount: Double, currency: String, description: String, location: CLLocationCoordinate2D?) {
        let newExpense = Expense(
            amount: amount,
            currency: currency,
            description: description,
            date: Date(),
            location: location.map { Expense.LocationData(latitude: $0.latitude, longitude: $0.longitude) }
        )
        transactionController.addExpense(expense: newExpense, expenses: &expenses)
    }

    func updateExpense(updatedExpense: Expense) {
        transactionController.updateExpense(updatedExpense: updatedExpense, expenses: &expenses)
    }

    func deleteExpense(expense: Expense) {
        transactionController.deleteExpense(expense: expense, expenses: &expenses)
    }
    
    func totalPerCurrency() -> [(String, Double)] {
        let grouped = Dictionary(grouping: expenses, by: { $0.currency })
        return grouped.map { (key: $0.key, value: $0.value.reduce(0) { $0 + $1.amount }) }
    }
}
