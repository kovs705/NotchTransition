//
//  View+NotchTransition.swift
//  NotchTransition
//
//  Created by Eugene Kovs on 25.05.2025.
//  https://github.com/kovs705
//

import SwiftUI

@available(iOS 16.4, *)
public extension View {
    
    /// Present a view with Dynamic Island transition animation
    /// - Parameters:
    ///   - isPresented: Binding to control presentation state
    ///   - configuration: Configuration for animation timing and appearance
    ///   - content: The content to present after animation
    func notchTransition<Content: View>(
        isPresented: Binding<Bool>,
        configuration: TransitionConfiguration = .default,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        fullScreenCover(isPresented: isPresented) {
            NotchTransition(
                isPresented: isPresented,
                configuration: configuration,
                content: content
            )
            .presentationBackground(.clear)
        }
    }
    
    /// Present a view with Dynamic Island transition using predefined slow animation
    func notchTransitionSlow<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        notchTransition(
            isPresented: isPresented,
            configuration: .slow,
            content: content
        )
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
