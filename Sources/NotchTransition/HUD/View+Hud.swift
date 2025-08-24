//
//  File.swift
//  NotchTransition
//
//  Created by Eugene Kovs on 24.08.2025.
//  https://github.com/kovs705
//

import SwiftUI

extension View {
    @ViewBuilder func supportHud() -> some View {
        modifier(HudModifier())
    }
}

struct HudModifier: ViewModifier {
    
    @State private var overlayWindow: PassThroughWindow?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                placeOverlay()
                placeHubOnOverlay()
            }
    }
    
    // MARK: - Application overlay
    private func placeOverlay() {
        if overlayWindow == nil {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let overlayWindow = PassThroughWindow(windowScene: windowScene)
                // Ensure the overlay window is full‑screen
                overlayWindow.frame = windowScene.screen.bounds
                overlayWindow.backgroundColor = .clear
                overlayWindow.tag = 0320
                
                let controller = UIViewController()
                controller.view = PassView() // Use PassView for pass-through
                controller.view.backgroundColor = .clear
                overlayWindow.rootViewController = controller
                overlayWindow.isHidden = false
                overlayWindow.isUserInteractionEnabled = true
                self.overlayWindow = overlayWindow
            }
        }
    }
    
    private func placeHubOnOverlay() {
        guard
            let activeWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                .windows.first(where: { $0.tag == 0320 }),
            let rootVC = activeWindow.rootViewController
        else { return }

        // Build SwiftUI content in a UIHostingController (UIHostingConfiguration is size‑fitting and clips at safe‑area)
        let hostingController = UIHostingController(
            rootView: HudSceneView()
                .ignoresSafeArea()
        )
        hostingController.view.tag = 1009
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        // Attach as child VC so lifecycle is handled correctly
        rootVC.addChild(hostingController)
        rootVC.view.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: rootVC.view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: rootVC.view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: rootVC.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: rootVC.view.trailingAnchor)
        ])

        hostingController.didMove(toParent: rootVC)
//        hostingController.view.isUserInteractionEnabled = false
    }
    
    private func removeHubFromOverlay() {
        if let activeWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: { $0.tag == 0320 }) {
            if let view = activeWindow.viewWithTag(1009) {
                view.removeFromSuperview()
            }
        }
    }
}

