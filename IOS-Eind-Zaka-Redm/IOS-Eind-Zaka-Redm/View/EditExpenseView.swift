import SwiftUI
import MapKit

struct EditExpenseView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var expense: Expense

    @Environment(\.presentationMode) var presentationMode

    init(expense: Expense, viewModel: ExpenseViewModel) {
        self._expense = State(initialValue: expense)
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Expense")) {
                    TextField("Amount", value: $expense.amount, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)

                    Picker("Currency", selection: $expense.currency) {
                        Text("THB (Baht)").tag("THB")
                        Text("MYR (Ringgit)").tag("MYR")
                        Text("JPY (Yen)").tag("JPY")
                        Text("EUR (Euro)").tag("EUR")
                        Text("USD (Dollar)").tag("USD")
                    }
                    .pickerStyle(MenuPickerStyle())

                    TextField("Description", text: $expense.description)
                }

                if let location = expense.location {
                    Section(header: Text("Purchase Location")) {
                        MapView(coordinate: location.toCoordinate())
                            .frame(height: 200)
                            .cornerRadius(10)
                    }
                }

                Section {
                    Button(action: {
                        viewModel.updateExpense(updatedExpense: expense)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        viewModel.deleteExpense(expense: expense)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Delete Expense")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("Edit Expense")
        }
    }
}
