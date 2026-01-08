//
//  InsightsView.swift
//  CreditPay
//
//  Created by Pankaj Kumar Rana on 06/01/26.
//

import SwiftUI
import Charts

struct InsightsView: View {
    @State private var selectedTimeRange: TimeRange = .week
    @State private var showComparison = false
    @State private var selectedCategory: CategorySpending? = nil
    
    // Mock Data
    let weeklyData: [SpendingData] = [
        SpendingData(day: "Mon", amount: 1200),
        SpendingData(day: "Tue", amount: 800),
        SpendingData(day: "Wed", amount: 1500),
        SpendingData(day: "Thu", amount: 600),
        SpendingData(day: "Fri", amount: 1800),
        SpendingData(day: "Sat", amount: 2200),
        SpendingData(day: "Sun", amount: 900)
    ]
    
    let monthlyData: [SpendingData] = [
        SpendingData(day: "Week 1", amount: 5200),
        SpendingData(day: "Week 2", amount: 8100),
        SpendingData(day: "Week 3", amount: 6800),
        SpendingData(day: "Week 4", amount: 9200)
    ]
    let yearlyData: [SpendingData] = [
        SpendingData(day: "Jan", amount: 32000),
        SpendingData(day: "Feb", amount: 28000),
        SpendingData(day: "Mar", amount: 35000),
        SpendingData(day: "Apr", amount: 30000),
        SpendingData(day: "May", amount: 42000),
        SpendingData(day: "Jun", amount: 38000),
        SpendingData(day: "Jul", amount: 46000),
        SpendingData(day: "Aug", amount: 41000),
        SpendingData(day: "Sep", amount: 39000),
        SpendingData(day: "Oct", amount: 45000),
        SpendingData(day: "Nov", amount: 48000),
        SpendingData(day: "Dec", amount: 52000)
    ]

    
    let categorySpending: [CategorySpending] = [
        CategorySpending(category: "Shopping", amount: 12000, percentage: 35, color: .purple, icon: "cart.fill"),
        CategorySpending(category: "Food", amount: 8500, percentage: 25, color: .orange, icon: "fork.knife"),
        CategorySpending(category: "Transport", amount: 4200, percentage: 12, color: .green, icon: "car.fill"),
        CategorySpending(category: "Bills", amount: 6800, percentage: 20, color: .red, icon: "doc.text.fill"),
        CategorySpending(category: "Entertainment", amount: 2800, percentage: 8, color: .pink, icon: "tv.fill")
    ]
    
    var currentData: [SpendingData] {
        switch selectedTimeRange {
        case .week:
            return weeklyData
        case .month:
            return monthlyData
        case .year:
            return yearlyData
        }
    }

    
    var totalSpending: Int {
        currentData.reduce(0) { $0 + $1.amount }
    }
    
    var averageSpending: Int {
        currentData.isEmpty ? 0 : totalSpending / currentData.count
    }
    
    var highestSpending: Int {
        currentData.map { $0.amount }.max() ?? 0
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            withAnimation {
                                showComparison.toggle()
                            }
                        } label: {
                            Label(showComparison ? "Hide Comparison" : "Show Comparison",
                                  systemImage: "chart.bar.xaxis")
                        }
                        
                        Button {
                            // Export action
                        } label: {
                            Label("Export Report", systemImage: "square.and.arrow.up")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(item: $selectedCategory) { category in
                CategoryDetailSheet(category: category)
            }
        }
    }
    
    
    private var timeRangeSelector: some View {
        HStack(spacing: 0) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTimeRange = range
                    }
                }) {
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
    
    
    private var spendingChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
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
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let amount = value.as(Int.self) {
                            if selectedTimeRange == .year {
                                Text("₹\(amount / 1000)k")
                            } else {
                                Text("₹\(amount)")
                            }
                        }
                    }
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                }
            }

            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                    AxisValueLabel()
                        .font(.caption2)
                        .foregroundStyle(Color.secondary)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(20)
    }
    
    
    private var quickStatsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            statCard(
                icon: "chart.line.uptrend.xyaxis",
                title: "Average/Day",
                value: "₹\(formatAmount(Double(averageSpending)))",
                color: .blue,
                trend: "+8%"
            )
            
            statCard(
                icon: "arrow.up.circle.fill",
                title: "Highest",
                value: "₹\(formatAmount(Double(highestSpending)))",
                color: .red,
                trend: "This week"
            )
            
            statCard(
                icon: "calendar",
                title: "Days Active",
                value: "\(currentData.count)",
                color: .green,
                trend: "This period"
            )
            
            statCard(
                icon: "star.fill",
                title: "Reward Points",
                value: "2,850",
                color: .orange,
                trend: "+120 pts"
            )
        }
    }
    
    private func statCard(icon: String, title: String, value: String, color: Color, trend: String) -> some View {
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
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.headline)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(16)
    }
    
    
    private var categoryBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Category Breakdown")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    // View all action
                } label: {
                    Text("View All")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            
            // Donut Chart
            ZStack {
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 40)
                    .frame(width: 180, height: 180)
                
                ForEach(Array(categorySpending.enumerated()), id: \.element.id) { index, category in
                    let startAngle = getStartAngle(for: index)
                    let endAngle = getEndAngle(for: index)
                    
                    Circle()
                        .trim(from: startAngle, to: endAngle)
                        .stroke(category.color, style: StrokeStyle(lineWidth: 40, lineCap: .round))
                        .frame(width: 180, height: 180)
                        .rotationEffect(.degrees(-90))
                }
                
                VStack(spacing: 4) {
                    Text("₹\(formatAmount(categorySpending.reduce(0) { $0 + $1.amount }))")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("Total Spent")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            
            // Category List
            VStack(spacing: 12) {
                ForEach(categorySpending) { category in
                    categoryRow(category: category)
                        .onTapGesture {
                            selectedCategory = category
                        }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(20)
    }
    
    private func categoryRow(category: CategorySpending) -> some View {
        HStack(spacing: 12) {
            Image(systemName: category.icon)
                .font(.title3)
                .foregroundColor(category.color)
                .frame(width: 40, height: 40)
                .background(category.color.opacity(0.15))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.category)
                    .font(.body)
                    .fontWeight(.medium)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 4)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(category.color)
                            .frame(width: geometry.size.width * (category.percentage / 100), height: 4)
                    }
                }
                .frame(height: 4)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("₹\(formatAmount(category.amount))")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("\(Int(category.percentage))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
    
    
    private var spendingInsightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Smart Insights")
                .font(.headline)
            
            VStack(spacing: 12) {
                insightCard(
                    icon: "lightbulb.fill",
                    title: "Great Progress!",
                    description: "You're spending 15% less than last month. Keep it up!",
                    color: .green
                )
                
                insightCard(
                    icon: "exclamationmark.triangle.fill",
                    title: "High Shopping Spend",
                    description: "Shopping expenses are 25% above average this week.",
                    color: .orange
                )
                
                insightCard(
                    icon: "star.fill",
                    title: "Reward Opportunity",
                    description: "Use your card for ₹500 more to unlock 200 bonus points!",
                    color: .purple
                )
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(20)
    }
    
    private func insightCard(icon: String, title: String, description: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.15))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer(minLength: 0)
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
    }
    
    
    private var budgetProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Monthly Budget")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    // Edit budget
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
            
            let budgetLimit: Double = 50000
            let currentSpent: Double = 34200
            let percentage = (currentSpent / budgetLimit) * 100
            
            VStack(spacing: 12) {
                HStack {
                    Text("₹\(formatAmount(currentSpent))")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("of ₹\(formatAmount(budgetLimit))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(Int(percentage))%")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(percentage > 80 ? .red : .blue)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 12)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: percentage > 80 ? [.red, .orange] : [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * (percentage / 100), height: 12)
                    }
                }
                .frame(height: 12)
                
                HStack {
                    Text("₹\(formatAmount(budgetLimit - currentSpent)) remaining")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("15 days left")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(20)
    }
    
    
    private func getStartAngle(for index: Int) -> CGFloat {
        var total: CGFloat = 0
        for i in 0..<index {
            total += CGFloat(categorySpending[i].percentage) / 100
        }
        return total
    }
    
    private func getEndAngle(for index: Int) -> CGFloat {
        var total: CGFloat = 0
        for i in 0...index {
            total += CGFloat(categorySpending[i].percentage) / 100
        }
        return total
    }
    
    private func formatAmount(_ amount: Double) -> String {
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
        let label = Text(title)
            .font(.subheadline)
            .fontWeight(isSelected ? .semibold : .regular)
            .foregroundStyle(isSelected ? Color.white : Color.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)

        if isSelected {
            label
                .background(
                    LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        } else {
            label
                .background(Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }
}


struct CategoryDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let category: CategorySpending
    
    let recentTransactions = [
        ("Amazon Prime", "₹999", "Today"),
        ("Flipkart", "₹2,499", "Yesterday"),
        ("Myntra", "₹1,850", "2 days ago")
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Circle()
                            .fill(category.color.opacity(0.15))
                            .frame(width: 80, height: 80)
                            .overlay {
                                Image(systemName: category.icon)
                                    .font(.system(size: 36))
                                    .foregroundColor(category.color)
                            }
                        
                        Text(category.category)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("₹\(Int(category.amount))")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(category.color)
                        
                        Text("\(Int(category.percentage))% of total spending")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical)
                    
                    // Recent Transactions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Transactions")
                            .font(.headline)
                        
                        VStack(spacing: 0) {
                            ForEach(recentTransactions, id: \.0) { transaction in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(transaction.0)
                                            .font(.body)
                                            .fontWeight(.medium)
                                        
                                        Text(transaction.2)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(transaction.1)
                                        .font(.body)
                                        .fontWeight(.semibold)
                                }
                                .padding()
                                
                                if transaction.0 != recentTransactions.last?.0 {
                                    Divider()
                                }
                            }
                        }
                        .background(Color.gray.opacity(0.08))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Category Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}



#Preview {
    InsightsView()
}
