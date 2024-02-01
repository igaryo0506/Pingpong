//
//  BallView.swift
//  Pingpong
//
//  Created by 五十嵐諒 on 2024/01/30.
//

import SwiftUI
struct BallView: View {
    @Binding var ball: Ball
    var body: some View {
        Circle()
            .frame(width: 16, height: 16)
            .foregroundStyle(ball.color)
    }
}

#Preview {
    BallView(ball: .constant(.init(position: .zero, color: .black, speed: 0.0)))
}
