import SwiftUI
import Combine

// MARK: - Shared Card Manager
class CardManager: ObservableObject {
    static let shared = CardManager()
    
    @Published var selectedCard: CreditCard
    @Published var availableCards: [CreditCard]
    
    private init() {
        // Initialize with default cards
        self.availableCards = [
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
        
        // Set the first card as default
        self.selectedCard = availableCards[0]
    }
    
    func selectCard(_ card: CreditCard) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            selectedCard = card
        }
    }
}
