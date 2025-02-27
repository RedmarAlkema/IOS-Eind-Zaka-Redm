import Foundation

class TransactionController {
    private let fileName = "expenses.json"

    func saveExpenses(expenses: [Expense]) {
        do {
            let data = try JSONEncoder().encode(expenses)
            let url = getDocumentsDirectory().appendingPathComponent(fileName)
            try data.write(to: url)
        } catch {
            print("Fout bij opslaan van uitgaven: \(error)")
        }
    }

    func loadExpenses() -> [Expense] {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: url)
            let expenses = try JSONDecoder().decode([Expense].self, from: data)
            return expenses
        } catch {
            print("Geen opgeslagen uitgaven gevonden of fout bij laden: \(error)")
            return []
        }
    } 

    func addExpense(expense: Expense, expenses: inout [Expense]) {
        expenses.append(expense)
        saveExpenses(expenses: expenses)
    }

    func updateExpense(updatedExpense: Expense, expenses: inout [Expense]) {
        if let index = expenses.firstIndex(where: { $0.id == updatedExpense.id }) {
            expenses[index] = updatedExpense
            saveExpenses(expenses: expenses)
        }
    }

    func deleteExpense(expense: Expense, expenses: inout [Expense]) {
        expenses.removeAll { $0.id == expense.id }
        saveExpenses(expenses: expenses)
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
