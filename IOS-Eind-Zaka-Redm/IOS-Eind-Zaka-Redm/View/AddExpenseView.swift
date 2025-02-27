import SwiftUI

struct AddExpenseView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var amount: String = ""
    @State private var currency: String = "USD"
    @State private var description: String = ""

    @Environment(\.presentationMode) var presentationMode
    private let transactionController = TransactionController()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Amount", text: $amount)

                    Picker("Currency", selection: $currency) {
                        Text("THB (Baht)").tag("THB")
                        Text("MYR (Ringgit)").tag("MYR")
                        Text("JPY (Yen)").tag("JPY")
                        Text("EUR (Euro)").tag("EUR")
                        Text("USD (Dollar)").tag("USD")
                    }
                    .pickerStyle(MenuPickerStyle())

                    TextField("Description", text: $description)
                }

                Section {
                    Button(action: {
                        if let amountValue = Double(amount) {
                            let newExpense = Expense(amount: amountValue, currency: currency, description: description, date: Date())
                            transactionController.addExpense(expense: newExpense, expenses: &viewModel.expenses)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Add Expense")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("New Expense")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}
