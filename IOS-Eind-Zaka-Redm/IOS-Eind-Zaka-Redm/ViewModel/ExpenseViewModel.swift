import Foundation

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    private let transactionController = TransactionController()

    init() {
        loadExpenses()
    }

    private func loadExpenses() {
        expenses = transactionController.loadExpenses()
    }

    func addExpense(amount: Double, currency: String, description: String) {
        let newExpense = Expense(amount: amount, currency: currency, description: description, date: Date())
        transactionController.addExpense(expense: newExpense, expenses: &expenses)
    }

    func updateExpense(updatedExpense: Expense) {
        transactionController.updateExpense(updatedExpense: updatedExpense, expenses: &expenses)
    }

    func deleteExpense(expense: Expense) {
        transactionController.deleteExpense(expense: expense, expenses: &expenses)
    }
}
