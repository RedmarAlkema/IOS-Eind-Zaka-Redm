import SwiftUI
import CoreLocation

struct AddExpenseView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var amount: String = ""
    @State private var currency: String = "USD"
    @State private var description: String = ""
    @State private var location: CLLocationCoordinate2D?

    @Environment(\.presentationMode) var presentationMode
    private let locationManager = LocationManager()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)

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
                            locationManager.requestLocation { coordinates in
                                viewModel.addExpense(amount: amountValue, currency: currency, description: description, location: coordinates)
                                presentationMode.wrappedValue.dismiss()
                            }
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
            .onAppear {
                locationManager.requestLocation { coordinates in
                    self.location = coordinates
                }
            }
        }
    }
}
