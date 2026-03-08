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
    @State private var isDismissing = false
    @State private var animationTask: Task<Void, Never>?
    
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
        let screenSize = getTheScreenRect()
        return ZStack {
            // Outer shape — black shell that drives the expand animation
            transitionShape(screenSize: screenSize)

            // Card content — shader + destination view, both clipped to the same rounded rectangle
            cardContent(screenSize: screenSize)
        }
        .background(backgroundView)
        .offset(y: dismissOffset)
        .ignoresSafeArea(.all)
        .onAppear {
            startAnimation()
        }
        .onChange(of: isPresented) { newValue in
            if newValue {
                startAnimation()
            } else {
                dismissAnimation()
            }
        }
        .onDisappear {
            animationTask?.cancel()
            animationTask = nil
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

    // MARK: - Outer Transition Shape
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

    // MARK: - Card Content (shader + destination, single clip boundary)
    private func cardContent(screenSize: CGRect) -> some View {
        let width = currentInnerWidth(screenWidth: screenSize.width)
        let height = currentInnerHeight(screenHeight: screenSize.height)

        return ZStack {
            // Shader — fades out as content arrives
            innerViewContent
                .opacity(innerViewOpacity)
                .animation(
                    .easeInOut(duration: configuration.animationTimings.contentAppearance),
                    value: innerViewOpacity
                )

            // Destination view — fades in over the shader
            if showContent {
                content()
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeInOut(duration: configuration.animationTimings.contentAppearance), value: showContent)
            }
        }
        .frame(
            width: width,
            height: height
        )
        .clipShape(RoundedRectangle(cornerRadius: currentInnerCornerRadius))
        .opacity(height > 1 ? 1 : 0)
        .position(
            x: screenSize.width / 2,
            y: currentInnerYPosition(screenHeight: screenSize.height)
        )
    }

    @ViewBuilder
    private var innerViewContent: some View {
        switch configuration.innerViewStyle {
        case .sinebow:
            if #available(iOS 17.0, *) {
                SinebowBackground()
            } else {
                AuroraBackground()
            }
        case .lightGrid:
            if #available(iOS 17.0, *) {
                LightGridBackground()
            } else {
                AuroraBackground()
            }
        case .gradientFill:
            if #available(iOS 17.0, *) {
                GradientFillBackground()
            } else {
                AuroraBackground()
            }
        case .plain(let color):
            Rectangle().fill(color)
        case .invisible:
            Color.clear
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
        animationTask?.cancel()
        animationTask = Task { @MainActor in
            // Reset state
            animationPhase = .hidden
            showContent = false
            dismissOffset = 0
            isDismissing = false

            if configuration.animationTimings.initial > 0 {
                try? await Task.sleep(for: .seconds(configuration.animationTimings.initial))
                guard !Task.isCancelled else { return }
            }

            // Snap to notch size instantly — sits behind the Dynamic Island, invisible
            animationPhase = .notch

            // Phase 1: Expand from Dynamic Island outward to rectangle
            withAnimation(.bouncy(duration: configuration.animationTimings.notchToRectangle)) {
                animationPhase = .rectangle
            }

            // Phase 2: Expand to fullscreen
            try? await Task.sleep(for: .seconds(configuration.animationTimings.notchToRectangle))
            guard !Task.isCancelled else { return }

            withAnimation(.interactiveSpring(duration: configuration.animationTimings.rectangleToFullscreen)) {
                animationPhase = .fullscreen
            }

            // Phase 3: Show content
            try? await Task.sleep(
                for: .seconds(max(configuration.animationTimings.rectangleToFullscreen * 0.35, 0.15))
            )
            guard !Task.isCancelled else { return }

            withAnimation(.easeInOut(duration: configuration.animationTimings.contentAppearance)) {
                showContent = true
            }

            animationTask = nil
        }
    }
    
    private func dismissAnimation() {
        animationTask?.cancel()
        animationTask = Task { @MainActor in
            isDismissing = true

            withAnimation(.easeInOut(duration: 0.18)) {
                showContent = false
            }

            try? await Task.sleep(for: .seconds(0.12))
            guard !Task.isCancelled else { return }

            withAnimation(.easeIn(duration: 0.35)) {
                dismissOffset = getTheScreenRect().height
            }

            animationTask = nil
        }
    }
}

// MARK: - Computed Properties
@available(iOS 16.4, *)
extension NotchTransition {
    private var innerViewOpacity: Double {
        if showContent {
            return 0
        }

        if isDismissing && !configuration.showsInnerViewOnDismiss {
            return 0
        }

        return 1
    }

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

    private var currentInnerCornerRadius: CGFloat {
        switch animationPhase {
        case .hidden, .notch:
            return configuration.cornerRadius.notch
        case .rectangle:
            return max(
                configuration.cornerRadius.rectangle - configuration.innerSurfaceLayout.horizontalInset,
                configuration.cornerRadius.notch
            )
        case .fullscreen:
            return configuration.cornerRadius.fullscreen
        }
    }

    private var currentInnerHorizontalInset: CGFloat {
        switch animationPhase {
        case .hidden, .notch:
            return 0
        case .rectangle:
            return configuration.innerSurfaceLayout.horizontalInset
        case .fullscreen:
            return 0
        }
    }

    private var currentInnerTopInset: CGFloat {
        switch animationPhase {
        case .hidden, .notch:
            return configuration.deviceSizes.notchHeight
        case .rectangle:
            return configuration.deviceSizes.notchHeight + configuration.innerSurfaceLayout.topPadding
        case .fullscreen:
            return 0
        }
    }

    private var currentInnerBottomInset: CGFloat {
        switch animationPhase {
        case .hidden, .notch:
            return 0
        case .rectangle:
            return configuration.innerSurfaceLayout.bottomPadding
        case .fullscreen:
            return 0
        }
    }

    private func currentInnerWidth(screenWidth: CGFloat) -> CGFloat {
        max(currentWidth(screenWidth: screenWidth) - (currentInnerHorizontalInset * 2), 0)
    }

    private func currentInnerHeight(screenHeight: CGFloat) -> CGFloat {
        max(currentHeight(screenHeight: screenHeight) - currentInnerTopInset - currentInnerBottomInset, 0)
    }

    private func currentInnerYPosition(screenHeight: CGFloat) -> CGFloat {
        currentYPosition(screenHight: screenHeight) + ((currentInnerTopInset - currentInnerBottomInset) / 2)
    }
}
