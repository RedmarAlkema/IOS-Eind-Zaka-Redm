//
//  ExpenseViewModel.swift
//  IOS-Eind-Zaka-Redm
//
//  Created by Redmar Alkema on 25/02/2025.
//

import Foundation

struct Expense: Identifiable {
    var id: UUID = UUID()
    var amount: Double
    var currency: String
    var description: String
    var date: Date
}
