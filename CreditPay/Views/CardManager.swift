//
//  CardManager.swift
//  CreditPay
//
//  Created by Pankaj Kumar Rana on 08/01/26.
//

import SwiftUI
import Combine

class CardManager: ObservableObject {
    static let shared = CardManager()
    
    @Published var selectedCard: CreditCard
    @Published var availableCards: [CreditCard]
    
    private init() {
        // Define card IDs for consistent references
        let neoId = UUID()
        let platinumId = UUID()
        let goldId = UUID()
        let silverId = UUID()

        // Build cards locally first to avoid using self before initialization
        let initialCards: [CreditCard] = [
            CreditCard(
                id: neoId,
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
                id: platinumId,
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
                id: goldId,
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
                id: silverId,
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

        // Assign stored properties in order
        self.availableCards = initialCards
        self.selectedCard = initialCards.first!

        print("CardManager initialized with \(availableCards.count) cards")
        print("Selected card: \(selectedCard.name)")
    }
    
    func selectCard(_ card: CreditCard) {
        print("Selecting card: \(card.name)")
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            selectedCard = card
        }
        print("Card selected: \(selectedCard.name)")
    }
}


