//
//  AccountView.swift
//  CreditPay
//
//  Created by Pankaj Kumar Rana on 06/01/26.
//

import SwiftUI

struct AccountView: View {
    @State private var selectedCard: CreditCard?
    @State private var showFreeze = false
    @State private var isCardFrozen = false
    @State private var showCardDetails = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("My Card")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            if let card = selectedCard {
                                Text(card.name.uppercased())
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 12) {
                            headerButton(systemImage: "bell", hasNotification: true) {
                                // Notifications action
                            }
                            headerButton(systemImage: "ellipsis") {
                                // More options
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // MARK: Card Display
                    if let card = selectedCard {
                        CardDisplayView(card: card, isCardFrozen: isCardFrozen)
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        // Placeholder when no card is selected
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 220)
                            .overlay {
                                VStack(spacing: 12) {
                                    Image(systemName: "creditcard")
                                        .font(.system(size: 50))
                                        .foregroundColor(.gray)
                                    
                                    Text("No Card Selected")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                    
                                    Text("Go to Cards tab to select a card")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.horizontal)
                    }
                    
                    // MARK: Quick Stats
                    if let card = selectedCard {
                        quickStatsView(for: card)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    // MARK: Actions
                    HStack(spacing: 16) {
                        actionButton(
                            systemImage: isCardFrozen ? "snowflake.slash" : "snowflake",
                            title: isCardFrozen ? "Unfreeze" : "Freeze",
                            color: isCardFrozen ? .orange : .blue
                        ) {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                isCardFrozen.toggle()
                                showFreeze = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showFreeze = false
                                }
                            }
                        }
                        
                        actionButton(
                            systemImage: "eye",
                            title: "View",
                            color: .green
                        ) {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                            showCardDetails = true
                        }
                        
                        actionButton(
                            systemImage: "gearshape",
                            title: "Settings",
                            color: .purple
                        ) {
                            print("Settings tapped")
                        }
                        
                        actionButton(
                            systemImage: "lock.shield",
                            title: "Security",
                            color: .red
                        ) {
                            print("Security tapped")
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: Freeze Alert
                    if showFreeze {
                        freezeAlertBanner
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    // MARK: Quick Actions List
                    quickActionsList
                    
                    Spacer(minLength: 20)
                    
                    // MARK: Activation Banner
                    if selectedCard != nil {
                        activationBanner
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    Spacer()
                }
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: selectedCard?.lastFourDigits)
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isCardFrozen)
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadSelectedCard()
            }
            .sheet(isPresented: $showCardDetails) {
                if let card = selectedCard {
                    CardDetailsSheet(card: card)
                }
            }
        }
    }
    
    // MARK: - Quick Stats View
    @ViewBuilder
    private func quickStatsView(for card: CreditCard) -> some View {
        HStack(spacing: 12) {
            statCard(
                title: "Available",
                value: "₹\(formatAmount(card.remainingCredit))",
                icon: "checkmark.circle.fill",
                color: .green
            )
            
            statCard(
                title: "Spent",
                value: "₹\(formatAmount(card.spentAmount))",
                icon: "arrow.up.circle.fill",
                color: .red
            )
            
            statCard(
                title: "Points",
                value: "\(card.rewardPoints)",
                icon: "star.fill",
                color: .orange
            )
        }
        .padding(.horizontal)
    }
    
    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.08))
        .cornerRadius(12)
    }
    
    // MARK: - Freeze Alert Banner
    private var freezeAlertBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: isCardFrozen ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                .font(.title3)
                .foregroundColor(isCardFrozen ? .green : .orange)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(isCardFrozen ? "Card Frozen" : "Card Active")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(isCardFrozen ? "All transactions are blocked" : "Card is ready to use")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(isCardFrozen ? Color.blue.opacity(0.1) : Color.green.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    // MARK: - Quick Actions List
    private var quickActionsList: some View {
        VStack(spacing: 0) {
            quickActionRow(icon: "plus.circle.fill", title: "Add Money", subtitle: "Top up your card", color: .blue)
            Divider().padding(.leading, 60)
            
            quickActionRow(icon: "arrow.left.arrow.right", title: "Transfer", subtitle: "Send to bank account", color: .purple)
            Divider().padding(.leading, 60)
            
            quickActionRow(icon: "doc.text.fill", title: "Statements", subtitle: "View transaction history", color: .green)
            Divider().padding(.leading, 60)
            
            quickActionRow(icon: "chart.bar.fill", title: "Spending Analysis", subtitle: "Track your expenses", color: .orange)
        }
        .background(Color.gray.opacity(0.08))
        .cornerRadius(16)
        .padding(.horizontal)
    }
    
    private func quickActionRow(icon: String, title: String, subtitle: String, color: Color) -> some View {
        Button {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        } label: {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.15))
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
    
    // MARK: - Activation Banner
    private var activationBanner: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "shippingbox.fill")
                            .foregroundColor(.orange)
                        
                        Text("Physical Card")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    
                    Text("Expected arrival: 10–15 Jan 2026")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            Button {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            } label: {
                Text("Track Shipment")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.orange, .yellow],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    // MARK: - Header Button
    private func headerButton(systemImage: String, hasNotification: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: systemImage)
                    .font(.body)
                    .foregroundColor(.primary)
                    .frame(width: 40, height: 40)
                    .background(Color.gray.opacity(0.15))
                    .clipShape(Circle())
                
                if hasNotification {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .offset(x: 2, y: 2)
                }
            }
        }
    }
    
    // MARK: - Action Button
    private func actionButton(
        systemImage: String,
        title: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 50, height: 50)
                    .background(color.opacity(0.15))
                    .clipShape(Circle())
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Load Selected Card
    private func loadSelectedCard() {
        // This would typically load from UserDefaults or AppStorage
        // For now, we'll use the default card
        selectedCard = CreditCard(
            name: "neo",
            lastFourDigits: "1234",
            color: .black,
            gradient: [.black, .gray.opacity(0.8)],
            creditLimit: 100000,
            spentAmount: 45000,
            rewardPoints: 2850,
            transactionLimit: 50000,
            availableCredit: 55000
        )
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

// MARK: - Card Display View
struct CardDisplayView: View {
    let card: CreditCard
    let isCardFrozen: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                LinearGradient(
                    colors: isCardFrozen ? [.gray, .gray.opacity(0.6)] : card.gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(height: 220)
            .shadow(color: card.color.opacity(0.3), radius: 12, y: 6)
            .overlay {
                if isCardFrozen {
                    Color.white.opacity(0.3)
                        .cornerRadius(20)
                }
            }
            .overlay(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(card.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                        
                        Spacer()
                        
                        if isCardFrozen {
                            HStack(spacing: 4) {
                                Image(systemName: "snowflake")
                                    .font(.caption)
                                Text("FROZEN")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(8)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("CARD NUMBER")
                            .font(.caption2)
                            .opacity(0.7)
                        
                        Text("**** **** **** \(card.lastFourDigits)")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("CARD HOLDER")
                                .font(.caption2)
                                .opacity(0.7)
                            
                            Text("Pankaj K. Rana")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("EXPIRES")
                                .font(.caption2)
                                .opacity(0.7)
                            
                            Text("12/28")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        
                        Image(systemName: "wave.3.right")
                            .font(.title)
                            .opacity(0.5)
                            .padding(.leading, 8)
                    }
                }
                .foregroundColor(.white)
                .padding(20)
            }
            .padding(.horizontal)
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isCardFrozen)
    }
}

// MARK: - Card Details Sheet
struct CardDetailsSheet: View {
    @Environment(\.dismiss) var dismiss
    let card: CreditCard
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Card Number Details
                    detailSection(
                        title: "Card Number",
                        value: "**** **** **** \(card.lastFourDigits)",
                        icon: "creditcard"
                    )
                    
                    detailSection(
                        title: "CVV",
                        value: "***",
                        icon: "lock.shield"
                    )
                    
                    detailSection(
                        title: "Expiry Date",
                        value: "12/28",
                        icon: "calendar"
                    )
                    
                    detailSection(
                        title: "Card Type",
                        value: card.name.uppercased(),
                        icon: "star.fill"
                    )
                }
                .padding()
            }
            .navigationTitle("Card Details")
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
    
    private func detailSection(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 44, height: 44)
                .background(Color.blue.opacity(0.15))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.headline)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.08))
        .cornerRadius(12)
    }
}

#Preview {
    AccountView()
}

