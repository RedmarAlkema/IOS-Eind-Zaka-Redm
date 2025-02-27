import SwiftUI
import Charts

struct SummaryView: View {
    @ObservedObject var viewModel = ExpenseViewModel()
    @State private var selectedPeriod: Period = .month
    @State private var selectedDate = Date()
    @State private var selectedWeek = Calendar.current.component(.weekOfYear, from: Date())
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var chartType: ChartType = .line

    enum Period: String, CaseIterable {
        case day = "Dag"
        case week = "Week"
        case month = "Maand"
        case year = "Jaar"
    }
    
    enum ChartType: String, CaseIterable {
        case line = "Lijn"
        case bar = "Balk"
    }

    var totalAmount: Double {
        filteredExpenses.reduce(0) { $0 + $1.amount }
    }

    var filteredExpenses: [Expense] {
        let calendar = Calendar.current
        return viewModel.expenses.filter { expense in
            switch selectedPeriod {
            case .day:
                return calendar.isDate(expense.date, inSameDayAs: selectedDate)
            case .week:
                return calendar.component(.weekOfYear, from: expense.date) == selectedWeek &&
                       calendar.component(.year, from: expense.date) == selectedYear
            case .month:
                return calendar.component(.month, from: expense.date) == selectedMonth &&
                       calendar.component(.year, from: expense.date) == selectedYear
            case .year:
                return calendar.component(.year, from: expense.date) == selectedYear
            }
        }
    }

    var timeUnits: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nl_NL")
        let calendar = Calendar.current
        let now = Date()

        switch selectedPeriod {
        case .day:
            return (0..<24).filter { $0 % 4 == 0 }.map { "\($0):00" }
        case .week:
            formatter.dateFormat = "E"
            return (0..<7).map { calendar.date(byAdding: .day, value: -$0, to: now)! }
                .map { formatter.string(from: $0) }
                .reversed()
        case .month:
            return (1...5).map { "Week \($0)" }
        case .year:
            return formatter.shortMonthSymbols ?? []
        }
    }

    var groupedExpenses: [String: Double] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nl_NL")

        switch selectedPeriod {
        case .day:
            formatter.dateFormat = "HH:00"
        case .week:
            formatter.dateFormat = "E"
        case .month:
            formatter.dateFormat = "'Week' W"
        case .year:
            formatter.dateFormat = "MMM"
        }

        let grouped = Dictionary(grouping: filteredExpenses) { formatter.string(from: $0.date) }
            .mapValues { $0.reduce(0) { $0 + $1.amount } }

        return Dictionary(uniqueKeysWithValues: timeUnits.map { ($0, grouped[$0] ?? 0) })
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let isLandscape = geometry.size.width > geometry.size.height
                
                if isLandscape {
                    HStack {
                        optionsView
                            .frame(width: geometry.size.width * 0.4)
                            .padding()
                        
                        chartView
                            .frame(width: geometry.size.width * 0.5)
                            .padding()
                    }
                } else {
                    VStack {
                        optionsView
                        chartView
                    }
                }
            }
            .navigationTitle("Expense Summary")
        }
    }
    
    private var optionsView: some View {
        VStack(alignment: .leading) {
            Text("Totaal: \(totalAmount, specifier: "%.2f") EUR")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Picker("Periode", selection: $selectedPeriod) {
                ForEach(Period.allCases, id: \.self) { period in
                    Text(period.rawValue).tag(period)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            Picker("Grafiektype", selection: $chartType) {
                ForEach(ChartType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            switch selectedPeriod {
            case .day:
                DatePicker("Selecteer een dag", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .padding()
            case .week:
                Stepper("Week \(selectedWeek), \(selectedYear)", value: $selectedWeek, in: 1...53)
                    .padding()
            case .month:
                Stepper("Maand: \(Calendar.current.shortMonthSymbols[selectedMonth - 1]) \(selectedYear)", value: $selectedMonth, in: 1...12)
                    .padding()
            case .year:
                Stepper("Jaar: \(selectedYear)", value: $selectedYear, in: 2000...Calendar.current.component(.year, from: Date()))
                    .padding()
            }
        }
    }
    
    private var chartView: some View {
        Chart {
            ForEach(timeUnits, id: \.self) { unit in
                if chartType == .line {
                    LineMark(
                        x: .value("Tijd", unit),
                        y: .value("Uitgaven", groupedExpenses[unit] ?? 0)
                    )
                    .foregroundStyle(.blue)
                } else {
                    BarMark(
                        x: .value("Tijd", unit),
                        y: .value("Uitgaven", groupedExpenses[unit] ?? 0)
                    )
                    .foregroundStyle(.blue)
                }
            }
        }
        .chartXAxis { AxisMarks(position: .bottom) { AxisValueLabel() } }
        .chartYAxis { AxisMarks(position: .leading) { AxisValueLabel() } }
        .frame(height: 220)
        .padding()
    }
}

#Preview {
    SummaryView(viewModel: ExpenseViewModel())
}
