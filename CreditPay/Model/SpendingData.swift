//
//  SpendingData.swift
//  CreditPay
//
//  Created by Pankaj Kumar Rana on 07/01/26.
//

import Foundation
import SwiftUI

struct SpendingData: Identifiable {
    let id = UUID()
    let day: String
    let amount: Int
}



struct CategorySpending: Identifiable {
    let id = UUID()
    let category: String
    let amount: Double
    let percentage: Double
    let color: Color
    let icon: String
}


enum TimeRange: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}
