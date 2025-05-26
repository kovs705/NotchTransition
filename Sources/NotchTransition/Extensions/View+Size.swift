//
//  View+Size.swift
//  NotchTransition
//
//  Created by Eugene Kovs on 26.05.2025.
//  https://github.com/kovs705
//

import SwiftUI

extension View {
    func getTheScreenRect() -> CGRect {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        return window.screen.bounds
    }
}
