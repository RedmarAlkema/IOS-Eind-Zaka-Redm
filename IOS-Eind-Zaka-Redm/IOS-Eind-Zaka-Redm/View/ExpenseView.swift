//
//  ExpenseView.swift
//  IOS-Eind-Zaka-Redm
//
//  Created by Redmar Alkema on 25/02/2025.
//

import SwiftUI

struct ExpenseView: View {
    @ObservedObject var viewModel = ExpenseViewModel()
    @State private var showAddExpense = false

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.expenses) { expense in
                    HStack {
                        Image(systemName: "creditcard.fill")
                            .foregroundColor(.blue)

                        VStack(alignment: .leading) {
                            Text(expense.description)
                                .font(.headline)
                            Text("\(expense.amount, specifier: "%.2f") \(expense.currency)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(formatDate(expense.date))
                                .font(.caption)
                                .foregroundColor(.blue)
                            Text(formatTime(expense.date))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 5)
                }
                .navigationTitle("My Expenses")
                .toolbar {
                    Button(action: { showAddExpense = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                }
            }
            .sheet(isPresented: $showAddExpense) {
                AddExpenseView(viewModel: viewModel)
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
}


#Preview {
    ExpenseView()
}
