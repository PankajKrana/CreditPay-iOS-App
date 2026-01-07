//
//  CardView.swift
//  CreditPay
//
//  Created by Pankaj Kumar Rana on 06/01/26.
//

import SwiftUI

struct CardView: View {
    @State private var isExpanded = false
    @State private var selectedCard: CreditCard
    @State private var showCardDetails = false
    @State private var dragOffset: CGSize = .zero
    @State private var cardRotation: Double = 0
    @State private var cardScale: CGFloat = 1.0
    @Namespace private var animation
    
    let cards: [CreditCard] = [
        CreditCard(
            name: "neo",
            lastFourDigits: "1234",
            color: .black,
            gradient: [.black, .gray.opacity(0.8)],
            creditLimit: 100000,
            spentAmount: 45000,
            rewardPoints: 2850,
            transactionLimit: 50000,
            availableCredit: 55000
        ),
        CreditCard(
            name: "platinum",
            lastFourDigits: "5678",
            color: .purple,
            gradient: [.purple, .blue],
            creditLimit: 200000,
            spentAmount: 85000,
            rewardPoints: 5420,
            transactionLimit: 100000,
            availableCredit: 115000
        ),
        CreditCard(
            name: "gold",
            lastFourDigits: "9012",
            color: .orange,
            gradient: [.orange, .yellow],
            creditLimit: 150000,
            spentAmount: 62000,
            rewardPoints: 3890,
            transactionLimit: 75000,
            availableCredit: 88000
        ),
        CreditCard(
            name: "silver",
            lastFourDigits: "3456",
            color: .gray,
            gradient: [.gray, .white.opacity(0.8)],
            creditLimit: 50000,
            spentAmount: 18000,
            rewardPoints: 1250,
            transactionLimit: 25000,
            availableCredit: 32000
        )
    ]
    
    init() {
        let defaultCard = CreditCard(
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
        _selectedCard = State(initialValue: defaultCard)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if isExpanded {
                        expandedCardsView
                    } else {
                        if showCardDetails {
                            cardDetailsView
                        } else {
                            singleCardView
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(showCardDetails ? "Card Details" : "My Cards")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if showCardDetails {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                showCardDetails = false
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Single Card View
    private var singleCardView: some View {
        VStack(spacing: 16) {
            cardContent(for: selectedCard, index: 0, isInteractive: true)
                .matchedGeometryEffect(id: selectedCard.id, in: animation)
                .scaleEffect(cardScale)
                .rotation3DEffect(
                    .degrees(cardRotation),
                    axis: (x: -dragOffset.height / 20, y: dragOffset.width / 20, z: 0),
                    perspective: 0.5
                )
                .offset(dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8)) {
                                dragOffset = value.translation
                                cardRotation = Double(value.translation.width / 20)
                                cardScale = 1.0 - (abs(value.translation.width) / 2000)
                            }
                        }
                        .onEnded { value in
                            let swipeThreshold: CGFloat = 100
                            
                            if abs(value.translation.width) > swipeThreshold {
                                // Swipe detected
                                let direction = value.translation.width > 0 ? -1 : 1
                                swipeToNextCard(direction: direction)
                            } else {
                                // Return to center
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                    dragOffset = .zero
                                    cardRotation = 0
                                    cardScale = 1.0
                                }
                            }
                        }
                )
                .onTapGesture {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        showCardDetails = true
                    }
                }
            
            // Swipe Indicator
            HStack(spacing: 8) {
                ForEach(cards.indices, id: \.self) { index in
                    Circle()
                        .fill(cards[index].id == selectedCard.id ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: cards[index].id == selectedCard.id ? 8 : 6, height: cards[index].id == selectedCard.id ? 8 : 6)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: selectedCard.id)
                }
            }
            .padding(.vertical, 8)
            
            Text("Swipe left or right to change card")
                .font(.caption)
                .foregroundColor(.secondary)
                .opacity(0.7)
            
            HStack(spacing: 12) {
                Button {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        isExpanded = true
                    }
                } label: {
                    Label("All Cards", systemImage: "rectangle.stack")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: .blue.opacity(0.3), radius: 8, y: 4)
                }
                
                Button {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        showCardDetails = true
                    }
                } label: {
                    Label("Details", systemImage: "info.circle")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                }
            }
        }
        .transition(.asymmetric(
            insertion: .scale(scale: 0.8).combined(with: .opacity),
            removal: .scale(scale: 0.8).combined(with: .opacity)
        ))
    }
    
    // MARK: - Card Details View
    private var cardDetailsView: some View {
        VStack(spacing: 24) {
            cardContent(for: selectedCard, index: 0, isInteractive: false)
                .matchedGeometryEffect(id: selectedCard.id, in: animation)
                .transition(.scale.combined(with: .opacity))
            
            // Credit Limit Section
            VStack(spacing: 16) {
                HStack {
                    Text("Credit Usage")
                        .font(.headline)
                    Spacer()
                    Text("\(Int(selectedCard.spentPercentage))% Used")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 12)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: selectedCard.spentPercentage > 80 ? [.red, .orange] : [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * (selectedCard.spentAmount / selectedCard.creditLimit), height: 12)
                                .animation(.spring(response: 0.8, dampingFraction: 0.8), value: selectedCard.spentAmount)
                        }
                    }
                    .frame(height: 12)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Spent")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("₹\(formatAmount(selectedCard.spentAmount))")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Available")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("₹\(formatAmount(selectedCard.remainingCredit))")
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                    }
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Limit")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("₹\(formatAmount(selectedCard.creditLimit))")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(16)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            
            // Info Cards Grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                infoCard(
                    icon: "gift",
                    title: "Reward Points",
                    value: "\(selectedCard.rewardPoints)",
                    color: .orange
                )
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity).animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1)),
                    removal: .scale.combined(with: .opacity)
                ))
                
                infoCard(
                    icon: "arrow.up.arrow.down",
                    title: "Transaction Limit",
                    value: "₹\(formatAmount(selectedCard.transactionLimit))",
                    color: .blue
                )
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity).animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.2)),
                    removal: .scale.combined(with: .opacity)
                ))
                
                infoCard(
                    icon: "calendar",
                    title: "Billing Cycle",
                    value: "1st - 30th",
                    color: .purple
                )
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity).animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.3)),
                    removal: .scale.combined(with: .opacity)
                ))
                
                infoCard(
                    icon: "percent",
                    title: "Interest Rate",
                    value: "3.5% p.m.",
                    color: .red
                )
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity).animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.4)),
                    removal: .scale.combined(with: .opacity)
                ))
            }
            
            // Card Settings
            VStack(spacing: 0) {
                settingRow(icon: "lock.shield", title: "Card Security", action: {})
                Divider().padding(.leading, 52)
                settingRow(icon: "bell", title: "Transaction Alerts", action: {})
                Divider().padding(.leading, 52)
                settingRow(icon: "slider.horizontal.3", title: "Spending Limits", action: {})
                Divider().padding(.leading, 52)
                settingRow(icon: "doc.text", title: "Statement & Reports", action: {})
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(16)
            .transition(.move(edge: .bottom).combined(with: .opacity).animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5)))
        }
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
    }
    
    // MARK: - Expanded Cards View
    private var expandedCardsView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Select Card")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        isExpanded = false
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            .transition(.opacity.combined(with: .move(edge: .top)))
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                        VStack(spacing: 12) {
                            cardContent(for: card, index: index, isInteractive: false)
                                .matchedGeometryEffect(id: card.id, in: animation)
                                .scaleEffect(selectedCard.id == card.id ? 1.0 : 0.95)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(
                                            selectedCard.id == card.id ?
                                            LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing) :
                                            LinearGradient(colors: [.clear], startPoint: .topLeading, endPoint: .bottomTrailing),
                                            lineWidth: 3
                                        )
                                )
                                .shadow(color: selectedCard.id == card.id ? card.color.opacity(0.4) : .clear, radius: 12, y: 6)
                                .onTapGesture {
                                    selectCard(card)
                                }
                            
                            // Quick Info with animation
                            HStack(spacing: 20) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Available")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("₹\(formatAmount(card.remainingCredit))")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.green)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Divider()
                                    .frame(height: 30)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Limit")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("₹\(formatAmount(card.creditLimit))")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Divider()
                                    .frame(height: 30)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Points")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill")
                                            .font(.caption2)
                                            .foregroundColor(.orange)
                                        Text("\(card.rewardPoints)")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(12)
                        }
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.8).combined(with: .opacity),
                            removal: .scale(scale: 0.8).combined(with: .opacity)
                        ))
                        .animation(
                            .spring(response: 0.5, dampingFraction: 0.7)
                                .delay(Double(index) * 0.08),
                            value: isExpanded
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    // MARK: - Card Content
    private func cardContent(for card: CreditCard, index: Int, isInteractive: Bool) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                LinearGradient(
                    colors: card.gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(height: 200)
            .shadow(color: card.color.opacity(0.3), radius: 12, y: 6)
            .overlay(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(card.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                        
                        Spacer()
                        
                        if selectedCard.id == card.id && isExpanded {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("CARD NUMBER")
                                .font(.caption2)
                                .opacity(0.7)
                            
                            Text("**** **** **** \(card.lastFourDigits)")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "wave.3.right")
                            .font(.title)
                            .opacity(0.5)
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("CARD HOLDER")
                                .font(.caption2)
                                .opacity(0.7)
                            
                            Text("Tony Stark")
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
                    }
                }
                .foregroundColor(.white)
                .padding(20)
            }
            .rotation3DEffect(
                .degrees(isExpanded ? 0 : 0),
                axis: (x: 0, y: 1, z: 0)
            )
    }
    
    // MARK: - Info Card
    private func infoCard(icon: String, title: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.15))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.headline)
                    .fontWeight(.bold)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    // MARK: - Setting Row
    private func settingRow(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .frame(width: 28)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
    
    // MARK: - Swipe to Next Card
    private func swipeToNextCard(direction: Int) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        guard let currentIndex = cards.firstIndex(where: { $0.id == selectedCard.id }) else { return }
        
        let nextIndex = (currentIndex + direction + cards.count) % cards.count
        let nextCard = cards[nextIndex]
        
        // Animate out
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            dragOffset = CGSize(width: direction > 0 ? -500 : 500, height: 0)
            cardRotation = Double(direction) * 15
            cardScale = 0.8
        }
        
        // Change card and animate in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            selectedCard = nextCard
            dragOffset = CGSize(width: direction > 0 ? 500 : -500, height: 0)
            cardRotation = Double(-direction) * 15
            cardScale = 0.8
            
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                dragOffset = .zero
                cardRotation = 0
                cardScale = 1.0
            }
        }
    }
    
    // MARK: - Select Card Function
    private func selectCard(_ card: CreditCard) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            selectedCard = card
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isExpanded = false
            }
        }
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

#Preview {
    CardView()
}
