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
            }.navigationTitle("Expense Summary")
        }
    }
}

#Preview {
    SummaryView()
}
