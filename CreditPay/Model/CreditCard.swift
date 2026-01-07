//
//  CreditCard.swift
//  CreditPay
//
//  Created by Pankaj Kumar Rana on 07/01/26.
//


struct CreditCard: Identifiable {
    let id = UUID()
    let name: String
    let lastFourDigits: String
    let color: Color
    let gradient: [Color]
    let creditLimit: Double
    let spentAmount: Double
    let rewardPoints: Int
    let transactionLimit: Double
    let availableCredit: Double
    
    var spentPercentage: Double {
        (spentAmount / creditLimit) * 100
    }
    
    var remainingCredit: Double {
        creditLimit - spentAmount
    }
}