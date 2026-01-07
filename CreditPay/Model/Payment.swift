//
//  Payment.swift
//  CreditPay
//
//  Created by Pankaj Kumar Rana on 07/01/26.
//

import Foundation

struct Payment: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let amount: Int
    let date: String
}
