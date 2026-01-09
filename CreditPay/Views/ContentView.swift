//
//  ContentView.swift
//  CreditPay
//
//  Created by Pankaj Kumar Rana on 06/01/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: TabIdentifier = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: .home) {
                AccountView()
            }
            
            Tab("Insights", systemImage: "chart.bar.fill", value: .insights) {
                InsightsView()
            }
            
            Tab("Payments", systemImage: "arrow.left.arrow.right", value: .payments) {
                PaymentsView()
            }
            
            Tab("Cards", systemImage: "creditcard.fill", value: .cards) {
                CardView()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tint(.blue)
    }
}
enum TabIdentifier: Hashable {
    case home
    case insights
    case payments
    case cards
}


#Preview {
    ContentView()
}
