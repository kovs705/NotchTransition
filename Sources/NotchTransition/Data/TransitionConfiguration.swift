//
//  TransitionConfiguration.swift
//  NotchTransition
//
//  Created by Eugene Kovs on 25.05.2025.
//  https://github.com/kovs705
//

import SwiftUI

// MARK: - Inner View Style

/// The visual surface that morphs from the card into the full screen.
public enum InnerViewStyle {
    /// 10 twisting rainbow lines — Inferno `sinebow` shader (iOS 17+, gradient fallback on iOS 16).
    case sinebow
    /// Grid of pulsing multi-colored lights — Inferno `lightGrid` shader (iOS 17+, gradient fallback on iOS 16).
    case lightGrid
    /// Rotating full-screen color gradient — Inferno `animatedGradientFill` shader (iOS 17+, gradient fallback on iOS 16).
    case gradientFill
    /// A solid color fill.
    case plain(Color)
    /// Transparent — the outer black shape is the only visible layer.
    case invisible
}

// MARK: - Transition Configuration
public struct TransitionConfiguration {
    
    // MARK: - Animation Timings
    public struct AnimationTimings {
        let initial: TimeInterval
        let notchToRectangle: TimeInterval
        let rectangleToFullscreen: TimeInterval
        let contentAppearance: TimeInterval
        
        static public let `default` = AnimationTimings(
            initial: 0,
            notchToRectangle: 0.8,
            rectangleToFullscreen: 0.6,
            contentAppearance: 0.5
        )
        
        static public let slow = AnimationTimings(
            initial: 0.4,
            notchToRectangle: 1.2,
            rectangleToFullscreen: 0.8,
            contentAppearance: 0.7
        )
    }

    // MARK: - Inner Surface Layout
    public struct InnerSurfaceLayout {
        /// Left and right inset applied to the shader/content card during the rectangle phase.
        public let horizontalInset: CGFloat
        /// Extra spacing between the notch bottom edge and the shader/content card.
        public let topPadding: CGFloat
        /// Bottom spacing between the shader/content card and the outer black shell.
        public let bottomPadding: CGFloat

        public init(
            horizontalInset: CGFloat,
            topPadding: CGFloat,
            bottomPadding: CGFloat
        ) {
            self.horizontalInset = horizontalInset
            self.topPadding = topPadding
            self.bottomPadding = bottomPadding
        }

        static func defaultLayout(
            rectangleWidth: CGFloat,
            rectangleHeight: CGFloat
        ) -> InnerSurfaceLayout {
            InnerSurfaceLayout(
                horizontalInset: min(max(rectangleWidth * 0.06, 10), 18),
                topPadding: min(max(rectangleHeight * 0.035, 6), 12),
                bottomPadding: min(max(rectangleHeight * 0.05, 8), 16)
            )
        }

        public static let compact = InnerSurfaceLayout(
            horizontalInset: 8,
            topPadding: 4,
            bottomPadding: 8
        )

        public static let screenshot = InnerSurfaceLayout(
            horizontalInset: 12,
            topPadding: 8,
            bottomPadding: 12
        )

        public static let immersive = InnerSurfaceLayout(
            horizontalInset: 6,
            topPadding: 2,
            bottomPadding: 6
        )
    }
    
    // MARK: - Device-Specific Sizes
    struct DeviceSizes {
        let notchWidth: CGFloat
        let notchHeight: CGFloat
        let rectangleWidth: CGFloat
        let rectangleHeight: CGFloat
        let topOffset: CGFloat
        
        static func sizes(for device: DeviceDetector.DeviceType) -> DeviceSizes {
            let notchDimensions = DeviceDetector.notchDimensions(for: device)
            let topSafeArea = DeviceDetector.topSafeAreaInset
            
            switch device {
            case .iPhoneWithDynamicIsland:
                return DeviceSizes(
                    notchWidth: notchDimensions.width,
                    notchHeight: notchDimensions.height,
                    rectangleWidth: 200,
                    rectangleHeight: 225,
                    topOffset: topSafeArea > 0 ? 13 : 20
                )
                
            case .iPhoneWithNotch:
                return DeviceSizes(
                    notchWidth: notchDimensions.width * 0.6, // Scale down for better visual
                    notchHeight: notchDimensions.height,
                    rectangleWidth: 190,
                    rectangleHeight: 210,
                    topOffset: topSafeArea > 0 ? 15 : 20
                )
                
            case .iPhoneWithoutNotch:
                return DeviceSizes(
                    notchWidth: notchDimensions.width,
                    notchHeight: notchDimensions.height,
                    rectangleWidth: 180,
                    rectangleHeight: 200,
                    topOffset: 25
                )
                
            case .iPad:
                return DeviceSizes(
                    notchWidth: notchDimensions.width,
                    notchHeight: notchDimensions.height,
                    rectangleWidth: 250,
                    rectangleHeight: 280,
                    topOffset: 40
                )
                
            case .unknown:
                return DeviceSizes(
                    notchWidth: notchDimensions.width,
                    notchHeight: notchDimensions.height,
                    rectangleWidth: 200,
                    rectangleHeight: 225,
                    topOffset: 20
                )
            }
        }
    }
    
    // MARK: - Corner Radius Configuration
    struct CornerRadiusConfig {
        let notch: CGFloat
        let rectangle: CGFloat
        let fullscreen: CGFloat
        
        static func radius(for device: DeviceDetector.DeviceType) -> CornerRadiusConfig {
            switch device {
            case .iPhoneWithDynamicIsland:
                return CornerRadiusConfig(notch: 19, rectangle: 35, fullscreen: 55)
            case .iPhoneWithNotch:
                return CornerRadiusConfig(notch: 15, rectangle: 30, fullscreen: 45)
            case .iPhoneWithoutNotch:
                return CornerRadiusConfig(notch: 12, rectangle: 25, fullscreen: 0)
            case .iPad:
                return CornerRadiusConfig(notch: 20, rectangle: 40, fullscreen: 0)
            case .unknown:
                return CornerRadiusConfig(notch: 15, rectangle: 30, fullscreen: 0)
            }
        }
    }
    
    // MARK: - Public Configuration
    let animationTimings: AnimationTimings
    let deviceSizes: DeviceSizes
    let cornerRadius: CornerRadiusConfig
    let backgroundColor: Color
    let backgroundMaterial: Material?
    public let innerViewStyle: InnerViewStyle
    public let innerSurfaceLayout: InnerSurfaceLayout
    public let showsInnerViewOnDismiss: Bool

    public init(
        animationTimings: AnimationTimings = .default,
        backgroundColor: Color = .black,
        backgroundMaterial: Material? = nil,
        innerViewStyle: InnerViewStyle = .sinebow,
        innerSurfaceLayout: InnerSurfaceLayout? = nil,
        showsInnerViewOnDismiss: Bool = false
    ) {
        let device = DeviceDetector.currentDevice
        let sizes = DeviceSizes.sizes(for: device)
        self.animationTimings = animationTimings
        self.deviceSizes = sizes
        self.cornerRadius = CornerRadiusConfig.radius(for: device)
        self.backgroundColor = backgroundColor
        self.backgroundMaterial = backgroundMaterial
        self.innerViewStyle = innerViewStyle
        self.innerSurfaceLayout = innerSurfaceLayout ?? InnerSurfaceLayout.defaultLayout(
            rectangleWidth: sizes.rectangleWidth,
            rectangleHeight: sizes.rectangleHeight
        )
        self.showsInnerViewOnDismiss = showsInnerViewOnDismiss
    }
    
    // MARK: - Predefined Configurations
    public static let `default` = TransitionConfiguration()
    
    public static let slow = TransitionConfiguration(
        animationTimings: .slow
    )
    
    public static func themed(
        backgroundColor: Color,
        material: Material? = .ultraThinMaterial,
        innerSurfaceLayout: InnerSurfaceLayout? = nil,
        showsInnerViewOnDismiss: Bool = false
    ) -> TransitionConfiguration {
        TransitionConfiguration(
            backgroundColor: backgroundColor,
            backgroundMaterial: material,
            innerSurfaceLayout: innerSurfaceLayout,
            showsInnerViewOnDismiss: showsInnerViewOnDismiss
        )
    }
}

public extension TransitionConfiguration {
    func animationTimings(_ value: AnimationTimings) -> Self {
        TransitionConfiguration(
            animationTimings: value,
            backgroundColor: backgroundColor,
            backgroundMaterial: backgroundMaterial,
            innerViewStyle: innerViewStyle,
            innerSurfaceLayout: innerSurfaceLayout,
            showsInnerViewOnDismiss: showsInnerViewOnDismiss
        )
    }

    func transitionBackgroundColor(_ value: Color) -> Self {
        TransitionConfiguration(
            animationTimings: animationTimings,
            backgroundColor: value,
            backgroundMaterial: backgroundMaterial,
            innerViewStyle: innerViewStyle,
            innerSurfaceLayout: innerSurfaceLayout,
            showsInnerViewOnDismiss: showsInnerViewOnDismiss
        )
    }

    func backgroundMaterial(_ value: Material?) -> Self {
        TransitionConfiguration(
            animationTimings: animationTimings,
            backgroundColor: backgroundColor,
            backgroundMaterial: value,
            innerViewStyle: innerViewStyle,
            innerSurfaceLayout: innerSurfaceLayout,
            showsInnerViewOnDismiss: showsInnerViewOnDismiss
        )
    }

    func innerViewStyle(_ value: InnerViewStyle) -> Self {
        TransitionConfiguration(
            animationTimings: animationTimings,
            backgroundColor: backgroundColor,
            backgroundMaterial: backgroundMaterial,
            innerViewStyle: value,
            innerSurfaceLayout: innerSurfaceLayout,
            showsInnerViewOnDismiss: showsInnerViewOnDismiss
        )
    }

    func innerSurfaceLayout(_ value: InnerSurfaceLayout) -> Self {
        TransitionConfiguration(
            animationTimings: animationTimings,
            backgroundColor: backgroundColor,
            backgroundMaterial: backgroundMaterial,
            innerViewStyle: innerViewStyle,
            innerSurfaceLayout: value,
            showsInnerViewOnDismiss: showsInnerViewOnDismiss
        )
    }

    func showsInnerViewOnDismiss(_ value: Bool) -> Self {
        TransitionConfiguration(
            animationTimings: animationTimings,
            backgroundColor: backgroundColor,
            backgroundMaterial: backgroundMaterial,
            innerViewStyle: innerViewStyle,
            innerSurfaceLayout: innerSurfaceLayout,
            showsInnerViewOnDismiss: value
        )
    }
}
