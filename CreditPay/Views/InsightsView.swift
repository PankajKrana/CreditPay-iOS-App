//
//  InsightsView.swift
//  CreditPay
//
//  Created by Pankaj Kumar Rana on 06/01/26.
//

import SwiftUI
import Charts

struct InsightsView: View {

    // MARK: State
    @State private var selectedTimeRange: TimeRange = .week
    @State private var showComparison = false
    @State private var selectedCategory: CategorySpending?

    // MARK: Mock Spending Data
    let weeklyData: [SpendingData] = [
        .init(day: "Mon", amount: 650),
        .init(day: "Tue", amount: 800),
        .init(day: "Wed", amount: 1000),
        .init(day: "Thu", amount: 600),
        .init(day: "Fri", amount: 700),
        .init(day: "Sat", amount: 2200),
        .init(day: "Sun", amount: 3000)
    ]

    let monthlyData: [SpendingData] = [
        .init(day: "Week 1", amount: 5200),
        .init(day: "Week 2", amount: 8100),
        .init(day: "Week 3", amount: 6800),
        .init(day: "Week 4", amount: 9200)
        
    ]

    let yearlyData: [SpendingData] = [
        .init(day: "Jan", amount: 32000),
        .init(day: "Feb", amount: 28000),
        .init(day: "Mar", amount: 35000),
        .init(day: "Apr", amount: 30000),
        .init(day: "May", amount: 42000),
        .init(day: "Jun", amount: 38000),
        .init(day: "Jul", amount: 46000),
        .init(day: "Aug", amount: 41000),
        .init(day: "Sep", amount: 39000),
        .init(day: "Oct", amount: 45000),
        .init(day: "Nov", amount: 48000),
        .init(day: "Dec", amount: 52000)
    ]

    let categorySpending: [CategorySpending] = [
        .init(category: "Shopping", amount: 12000, percentage: 35, color: .purple, icon: "cart.fill"),
        .init(category: "Food", amount: 8500, percentage: 25, color: .orange, icon: "fork.knife"),
        .init(category: "Transport", amount: 4200, percentage: 12, color: .green, icon: "car.fill"),
        .init(category: "Bills", amount: 6800, percentage: 20, color: .red, icon: "doc.text.fill"),
        .init(category: "Entertainment", amount: 2800, percentage: 8, color: .pink, icon: "tv.fill")
    ]

    
    var currentData: [SpendingData] {
        switch selectedTimeRange {
        case .week: return weeklyData
        case .month: return monthlyData
        case .year: return yearlyData
        }
    }

    var totalSpending: Int {
        currentData.reduce(0) { $0 + $1.amount }
    }

    var averageSpending: Int {
        currentData.isEmpty ? 0 : totalSpending / currentData.count
    }

    var highestSpending: Int {
        currentData.map(\.amount).max() ?? 0
    }

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    timeRangeSelector
                    spendingChartSection
                    quickStatsGrid
                    categoryBreakdownSection
                    spendingInsightsSection
                    budgetProgressSection
                }
                .padding()
            }
            .navigationTitle("Insights")
            .navigationBarTitleDisplayMode(.large)
            .toolbar { toolbarMenu }
        }
        .sheet(item: $selectedCategory) {
            CategoryDetailSheet(category: $0)
        }
    }
}


private extension InsightsView {
    var toolbarMenu: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Button {
                    withAnimation { showComparison.toggle() }
                } label: {
                    Label(
                        showComparison ? "Hide Comparison" : "Show Comparison",
                        systemImage: "chart.bar.xaxis"
                    )
                }

                Button { } label: {
                    Label("Export Report", systemImage: "square.and.arrow.up")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
}

// MARK: - Time Range Selector
private extension InsightsView {
    var timeRangeSelector: some View {
        HStack(spacing: 0) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Button {
                    let feedback = UIImpactFeedbackGenerator(style: .light)
                    feedback.impactOccurred()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTimeRange = range
                    }
                } label: {
                    TimeRangeButtonLabel(
                        title: range.rawValue,
                        isSelected: selectedTimeRange == range
                    )
                }
            }
        }
        .padding(4)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(12)
    }
}


private extension InsightsView {
    var spendingChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {

            headerView

            Chart {
                ForEach(currentData) { data in
                    BarMark(
                        x: .value("Day", data.day),
                        y: .value("Amount", data.amount)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .cornerRadius(8)
                }
            }
            .frame(height: 220)
            .chartYAxis { yAxis }
            .chartXAxis { xAxis }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(20)
    }

    var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Total Spending")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("₹\(formatAmount(Double(totalSpending)))")
                    .font(.title)
                    .fontWeight(.bold)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.right")
                        .font(.caption2)
                    Text("+12%")
                        .font(.caption)
                }
                .foregroundColor(.green)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.green.opacity(0.15))
                .cornerRadius(8)

                Text("vs last \(selectedTimeRange.rawValue.lowercased())")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }

    var yAxis: some AxisContent {
        AxisMarks(position: .leading) { value in
            AxisValueLabel {
                if let amount = value.as(Int.self) {
                    Text(selectedTimeRange == .year ? "₹\(amount / 1000)k" : "₹\(amount)")
                }
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
    }

    var xAxis: some AxisContent {
        AxisMarks(position: .bottom) { _ in
            AxisValueLabel()
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}


private extension InsightsView {
    var quickStatsGrid: some View {
        LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 16) {
            statCard("chart.line.uptrend.xyaxis", "Average/Day", averageSpending, .blue, "+8%")
            statCard("arrow.up.circle.fill", "Highest", highestSpending, .red, "This week")
            statCard("calendar", "Days Active", currentData.count, .green, "This period")
            statCard("star.fill", "Reward Points", 2850, .orange, "+120 pts")
        }
    }

    func statCard(_ icon: String, _ title: String, _ value: Int, _ color: Color, _ trend: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                Spacer()
                Text(trend)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text("₹\(formatAmount(Double(value)))")
                .font(.headline)
                .fontWeight(.bold)
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(16)
    }
}

// MARK: - Category Breakdown
private extension InsightsView {
    var categoryBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Category Breakdown")
                .font(.headline)

            ForEach(categorySpending) { category in
                categoryRow(category)
                    .onTapGesture { selectedCategory = category }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(20)
    }

    func categoryRow(_ category: CategorySpending) -> some View {
        HStack(spacing: 12) {
            Image(systemName: category.icon)
                .foregroundColor(category.color)
                .frame(width: 40, height: 40)
                .background(category.color.opacity(0.15))
                .cornerRadius(10)

            VStack(alignment: .leading) {
                Text(category.category)
                    .fontWeight(.medium)
                ProgressView(value: category.percentage / 100)
                    .tint(category.color)
            }

            Spacer()

            Text("₹\(formatAmount(category.amount))")
                .fontWeight(.semibold)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - Insights
private extension InsightsView {
    var spendingInsightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Smart Insights")
                .font(.headline)

            insightCard("lightbulb.fill", "Great Progress!", "You're spending 15% less than last month.", .green)
            insightCard("exclamationmark.triangle.fill", "High Shopping Spend", "Shopping expenses are above average.", .orange)
            insightCard("star.fill", "Reward Opportunity", "Spend ₹500 more to unlock 200 points.", .purple)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(20)
    }

    func insightCard(_ icon: String, _ title: String, _ desc: String, _ color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.15))
                .cornerRadius(12)

            VStack(alignment: .leading) {
                Text(title).fontWeight(.semibold)
                Text(desc).font(.caption).foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Budget
private extension InsightsView {
    var budgetProgressSection: some View {

        let budgetLimit: Double = 50000
        let currentSpent: Double = 34200
        let progress = currentSpent / budgetLimit

        return VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Budget")
                .font(.headline)

            ProgressView(value: progress)
                .tint(progress > 0.8 ? .red : .blue)

            HStack {
                Text("₹\(formatAmount(currentSpent))")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text("of ₹\(formatAmount(budgetLimit))")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(progress > 0.8 ? .red : .blue)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(20)
    }
}


// helper
private extension InsightsView {
    func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale(identifier: "en_IN")
        return formatter.string(from: NSNumber(value: amount)) ?? "\(Int(amount))"
    }
}



struct TimeRangeButtonLabel: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(isSelected ? .semibold : .regular)
            .foregroundColor(isSelected ? .white : .primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        isSelected
                        ? AnyShapeStyle(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                        : AnyShapeStyle(Color.clear)
                    )
            )
    }
}

// Category Detail Sheet

struct CategoryDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let category: CategorySpending

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(category.category)
                    .font(.title)
                Text("₹\(Int(category.amount))")
                    .font(.title2)
            }
            .navigationTitle("Category Details")
            .toolbar {
                Button("Done") { dismiss() }
            }
        }
    }
}
enum TimeRange: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}



#Preview {
    InsightsView()
}

