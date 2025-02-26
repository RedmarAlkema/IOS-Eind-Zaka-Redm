
import Foundation

class TransactionController {
    func addExpense(viewModel: ExpenseViewModel, amount: Double, currency: String, description: String) {
        viewModel.addExpense(amount: amount, currency: currency, description: description)
    }
}
