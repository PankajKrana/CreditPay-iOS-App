//
//  CardView.swift
//  CreditPay
//
//  Created by Pankaj Kumar Rana on 06/01/26.
//

import SwiftUI

struct CardView: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black)
                .frame(height: 280)
                .shadow(color: .black.opacity(0.25), radius: 12, y: 6)
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        Text("neo")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Spacer()

                        Text("**** 1234")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .padding(24)
                }        }
        .padding()
    }
}

#Preview {
    CardView()
}
