//
//  ModernGroupBoxStyle.swift
//  SMART
//
//  Created by Aryan Palit on 3/3/25.
//
import SwiftUI

// Custom GroupBoxStyle for a modern card-like appearance
struct ModernGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            configuration.label
                .padding(.bottom, 5)
            configuration.content
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
    }
}
