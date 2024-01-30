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
        Button {
            showingView = .gameView
        } label: {
            Text("Start")
        }
    }
}

#Preview {
    LandingView(showingView: .constant(.landingView))
}
