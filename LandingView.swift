//
//  LandingView.swift
//  Pingpong
//
//  Created by 五十嵐諒 on 2024/01/30.
//

import SwiftUI

struct LandingView: View {
    @Binding var showingView: ContentView.Views
    var body: some View {
        VStack(spacing: 64) {
            Text("Ping Pong Wars")
                .font(.largeTitle)
                .bold()
            VStack(spacing: 16) {
                Button {
                    showingView = .gameView
                } label: {
                    Text("Single Player")
                        .font(.title2)
                }
                Button {
                    showingView = .gameView
                } label: {
                    Text("Multi Player")
                        .font(.title2)
                }
            }
        }
    }
}

#Preview {
    LandingView(showingView: .constant(.landingView))
}
