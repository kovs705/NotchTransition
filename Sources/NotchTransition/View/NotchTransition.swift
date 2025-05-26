//
//  notchTransition.swift
//  NotchTransition
//
//  Created by Eugene Kovs on 25.05.2025.
//  https://github.com/kovs705
//

import SwiftUI

// MARK: - Main Dynamic Island Transition View
@available(iOS 16.4, *)
public struct NotchTransition<Content: View>: View {
    
    // MARK: - Properties
    @Binding private var isPresented: Bool
    private let content: () -> Content
    private let configuration: TransitionConfiguration
    
    @State private var animationPhase: AnimationPhase = .hidden
    @State private var showContent = false
    
    // MARK: - Initialization
    public init(
        isPresented: Binding<Bool>,
        configuration: TransitionConfiguration = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self.content = content
        self.configuration = configuration
    }
    
    // MARK: - Body
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                backgroundView
                
                // Main transition shape
                transitionShape(geometry: geometry)
                    .overlay {
                        fullScreenCoverContent
                    }
            }
        }
        .ignoresSafeArea(.all)
        .onAppear {
            startAnimation()
        }
        .onChange(of: isPresented) { newValue in
            if !newValue {
                dismissAnimation()
            }
        }
    }
    
    // MARK: - Background View
    @ViewBuilder
    private var backgroundView: some View {
        if let material = configuration.backgroundMaterial {
            Rectangle()
                .fill(material)
                .opacity(animationPhase == .fullscreen ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: animationPhase)
        } else {
            Color.clear
        }
    }
    
    // MARK: - Transition Shape
    private func transitionShape(geometry: GeometryProxy) -> some View {
        RoundedRectangle(cornerRadius: currentCornerRadius)
            .fill(configuration.backgroundColor)
            .frame(
                width: currentWidth(geometry: geometry),
                height: currentHeight(geometry: geometry)
            )
            .position(
                x: geometry.size.width / 2,
                y: currentYPosition(geometry: geometry)
            )
    }
    
    // MARK: - Content Overlay
    @ViewBuilder
    private var fullScreenCoverContent: some View {
        if showContent {
            content()
                .opacity(showContent ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: showContent)
        }
    }
}

// MARK: - Animation Phases
@available(iOS 16.4, *)
extension NotchTransition {
    private enum AnimationPhase {
        case hidden
        case notch
        case rectangle
        case fullscreen
    }
}

// MARK: - Animation Logic
@available(iOS 16.4, *)
extension NotchTransition {
    private func startAnimation() {
        Task { @MainActor in
            // Reset state
            animationPhase = .hidden
            showContent = false
            
            // Initial delay
            try await Task.sleep(for: .seconds(configuration.animationTimings.initial))
            
            // Phase 1: Show from notch
            withAnimation(.bouncy(duration: configuration.animationTimings.notchToRectangle)) {
                animationPhase = .notch
            }
            
            // Phase 2: Extend to rectangle
            try await Task.sleep(for: .seconds(configuration.animationTimings.notchToRectangle))
            withAnimation(.bouncy(duration: configuration.animationTimings.rectangleToFullscreen)) {
                animationPhase = .rectangle
            }
            
            // Phase 3: Expand to fullscreen
            try await Task.sleep(for: .seconds(configuration.animationTimings.rectangleToFullscreen))
            withAnimation(.bouncy(duration: configuration.animationTimings.contentAppearance)) {
                animationPhase = .fullscreen
            }
            
            // Phase 4: Show content
            try await Task.sleep(for: .seconds(0.2))
            withAnimation(.spring()) {
                showContent = true
            }
        }
    }
    
    private func dismissAnimation() {
        Task { @MainActor in
            withAnimation(.easeInOut(duration: 0.3)) {
                showContent = false
            }
            
            try await Task.sleep(for: .seconds(0.1))
            
            withAnimation(.bouncy(duration: 0.4)) {
                animationPhase = .hidden
            }
        }
    }
}

// MARK: - Computed Properties
@available(iOS 16.4, *)
extension NotchTransition {
    private var currentCornerRadius: CGFloat {
        switch animationPhase {
        case .hidden:
            return configuration.cornerRadius.notch
        case .notch:
            return configuration.cornerRadius.notch
        case .rectangle:
            return configuration.cornerRadius.rectangle
        case .fullscreen:
            return configuration.cornerRadius.fullscreen
        }
    }
    
    private func currentWidth(geometry: GeometryProxy) -> CGFloat {
        switch animationPhase {
        case .hidden:
            return 0
        case .notch:
            return configuration.deviceSizes.notchWidth
        case .rectangle:
            return configuration.deviceSizes.rectangleWidth
        case .fullscreen:
            return geometry.size.width
        }
    }
    
    private func currentHeight(geometry: GeometryProxy) -> CGFloat {
        switch animationPhase {
        case .hidden:
            return 0
        case .notch:
            return configuration.deviceSizes.notchHeight
        case .rectangle:
            return configuration.deviceSizes.rectangleHeight
        case .fullscreen:
            return geometry.size.height
        }
    }
    
    private func currentYPosition(geometry: GeometryProxy) -> CGFloat {
        switch animationPhase {
        case .hidden, .notch, .rectangle:
            return configuration.deviceSizes.topOffset + (currentHeight(geometry: geometry) / 2)
        case .fullscreen:
            return geometry.size.height / 2
        }
    }
}
