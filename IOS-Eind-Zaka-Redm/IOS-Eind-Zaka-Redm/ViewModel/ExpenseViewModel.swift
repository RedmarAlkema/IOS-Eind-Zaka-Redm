import Foundation

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    private let transactionController = TransactionController()

    init() {
        loadExpenses()
        addTestData()
    }

        func addTestData() {
            let calendar = Calendar.current
            let now = Date()

            let descriptions = ["Lunch", "Boodschappen", "Koffie", "Tankbeurt", "Bioscoop"]
            let amounts: [Double] = [10.5, 20.0, 5.75, 50.0, 15.0]

            for dayOffset in 0..<7 {
                let date = calendar.date(byAdding: .day, value: -dayOffset, to: now)!

                for i in 0..<5 {
                    let expenseDate = calendar.date(byAdding: .hour, value: i * 3, to: date)!

                    let expense = Expense(
                        amount: amounts[i],
                        currency: "EUR",
                        description: descriptions[i],
                        date: expenseDate
                    )

                    expenses.append(expense)
                }
            }
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
