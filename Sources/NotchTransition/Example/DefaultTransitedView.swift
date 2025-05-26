//
//  DefaultTransitedView.swift
//  NotchTransition
//
//  Created by Eugene Kovs on 26.05.2025.
//  https://github.com/kovs705
//

import SwiftUI

struct DefaultTransitedView: View {
    
    @Binding var showTransition: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Destination Content")
                .font(.largeTitle)
                .foregroundColor(.white)
            
            Text("This is the content that appears after the animation")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Close") {
                showTransition = false
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}
