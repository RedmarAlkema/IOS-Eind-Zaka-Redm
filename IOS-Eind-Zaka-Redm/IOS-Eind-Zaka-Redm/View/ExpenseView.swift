//
//  ExpenseView 2.swift
//  IOS-Eind-Zaka-Redm
//
//  Created by Redmar Alkema on 27/02/2025.
//


import SwiftUI

struct ExpenseView: View {
    @ObservedObject var viewModel = ExpenseViewModel()
    @State private var showAddExpense = false

    var body: some View {
        NavigationView {
            List(viewModel.expenses) { expense in
                NavigationLink(destination: EditExpenseView(expense: expense, viewModel: viewModel)) {
                    HStack {
                        Image(systemName: "creditcard.fill")
                            .foregroundColor(.blue)

                        VStack(alignment: .leading) {
                            Text(expense.description)
                                .font(.headline)
                            Text("\(expense.amount, specifier: "%.2f") \(expense.currency)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(expense.date.formatted(date: .numeric, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("My Expenses")
            .toolbar {
                Button(action: { showAddExpense = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                }
            }
            .sheet(isPresented: $showAddExpense) {
                AddExpenseView(viewModel: viewModel)
            }
        }
    }
}
