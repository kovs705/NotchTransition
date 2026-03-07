//
//  View+NotchTransition.swift
//  NotchTransition
//
//  Created by Eugene Kovs on 25.05.2025.
//  https://github.com/kovs705
//

import SwiftUI
import UIKit

// MARK: - Modifier

@available(iOS 16.4, *)
private struct NotchTransitionModifier<TransitionContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let configuration: TransitionConfiguration
    @ViewBuilder let content: () -> TransitionContent

    @State private var overlayWindow: UIWindow?
    @State private var dismissTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { newValue in
                if newValue {
                    show()
                } else {
                    scheduleDismiss()
                }
            }
            .onDisappear {
                dismissTask?.cancel()
                overlayWindow?.isHidden = true
                overlayWindow = nil
            }
    }

    // MARK: - Window lifecycle

    private func show() {
        dismissTask?.cancel()
        dismissTask = nil

        guard overlayWindow == nil,
              let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        else { return }

        let window = UIWindow(windowScene: scene)
        window.frame = scene.screen.bounds
        window.backgroundColor = .clear
        window.isOpaque = false
        window.windowLevel = .alert

        let hostingVC = UIHostingController(
            rootView: NotchTransition(
                isPresented: $isPresented,
                configuration: configuration,
                content: self.content
            )
        )
        hostingVC.view.backgroundColor = .clear
        window.rootViewController = hostingVC
        window.isHidden = false

        overlayWindow = window
    }

    private func scheduleDismiss() {
        // Match NotchTransition.dismissAnimation: 0.1s delay + 0.4s bounce + buffer
        dismissTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.65))
            guard !Task.isCancelled else { return }
            overlayWindow?.isHidden = true
            overlayWindow = nil
        }
    }
}

// MARK: - Public API

@available(iOS 16.4, *)
public extension View {

    /// Present a view with Dynamic Island transition animation
    func notchTransition<Content: View>(
        isPresented: Binding<Bool>,
        configuration: TransitionConfiguration = .default,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(NotchTransitionModifier(
            isPresented: isPresented,
            configuration: configuration,
            content: content
        ))
    }

    /// Present a view with Dynamic Island transition using predefined slow animation
    func notchTransitionSlow<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        notchTransition(isPresented: isPresented, configuration: .slow, content: content)
    }

    /// Present a view with Dynamic Island transition using custom theme
    func notchTransitionThemed<Content: View>(
        isPresented: Binding<Bool>,
        backgroundColor: Color,
        material: Material? = .ultraThinMaterial,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        notchTransition(
            isPresented: isPresented,
            configuration: .themed(backgroundColor: backgroundColor, material: material),
            content: content
        )
    }
}
