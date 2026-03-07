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
    @State private var dismissOffset: CGFloat = 0
    
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
        transitionShape(screenSize: getTheScreenRect())
            .background(
                backgroundView
            )
            .overlay {
                fullScreenCoverContent
            }
            .offset(y: dismissOffset)
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
    private func transitionShape(screenSize: CGRect) -> some View {
        RoundedRectangle(cornerRadius: currentCornerRadius)
            .fill(configuration.backgroundColor)
            .frame(
                width: currentWidth(screenWidth: screenSize.width),
                height: currentHeight(screenHeight: screenSize.height)
            )
            .position(
                x: screenSize.width / 2,
                y: currentYPosition(screenHight: screenSize.height)
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
            dismissOffset = 0

            // Snap to notch size instantly — sits behind the Dynamic Island, invisible
            animationPhase = .notch

            // Phase 1: Expand from Dynamic Island outward to rectangle
            withAnimation(.bouncy(duration: configuration.animationTimings.notchToRectangle)) {
                animationPhase = .rectangle
            }

            // Phase 2: Expand to fullscreen
            try await Task.sleep(for: .seconds(configuration.animationTimings.notchToRectangle))
            withAnimation(.interactiveSpring(duration: configuration.animationTimings.contentAppearance)) {
                animationPhase = .fullscreen
            }

            // Phase 3: Show content
            try await Task.sleep(for: .seconds(0.2))
            withAnimation(.spring()) {
                showContent = true
            }
        }
    }
    
    private func dismissAnimation() {
        Task { @MainActor in
            withAnimation(.easeInOut(duration: 0.2)) {
                showContent = false
            }

            try await Task.sleep(for: .seconds(0.15))

            withAnimation(.easeIn(duration: 0.35)) {
                dismissOffset = getTheScreenRect().height
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
    
    private func currentWidth(screenWidth: CGFloat) -> CGFloat {
        switch animationPhase {
        case .hidden:
            return 0
        case .notch:
            return configuration.deviceSizes.notchWidth
        case .rectangle:
            return configuration.deviceSizes.rectangleWidth
        case .fullscreen:
            return screenWidth
        }
    }
    
    private func currentHeight(screenHeight: CGFloat) -> CGFloat {
        switch animationPhase {
        case .hidden:
            return 0
        case .notch:
            return configuration.deviceSizes.notchHeight
        case .rectangle:
            return configuration.deviceSizes.rectangleHeight
        case .fullscreen:
            return screenHeight
        }
    }
    
    private func currentYPosition(screenHight: CGFloat) -> CGFloat {
        switch animationPhase {
        case .hidden, .notch, .rectangle:
            return configuration.deviceSizes.topOffset + (currentHeight(screenHeight: screenHight) / 2)
        case .fullscreen:
            return screenHight / 2
        }
    }
}
