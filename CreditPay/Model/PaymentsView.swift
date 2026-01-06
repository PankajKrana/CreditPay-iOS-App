//
//  PaymentsView.swift
//  CreditPay
//
//  Created by Pankaj Kumar Rana on 06/01/26.
//

import SwiftUI



struct PaymentsView: View {

    // MARK: Mock Data
    let payments: [Payment] = [
        Payment(title: "Amazon", subtitle: "Shopping", amount: -1299, date: "Today"),
        Payment(title: "Netflix", subtitle: "Subscription", amount: -499, date: "Yesterday"),
        Payment(title: "Salary", subtitle: "Monthly Credit", amount: 45000, date: "01 Jan"),
        Payment(title: "Zomato", subtitle: "Food Order", amount: -320, date: "31 Dec"),
        Payment(title: "Uber", subtitle: "Ride Payment", amount: -210, date: "30 Dec")
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(payments) { payment in
                    PaymentRowView(payment: payment)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Payments")
        }
    }
}

struct PaymentRowView: View {
    let payment: Payment

    var body: some View {
        HStack(spacing: 16) {

            // Icon
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: payment.amount < 0 ? "arrow.up.right" : "arrow.down.left")
                        .foregroundColor(payment.amount < 0 ? .red : .green)
                }

            // Title + Subtitle
            VStack(alignment: .leading, spacing: 4) {
                Text(payment.title)
                    .font(.headline)

                Text(payment.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Amount + Date
            VStack(alignment: .trailing, spacing: 4) {
                Text(formattedAmount)
                    .font(.headline)
                    .foregroundColor(payment.amount < 0 ? .red : .green)

                Text(payment.date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 6)
    }

    private var formattedAmount: String {
        let sign = payment.amount < 0 ? "-" : "+"
        return "\(sign)₹\(abs(payment.amount))"
    }
}



#Preview {
    PaymentsView()
}
