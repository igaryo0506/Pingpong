//
//  ResultView.swift
//  
//
//  Created by 五十嵐諒 on 2024/02/01.
//

import SwiftUI

struct ResultView: View {
    @Binding var showingView: ContentView.Views
    var result: String
    var score: Int
    var body: some View {
        VStack(spacing: 32) {
            Text(result)
                .font(.largeTitle)
            // Text("score: \(score)")
            Button("Back to Title") {
                showingView = .landingView
            }
        }
    }
}

#Preview {
    ResultView(showingView: .constant(.scoreView(score: .zero, result: "")), result: "", score: 0)
}
