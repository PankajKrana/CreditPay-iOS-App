//
//  InsightsView.swift
//  CreditPay
//
//  Created by Pankaj Kumar Rana on 06/01/26.
//

import SwiftUI
import Charts

struct InsightsView: View {

    // MARK: Mock Spending Data
    let insightsData: [SpendingData] = [
        SpendingData(day: "Mon", amount: 1200),
        SpendingData(day: "Tue", amount: 800),
        SpendingData(day: "Wed", amount: 1500),
        SpendingData(day: "Thu", amount: 600),
        SpendingData(day: "Fri", amount: 1800),
        SpendingData(day: "Sat", amount: 2200),
        SpendingData(day: "Sun", amount: 900)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    // MARK: Header
                    Text("Weekly Spending")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // MARK: Chart
                    Chart {
                        ForEach(insightsData) { data in
                            BarMark(
                                x: .value("Day", data.day),
                                y: .value("Amount", data.amount)
                            )
                        }
                    }
                    .frame(height: 240)
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .chartXAxis {
                        AxisMarks(position: .bottom)
                    }

                    // MARK: Summary Cards
                    summaryCards
                }
                .padding()
            }
            .navigationTitle("Insights")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private extension InsightsView {

    var summaryCards: some View {
        HStack(spacing: 16) {

            insightCard(
                title: "Total Spent",
                value: "₹9,000",
                icon: "arrow.down"
            )

            insightCard(
                title: "Avg / Day",
                value: "₹1,285",
                icon: "chart.bar"
            )
        }
    }

    func insightCard(title: String, value: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.15))
        .cornerRadius(16)
    }
}

#Preview {
    InsightsView()
}
