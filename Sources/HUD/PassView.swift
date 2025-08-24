//
//  PassView.swift
//  NotchTransition
//
//  Created by Eugene Kovs on 24.08.2025.
//  https://github.com/kovs705
//

import UIKit
import SwiftUI

class PassView: UIView {}

/// A UIWindow subclass that passes through touches unless a subview is hit.
class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        // If the hit view is the PassView (background), pass through
        if hitView?.isKind(of: PassView.self) == true {
            return nil
        }
        return hitView
    }
}

// UIViewRepresentable for PassView to use as a SwiftUI background
struct PassViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> PassView {
        let view = PassView()
        view.backgroundColor = .clear
        return view
    }
    func updateUIView(_ uiView: PassView, context: Context) {}
}
