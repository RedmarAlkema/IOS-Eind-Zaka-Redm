import Foundation
import CoreLocation

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var exchangeRates: [String: Double] = [:]
    
    private let transactionController = TransactionController()
    private let exchangeService = ExchangeRateService()
    
    init() {
        loadExpenses()
        fetchExchangeRates(baseCurrency: "EUR") // Basisvaluta
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
    
    func convertAmount(amount: Double, from fromCurrency: String, to toCurrency: String) -> Double? {
        guard let fromRate = exchangeRates[fromCurrency], let toRate = exchangeRates[toCurrency] else {
            return nil // ✅ Geef nil terug als conversie niet mogelijk is
        }
        return (amount / fromRate) * toRate
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
    
    // 📌 **Wisselkoers API ophalen**
    func fetchExchangeRates(baseCurrency: String) {
        exchangeService.fetchExchangeRates(baseCurrency: baseCurrency) { rates in
            DispatchQueue.main.async {
                self.exchangeRates = rates
            }
        }
    }

    // 📌 **Valutaconversie**
    func convertAmount(amount: Double, from fromCurrency: String, to toCurrency: String) -> Double {
        guard let fromRate = exchangeRates[fromCurrency], let toRate = exchangeRates[toCurrency] else {
            return amount // Geen conversie mogelijk
        }
        return (amount / fromRate) * toRate
    }
}
