import SwiftUI

struct ExpenseView: View {
    @ObservedObject var viewModel = ExpenseViewModel()

    @State private var selectedCurrency: String = "EUR" // ✅ Default to EUR
    @State private var showAddExpense = false // ✅ For the add expense button

    var body: some View {
        NavigationView {
            VStack {
                // 🔻 Dropdown menu for currency selection
                Picker("Toon in:", selection: $selectedCurrency) {
                    ForEach(viewModel.exchangeRates.keys.sorted(), id: \.self) { currency in
                        let symbol = currencySymbol(for: currency) ?? "" // ✅ Get symbol or empty string
                        Text(symbol.isEmpty ? currency : "\(symbol) \(currency)").tag(currency)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)

                List(viewModel.expenses) { expense in
                    NavigationLink(destination: EditExpenseView(expense: expense, viewModel: viewModel)) {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            // 📌 Description & date
                            VStack(alignment: .leading) {
                                Text(expense.description)
                                    .font(.headline)

                                Text(expense.date, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()

                            // 📌 Original amount (Blue) + Converted amount (Small & Gray)
                            VStack(alignment: .trailing) {
                                // 🔹 Original amount (Blue)
                                Text("\(currencySymbol(for: expense.currency) ?? "")\(formattedAmount(expense.amount)) \(expense.currency)")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue) // ✅ Terug naar blauw!

                                // 🔹 Converted amount (Small & Gray)
                                if let convertedAmount = viewModel.convertAmount(amount: expense.amount, from: expense.currency, to: selectedCurrency) {
                                    Text("≈ \(currencySymbol(for: selectedCurrency) ?? "")\(formattedAmount(convertedAmount)) \(selectedCurrency)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                } else {
                                    Text("🚨 Geen koers")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }}
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }

                // 🔹 Add expense button at the bottom
                Button(action: { showAddExpense = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Uitgave toevoegen")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .sheet(isPresented: $showAddExpense) {
                    AddExpenseView(viewModel: viewModel)
                }
            }
            .navigationTitle("Mijn Uitgaven")
            .onAppear {
                // ✅ Set default currency to first expense currency if available
                if selectedCurrency == "EUR", let firstExpense = viewModel.expenses.first {
                    selectedCurrency = firstExpense.currency
                }
            }
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    // 📌 Helper function to format numbers
    private func formattedAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }

    // 📌 Helper function to map currency codes to symbols
    private func currencySymbol(for currency: String) -> String? {
        let symbols: [String: String] = [
            "EUR": "€", "USD": "$", "GBP": "£", "JPY": "¥", "THB": "฿", "MYR": "RM",
            "AUD": "A$", "CAD": "C$", "CHF": "CHF", "CNY": "¥", "HKD": "HK$", "INR": "₹",
            "KRW": "₩", "MXN": "Mex$", "NOK": "kr", "NZD": "NZ$", "PHP": "₱", "RUB": "₽",
            "SEK": "kr", "SGD": "S$", "ZAR": "R"
        ]
        return symbols[currency] // ✅ Returns nil if no symbol is available
    }
}
