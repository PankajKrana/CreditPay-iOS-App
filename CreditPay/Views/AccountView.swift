//
//  AccountView.swift
//  CreditPay
//
//  Created by Pankaj Kumar Rana on 06/01/26.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: Header
                    HStack {
                        Text("Card")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        HStack(spacing: 12) {
                            headerButton(systemImage: "questionmark")
                            headerButton(systemImage: "ellipsis")
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: Card
                    CardView()
                    
                    // MARK: Actions
                    HStack(spacing: 40) {
                        actionButton(systemImage: "snowflake", title: "Freeze") {
                            print("Freeze tapped")
                        }
                        
                        actionButton(systemImage: "eye", title: "View") {
                            print("View tapped")
                        }
                        
                        actionButton(systemImage: "gearshape", title: "Settings") {
                            print("Settings tapped")
                        }
                    }
                    .padding(.top, 8)
                    
                    Spacer()
                    
                    bannerRectangleView()
                        .padding()
                    
                    Spacer()
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    // MARK: Header Button
    private func headerButton(systemImage: String) -> some View {
        Button {
            // Action
        } label: {
            Image(systemName: systemImage)
                .frame(width: 32, height: 32)
                .background(Color.gray.opacity(0.4))
                .clipShape(Circle())
        }
        .foregroundColor(.black)
    }
    
    // MARK: Action Button
    private func actionButton(
        systemImage: String,
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: systemImage)
                    .frame(width: 44, height: 44)
                    .background(Color.gray.opacity(0.15))
                    .clipShape(Circle())
                
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(.black)
        }
    }
}

extension View {
    @ViewBuilder
    func bannerRectangleView() -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.yellow.opacity(0.2))
            .frame(height: 200)
            .overlay {
                VStack(alignment: .leading,spacing: 12) {
                    Text("Activate Physical Card")
                        .font(.title2)

                    Text("Expected arrival 10–15 Nov")

                    Button("Activate") {
                        print("Activate tapped")
                    }
                }
            }
    }
}

#Preview {
    AccountView()
}
