//
//  ContentView.swift
//  NotchTransition
//
//  Created by Eugene Kovs on 25.05.2025.
//  https://github.com/kovs705
//

import SwiftUI
//import DynamicIslandTransition

// MARK: - Example Usage
@available(iOS 16.4, *)
struct NotchTransitionExample: View {
    @State private var showDefaultTransition = false
    @State private var showFastTransition = false
    @State private var showThemedTransition = false
    @State private var showCustomTransition = false
    
    var body: some View {
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
        .dynamicIslandTransition(isPresented: $showDefaultTransition) {
            DefaultTransitedView(showTransition: $showDefaultTransition)
        }
        .dynamicIslandTransitionFast(isPresented: $showFastTransition) {
            DefaultTransitedView(showTransition: $showFastTransition)
        }
        .dynamicIslandTransitionSlow(isPresented: $showThemedTransition) {
            DefaultTransitedView(showTransition: $showThemedTransition)
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
                title: "Fast Transition",
                subtitle: "Quick and snappy animation",
                icon: "forward.circle.fill",
                color: .green
            ) {
                showFastTransition = true
            }
            
            TransitionButton(
                title: "Themed Transition",
                subtitle: "Custom colors and materials",
                icon: "paintbrush.fill",
                color: .purple
            ) {
                showThemedTransition = true
            }
            
            TransitionButton(
                title: "Custom Configuration",
                subtitle: "Fully customized experience",
                icon: "gearshape.fill",
                color: .orange
            ) {
                showCustomTransition = true
            }
        }
    }
    
    @ViewBuilder func setupTransitions() -> some View {
        self
        // Default transition
            .dynamicIslandTransition(isPresented: $showDefaultTransition) {
                DefaultTransitionContent(isPresented: $showDefaultTransition)
            }
        // Fast transition
            .dynamicIslandTransitionFast(isPresented: $showFastTransition) {
                FastTransitionContent(isPresented: $showFastTransition)
            }
        // Themed transition
            .dynamicIslandTransition(
                isPresented: $showThemedTransition,
                backgroundColor: .purple,
                material: .ultraThinMaterial
            ) {
                ThemedTransitionContent(isPresented: $showThemedTransition)
            }
        // Custom configuration
            .dynamicIslandTransition(
                isPresented: $showCustomTransition,
                configuration: customConfiguration
            ) {
                CustomTransitionContent(isPresented: $showCustomTransition)
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
