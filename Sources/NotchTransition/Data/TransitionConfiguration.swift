//
//  TransitionConfiguration.swift
//  NotchTransition
//
//  Created by Eugene Kovs on 25.05.2025.
//  https://github.com/kovs705
//

import SwiftUI

// MARK: - Transition Configuration
public struct TransitionConfiguration {
    
    // MARK: - Animation Timings
    public struct AnimationTimings {
        let initial: TimeInterval
        let notchToRectangle: TimeInterval
        let rectangleToFullscreen: TimeInterval
        let contentAppearance: TimeInterval
        
        static public let `default` = AnimationTimings(
            initial: 0.27,
            notchToRectangle: 0.8,
            rectangleToFullscreen: 0.6,
            contentAppearance: 0.5
        )
        
        static public let fast = AnimationTimings(
            initial: 0.15,
            notchToRectangle: 0.5,
            rectangleToFullscreen: 0.4,
            contentAppearance: 0.3
        )
        
        static public let slow = AnimationTimings(
            initial: 0.4,
            notchToRectangle: 1.2,
            rectangleToFullscreen: 0.8,
            contentAppearance: 0.7
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
                return CornerRadiusConfig(notch: 19, rectangle: 35, fullscreen: 0)
            case .iPhoneWithNotch:
                return CornerRadiusConfig(notch: 15, rectangle: 30, fullscreen: 0)
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
    
    public init(
        animationTimings: AnimationTimings = .default,
        backgroundColor: Color = .black,
        backgroundMaterial: Material? = nil
    ) {
        let device = DeviceDetector.currentDevice
        self.animationTimings = animationTimings
        self.deviceSizes = DeviceSizes.sizes(for: device)
        self.cornerRadius = CornerRadiusConfig.radius(for: device)
        self.backgroundColor = backgroundColor
        self.backgroundMaterial = backgroundMaterial
    }
    
    // MARK: - Predefined Configurations
    public static let `default` = TransitionConfiguration()
    
    public static let fast = TransitionConfiguration(
        animationTimings: .fast
    )
    
    public static let slow = TransitionConfiguration(
        animationTimings: .slow
    )
    
    public static func themed(
        backgroundColor: Color,
        material: Material? = .ultraThinMaterial
    ) -> TransitionConfiguration {
        TransitionConfiguration(
            backgroundColor: backgroundColor,
            backgroundMaterial: material
        )
    }
}
