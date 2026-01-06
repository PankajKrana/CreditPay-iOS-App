//
//  ContentView.swift
//  CreditPay
//
//  Created by Pankaj Kumar Rana on 06/01/26.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Tab("Account", systemImage: "house.fill") {
                AccountView()
            }
            
            Tab("Insights", systemImage: "graph.2d") {
                InsightsView()
            }
            Tab("Account", systemImage: "arrow.up.arrow.down") {
                PaymentsView()
            }

            Tab("Account", systemImage: "creditcard") {
                CardView()
            }

        }
    }
}

#Preview {
    MainView()
}
