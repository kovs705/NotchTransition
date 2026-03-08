//
//  InnerTransitionView.swift
//  NotchTransition
//
//  Created by Eugene Kovs on 06.03.2026.
//  https://github.com/kovs705
//

import SwiftUI

// MARK: - Sinebow  (Inferno · iOS 17+)

/// 10 twisting lines that cycle through rainbow colors.
@available(iOS 17.0, *)
struct SinebowBackground: View {
    private let start = Date()

    var body: some View {
        TimelineView(.animation) { ctx in
            let elapsed = Float(ctx.date.timeIntervalSince(start))
            GeometryReader { geo in
                Rectangle()
                    .colorEffect(
                        ShaderLibrary.bundle(.module).sinebow(
                            .float2(geo.size),
                            .float(elapsed)
                        )
                    )
            }
        }
    }
}

// MARK: - LightGrid  (Inferno · iOS 17+)

/// Grid of independently pulsing multi-colored lights.
@available(iOS 17.0, *)
struct LightGridBackground: View {
    private let start = Date()

    var body: some View {
        TimelineView(.animation) { ctx in
            let elapsed = Float(ctx.date.timeIntervalSince(start))
            GeometryReader { geo in
                Rectangle()
                    .colorEffect(
                        ShaderLibrary.bundle(.module).lightGrid(
                            .float2(geo.size),
                            .float(elapsed),
                            .float(8),   // density  — rows/columns (1-50)
                            .float(3),   // speed    — color-change rate (1-20)
                            .float(1),   // groupSize — lights per group (1-8)
                            .float(3)    // brightness (0.2-10)
                        )
                    )
            }
        }
    }
}

// MARK: - GradientFill  (Inferno · iOS 17+)

/// Constantly rotating full-screen color gradient.
@available(iOS 17.0, *)
struct GradientFillBackground: View {
    private let start = Date()

    var body: some View {
        TimelineView(.animation) { ctx in
            let elapsed = Float(ctx.date.timeIntervalSince(start))
            GeometryReader { geo in
                Rectangle()
                    .colorEffect(
                        ShaderLibrary.bundle(.module).animatedGradientFill(
                            .float2(geo.size),
                            .float(elapsed)
                        )
                    )
            }
        }
    }
}

// MARK: - iOS 16 fallback

/// Animated gradient — used when Metal shaders are unavailable (iOS 16).
struct AuroraBackground: View {
    @State private var animating = false

    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.02, green: 0.02, blue: 0.12),
                Color(red: 0.10, green: 0.02, blue: 0.20),
                Color(red: 0.00, green: 0.08, blue: 0.18)
            ],
            startPoint: animating ? .topLeading    : .bottomTrailing,
            endPoint:   animating ? .bottomTrailing : .topLeading
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                animating = true
            }
        }
    }
}
