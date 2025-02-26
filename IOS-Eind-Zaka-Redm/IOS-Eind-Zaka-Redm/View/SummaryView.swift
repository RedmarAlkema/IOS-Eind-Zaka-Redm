//
//  SummaryView.swift
//  IOS-Eind-Zaka-Redm
//
//  Created by Redmar Alkema on 25/02/2025.
//

import SwiftUI

struct SummaryView: View {
    @ObservedObject var viewModel = ExpenseViewModel()

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.totalPerCurrency(), id: \.key) { currency, total in
                    HStack {
                        Text(currency)
                            .font(.headline)
                        Spacer()
                        Text("\(total, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                }
                .navigationTitle("Expense Summary")
            }
        }
    }
}

#Preview {
    SummaryView()
}
