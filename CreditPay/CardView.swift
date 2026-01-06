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
                .overlay {
                    Text("Hi there")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
        }
        .padding()
    }
}

#Preview {
    CardView()
}
