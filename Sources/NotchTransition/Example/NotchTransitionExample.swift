//
//  NotchTransitionExample.swift
//  NotchTransition
//
//  Created by Eugene Kovs on 25.05.2025.
//  https://github.com/kovs705
//

import SwiftUI
//import notchTransition

// MARK: - Example Usage
@available(iOS 16.4, *)
public struct NotchTransitionExample: View {
    @State private var showDefaultTransition = false
    @State private var showSlowedTransition = false
    @State private var showThemedTransition = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    deviceInfoSection
                    buttonSection
                }
                .padding()
            }
            .navigationTitle("Dynamic Island")
            .navigationBarTitleDisplayMode(.large)
        }
        .notchTransition(isPresented: $showDefaultTransition) {
            DefaultTransitionContent(isPresented: $showDefaultTransition)
        }
        .notchTransitionSlow(isPresented: $showSlowedTransition) {
            DefaultTransitionContent(isPresented: $showSlowedTransition)
        }
        .notchTransitionThemed(isPresented: $showThemedTransition, backgroundColor: .cyan) {
            ThemedTransitionContent(isPresented: $showThemedTransition)
        }
        
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "iphone")
                .font(.system(size: 50))
                .foregroundColor(.primary)
            
            Text("Dynamic Island Transition")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Adaptive animations for all iPhone models")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Device Info Section
    private var deviceInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Device Information")
                .font(.headline)
            
            HStack {
                Text("Current Device:")
                Spacer()
                Text(DeviceDetector.deviceTypeDescription())
                    .fontWeight(.medium)
            }
            
            HStack {
                Text("Screen Size:")
                Spacer()
                Text("\(Int(UIScreen.main.bounds.width)) × \(Int(UIScreen.main.bounds.height))")
                    .fontWeight(.medium)
            }
            
            HStack {
                Text("Safe Area Top:")
                Spacer()
                Text("\(Int(DeviceDetector.topSafeAreaInset))pt")
                    .fontWeight(.medium)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Button Section
    private var buttonSection: some View {
        VStack(spacing: 16) {
            TransitionButton(
                title: "Default Transition",
                subtitle: "Standard animation timing",
                icon: "play.circle.fill",
                color: .blue
            ) {
                showDefaultTransition = true
            }
            
            TransitionButton(
                title: "Slowed Transition",
                subtitle: "To see how it moves",
                icon: "tortoise.fill",
                color: .orange
            ) {
                showSlowedTransition = true
            }
            
            TransitionButton(
                title: "Custom Configuration",
                subtitle: "Custom colors and materials",
                icon: "paintbrush.fill",
                color: .purple
            ) {
                showThemedTransition = true
            }
        }
    }
    
    @ViewBuilder func setupTransitions() -> some View {
        self
        // Default transition
            .notchTransition(isPresented: $showDefaultTransition) {
                DefaultTransitionContent(isPresented: $showDefaultTransition)
            }
        // Slowed transition
            .notchTransitionThemed(
                isPresented: $showSlowedTransition,
                backgroundColor: .purple,
                material: .ultraThinMaterial
            ) {
                ThemedTransitionContent(isPresented: $showSlowedTransition)
            }
        // Custom configuration
            .notchTransition(
                isPresented: $showThemedTransition,
                configuration: customConfiguration
            ) {
                ThemedTransitionContent(isPresented: $showThemedTransition)
            }
    }
    
    var customConfiguration: TransitionConfiguration {
        TransitionConfiguration(
            animationTimings: TransitionConfiguration.AnimationTimings(
                initial: 0.1,
                notchToRectangle: 1.0,
                rectangleToFullscreen: 0.8,
                contentAppearance: 0.6
            ),
            backgroundColor: .indigo,
            backgroundMaterial: .regularMaterial
        )
    }
}

@available(iOS 16.4, *)
#Preview {
    NotchTransitionExample()
}
