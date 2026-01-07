//
//  PaymentsView.swift
//  CreditPay
//
//  Created by Pankaj Kumar Rana on 06/01/26.
//

import SwiftUI

enum PaymentCategory: String, CaseIterable {
    case all = "All"
    case shopping = "Shopping"
    case food = "Food"
    case transport = "Transport"
    case subscription = "Subscription"
    case bills = "Bills"
    case income = "Income"
    
    var icon: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .shopping: return "cart.fill"
        case .food: return "fork.knife"
        case .transport: return "car.fill"
        case .subscription: return "arrow.triangle.2.circlepath"
        case .bills: return "doc.text.fill"
        case .income: return "dollarsign.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .all: return .blue
        case .shopping: return .purple
        case .food: return .orange
        case .transport: return .green
        case .subscription: return .pink
        case .bills: return .red
        case .income: return .cyan
        }
    }
}

struct PaymentsView: View {
    @State private var selectedCategory: PaymentCategory = .all
    @State private var searchText = ""
    @State private var showFilters = false
    @State private var selectedPayment: Payment? = nil
    @State private var showMonthPicker = false
    @State private var selectedMonth = Date()
    
    // MARK: Mock Data
    let payments: [Payment] = [
        Payment.mock(title: "Amazon", subtitle: "Shopping", amount: -1299, date: "Today"),
        Payment.mock(title: "Netflix", subtitle: "Subscription", amount: -499, date: "Yesterday"),
        Payment.mock(title: "Salary", subtitle: "Monthly Credit", amount: 45000, date: "01 Jan"),
        Payment.mock(title: "Zomato", subtitle: "Food Order", amount: -320, date: "31 Dec"),
        Payment.mock(title: "Uber", subtitle: "Ride Payment", amount: -210, date: "30 Dec"),
        Payment.mock(title: "Electricity Bill", subtitle: "Utility", amount: -1450, date: "28 Dec"),
        Payment.mock(title: "Flipkart", subtitle: "Electronics", amount: -8999, date: "27 Dec"),
        Payment.mock(title: "Swiggy", subtitle: "Food Delivery", amount: -580, date: "26 Dec"),
        Payment.mock(title: "Metro Card", subtitle: "Transport", amount: -500, date: "25 Dec"),
        Payment.mock(title: "Spotify", subtitle: "Music Subscription", amount: -119, date: "24 Dec")
    ]
    
    var filteredPayments: [Payment] {
        var filtered = payments
        
        // Filter by category
        if selectedCategory != .all {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        // Filter by search
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.subtitle.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    var totalSpent: Double {
        Double(payments.filter { $0.amount < 0 }.reduce(0) { $0 + $1.amount })
    }
    
    var totalIncome: Double {
        Double(payments.filter { $0.amount > 0 }.reduce(0) { $0 + $1.amount })
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: Summary Cards
                summarySection
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                // MARK: Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(PaymentCategory.allCases, id: \.self) { category in
                            categoryChip(category)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                .background(Color(uiColor: .systemBackground))
                
                // MARK: Payments List
                if filteredPayments.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(groupedPayments.keys.sorted(by: >), id: \.self) { date in
                                Section {
                                    ForEach(groupedPayments[date] ?? []) { payment in
                                        PaymentRowView(payment: payment)
                                            .onTapGesture {
                                                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                                                impactFeedback.impactOccurred()
                                                selectedPayment = payment
                                            }
                                    }
                                } header: {
                                    HStack {
                                        Text(date)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    .padding(.top, 16)
                                    .padding(.bottom, 8)
                                    .background(Color(uiColor: .systemBackground))
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search transactions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            showMonthPicker = true
                        } label: {
                            Label("Select Month", systemImage: "calendar")
                        }
                        
                        Button {
                            // Export action
                        } label: {
                            Label("Export PDF", systemImage: "square.and.arrow.up")
                        }
                        
                        Button {
                            showFilters = true
                        } label: {
                            Label("Advanced Filters", systemImage: "line.3.horizontal.decrease.circle")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.body)
                    }
                }
            }
            .sheet(item: $selectedPayment) { payment in
                PaymentDetailSheet(payment: payment)
            }
        }
    }
    
    // MARK: - Summary Section
    private var summarySection: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.down.circle.fill")
                        .foregroundColor(.green)
                    Text("Income")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text("₹\(formatAmount(abs(totalIncome)))")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(.red)
                    Text("Expenses")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text("₹\(formatAmount(abs(totalSpent)))")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.red.opacity(0.1))
            .cornerRadius(16)
        }
    }
    
    // MARK: - Category Chip
    private func categoryChip(_ category: PaymentCategory) -> some View {
        Button {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedCategory = category
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.caption)
                
                Text(category.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                selectedCategory == category ?
                category.color : Color.gray.opacity(0.15)
            )
            .foregroundColor(
                selectedCategory == category ? .white : .primary
            )
            .cornerRadius(20)
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No Transactions Found")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Try adjusting your filters or search")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxHeight: .infinity)
        .padding()
    }
    
    // MARK: - Grouped Payments
    private var groupedPayments: [String: [Payment]] {
        Dictionary(grouping: filteredPayments) { $0.date }
    }
    
    // MARK: - Helper Functions
    private func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale(identifier: "en_IN")
        return formatter.string(from: NSNumber(value: amount)) ?? "\(Int(amount))"
    }
}

struct PaymentRowView: View {
    let payment: Payment
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Circle()
                .fill(payment.category.color.opacity(0.15))
                .frame(width: 48, height: 48)
                .overlay {
                    Image(systemName: payment.category.icon)
                        .foregroundColor(payment.category.color)
                        .font(.title3)
                }
            
            // Title + Subtitle
            VStack(alignment: .leading, spacing: 4) {
                Text(payment.title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(payment.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Amount
            VStack(alignment: .trailing, spacing: 4) {
                Text(formattedAmount)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(payment.amount < 0 ? .red : .green)
                
                Text(payment.date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
    }
    
    private var formattedAmount: String {
        let sign = payment.amount < 0 ? "-" : "+"
        return "\(sign)₹\(abs(payment.amount))"
    }
}

// MARK: - Payment Detail Sheet
struct PaymentDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let payment: Payment
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Amount Section
                    VStack(spacing: 12) {
                        Circle()
                            .fill(payment.category.color.opacity(0.15))
                            .frame(width: 80, height: 80)
                            .overlay {
                                Image(systemName: payment.category.icon)
                                    .font(.system(size: 36))
                                    .foregroundColor(payment.category.color)
                            }
                        
                        Text(payment.amount < 0 ? "-₹\(abs(payment.amount))" : "+₹\(abs(payment.amount))")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(payment.amount < 0 ? .red : .green)
                        
                        Text(payment.title)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(payment.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 20)
                    
                    // Details Section
                    VStack(spacing: 0) {
                        detailRow(icon: "calendar", title: "Date", value: payment.date)
                        Divider().padding(.leading, 52)
                        
                        detailRow(icon: "tag.fill", title: "Category", value: payment.category.rawValue)
                        Divider().padding(.leading, 52)
                        
                        detailRow(icon: "number", title: "Transaction ID", value: "TXN\(Int.random(in: 100000...999999))")
                        Divider().padding(.leading, 52)
                        
                        detailRow(icon: "checkmark.circle.fill", title: "Status", value: "Completed")
                    }
                    .background(Color.gray.opacity(0.08))
                    .cornerRadius(16)
                    
                    // Actions
                    VStack(spacing: 12) {
                        actionButton(icon: "square.and.arrow.up", title: "Share Receipt", color: .blue)
                        actionButton(icon: "exclamationmark.circle", title: "Report Issue", color: .red)
                    }
                }
                .padding()
            }
            .navigationTitle("Transaction Details")
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
    
    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 36)
            
            Text(title)
                .font(.body)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
        .padding()
    }
    
    private func actionButton(icon: String, title: String, color: Color) -> some View {
        Button {
            // Action
        } label: {
            HStack {
                Image(systemName: icon)
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
            }
            .font(.body)
            .fontWeight(.medium)
            .foregroundColor(color)
            .padding()
            .background(color.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

// MARK: - Updated Payment Model
extension Payment {
    static func mock(title: String, subtitle: String, amount: Int, date: String) -> Payment {
        var payment = Payment(title: title, subtitle: subtitle, amount: amount, date: date)
        // If Payment doesn't have a memberwise init with these labels, adjust as needed in the model file.
        return payment
    }
    
    var category: PaymentCategory {
        get {
            if subtitle.contains("Shopping") || subtitle.contains("Electronics") {
                return .shopping
            } else if subtitle.contains("Food") || subtitle.contains("Delivery") {
                return .food
            } else if subtitle.contains("Ride") || subtitle.contains("Transport") {
                return .transport
            } else if subtitle.contains("Subscription") || subtitle.contains("Music") {
                return .subscription
            } else if subtitle.contains("Bill") || subtitle.contains("Utility") {
                return .bills
            } else if subtitle.contains("Credit") || subtitle.contains("Salary") {
                return .income
            }
            return .all
        }
    }
}

#Preview {
    PaymentsView()
}

