//
//  GameView.swift
//  Pingpong
//
//  Created by 五十嵐諒 on 2024/01/30.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel = .init()
    var body: some View {
        ZStack {
            VStack {
                Spacer(minLength: 100)
                GeometryReader { proxy in
                    Grid(horizontalSpacing: 1, verticalSpacing: 1) {
                        ForEach(0 ..< gameViewModel.bricks.count, id: \.self) { lineIndex in
                            GridRow {
                                ForEach(0 ..< gameViewModel.bricks[lineIndex].count, id: \.self) { pixelIndex in
                                    BrickView(brick: $gameViewModel.bricks[lineIndex][pixelIndex])
                                }
                            }
                        }
                    }
                    .onAppear{
                        gameViewModel.prepare(boardFrame: proxy.frame(in: .global))
                        gameViewModel.start()
                    }
                }
                Spacer(minLength: 100)
            }
            ForEach(0 ..< gameViewModel.balls.count, id: \.self) { ballIndex in
                BallView(ball: $gameViewModel.balls[ballIndex])
                    .position(CGPoint(x: gameViewModel.balls[ballIndex].position.x, y: gameViewModel.balls[ballIndex].position.y))
            }
        }
        .background(.gray)
        .ignoresSafeArea()
    }
}


#Preview {
    GameView()
}
