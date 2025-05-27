//
//  ThemedTransitionContent.swift
//  NotchTransition
//
//  Created by Eugene Kovs on 25.05.2025.
//  https://github.com/kovs705
//

import SwiftUI

struct ThemedTransitionContent: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "gearshape.2.fill")
                .font(.system(size: 60))
                .foregroundColor(.cyan)
            
            Text("Custom Configuration")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Fully customized animation timings, colors, and materials.")
                .font(.body)
                .foregroundColor(.white)
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

#if DEBUG
#Preview {
    ThemedTransitionContent(isPresented: .constant(true))
        .background(.cyan)
}
#endif
