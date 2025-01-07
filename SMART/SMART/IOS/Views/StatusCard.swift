//
//  StatusCard.swift
//  SMART
//
//  Created by Anson Jiang on 11/28/24.
//

import SwiftUI

struct StatusCard: View {
    var title: String
    var subtitle: String
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Rectangle()
                    .frame(width: 250, height: 10)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primaryText)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)
            }
            .frame(width: 300)
            .padding()
            .background(Color.cardBackground)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
        }
}

