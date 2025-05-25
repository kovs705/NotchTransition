//
//  DeviceDetector.swift
//  NotchTransition
//
//  Created by Eugene Kovs on 25.05.2025.
//  https://github.com/kovs705
//

import UIKit
import SwiftUI

// MARK: - Device Detection Utility
internal struct DeviceDetector {
    
    // MARK: - Device Types
    enum DeviceType {
        case iPhoneWithDynamicIsland    // iPhone 14 Pro, 15 series, 16 series
        case iPhoneWithNotch           // iPhone X, XS, 11, 12, 13 series
        case iPhoneWithoutNotch        // iPhone SE, 8, 7 and older
        case iPad
        case unknown
    }
    
    // MARK: - Screen Dimensions
    struct ScreenDimensions {
        let width: CGFloat
        let height: CGFloat
        
        static let current = ScreenDimensions(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height
        )
    }
    
    // MARK: - Device Detection
    static var currentDevice: DeviceType {
        let screenSize = ScreenDimensions.current
        
        // Check if iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .iPad
        }
        
        // iPhone detection based on screen size and safe area
        let hasNotch = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first?.safeAreaInsets.top ?? 0 > 20
        
        if !hasNotch {
            return .iPhoneWithoutNotch
        }
        
        // Distinguish between Dynamic Island and Notch devices
        // Dynamic Island devices: iPhone 14 Pro/Pro Max, 15 series, 16 series
        let dynamicIslandDevices: Set<CGFloat> = [
            393.0,  // iPhone 14 Pro, 15, 15 Pro, 16, 16 Pro (6.1")
            430.0,  // iPhone 14 Pro Max, 15 Plus, 15 Pro Max, 16 Plus, 16 Pro Max (6.7")
            375.0   // iPhone 15 Pro (when in compatibility mode)
        ]
        
        if dynamicIslandDevices.contains(screenSize.width) {
            return .iPhoneWithDynamicIsland
        }
        
        return .iPhoneWithNotch
    }
    
    // MARK: - Safe Area Detection
    static var topSafeAreaInset: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first?.safeAreaInsets.top ?? 0
    }
    
    // MARK: - Device-Specific Measurements
    static func notchDimensions(for device: DeviceType) -> (width: CGFloat, height: CGFloat) {
        switch device {
        case .iPhoneWithDynamicIsland:
            return (width: 126, height: 37)
        case .iPhoneWithNotch:
            return (width: 210, height: 30)
        case .iPhoneWithoutNotch:
            return (width: 120, height: 25) // Simulated for older devices
        case .iPad:
            return (width: 150, height: 35) // Simulated for iPad
        case .unknown:
            return (width: 130, height: 35)
        }
    }
    
    static func deviceTypeDescription() -> String {
        return switch DeviceDetector.currentDevice {
        case .iPhoneWithDynamicIsland:
            "iPhone with Dynamic Island"
        case .iPhoneWithNotch:
            "iPhone with Notch"
        case .iPhoneWithoutNotch:
            "iPhone without Notch"
        case .iPad:
            "iPad"
        case .unknown:
            "Unknown Device"
        }
    }
}
