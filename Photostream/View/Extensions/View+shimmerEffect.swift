//
//  view+shimmerEffect.swift
//  Photostream
//
//  Created by Md Fahim Faez Abir on 5/9/25.
//

import SwiftUI

extension View {
    func shimmer() -> some View {
        self.overlay(
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.clear, .white.opacity(0.4), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .rotationEffect(.degrees(-10))
                .offset(x: -250)
                .animation(
                    .easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: false),
                    value: UUID()
                )
        )
        .clipped()
    }
}
