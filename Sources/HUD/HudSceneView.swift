//
//  HudSceneView.swift
//  NotchTransition
//
//  Created by Eugene Kovs on 24.08.2025.
//  https://github.com/kovs705
//

import SwiftUI

struct HudSceneView: View {
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var ordersRouter: OrdersRouter
    
    var body: some View {
        ZStack {
            PassViewRepresentable()
            innerContent
        }
    }
    
    // MARK: - Components
    @ViewBuilder private var innerContent: some View {
        PassViewRepresentable()

    }
    
}

#if DEBUG
#Preview {
    HudSceneView()
        .environmentObject(Router())
}
#endif
