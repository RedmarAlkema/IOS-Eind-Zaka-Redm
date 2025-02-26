//
//  MainTabView.swift
//  IOS-Eind-Zaka-Redm
//
//  Created by Redmar Alkema on 25/02/2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ExpenseView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Expenses")
                }

            SummaryView()
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("Summary")
                }
        }
    }
}

#Preview {
    MainTabView()
}
