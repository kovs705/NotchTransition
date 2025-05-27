//
//  SlowedTransitionContent.swift
//  NotchTransition
//
//  Created by Eugene Kovs on 25.05.2025.
//  https://github.com/kovs705
//

import SwiftUI

struct SlowedTransitionContent: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 60))
                .foregroundColor(.yellow)
            
            Text("Slowed Transition")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Slowed transition to see how animations work")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Close") {
                isPresented = false
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
