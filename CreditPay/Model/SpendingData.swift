//
//  SpendingData.swift
//  CreditPay
//
//  Created by Pankaj Kumar Rana on 07/01/26.
//

import Foundation

struct SpendingData: Identifiable {
    let id = UUID()
    let day: String
    let amount: Int
}
