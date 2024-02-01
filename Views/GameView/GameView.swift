//
//  GameView.swift
//  Pingpong
//
//  Created by 五十嵐諒 on 2024/01/30.
//

import SwiftUI

struct GameView: View {
    @StateObject var gameViewModel: GameViewModel
    private var safeareaInsets: UIEdgeInsets {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        return windowScene?.windows.first?.safeAreaInsets ?? .init()
    }
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Text("Score: \(gameViewModel.score)")
                    HStack {
                        Button("Back") {
                            gameViewModel.back()
                        }
                        Spacer()
                    }
                }
                .padding()
                BarStackView(
                    location: $gameViewModel.board.enemyBarPosition,
                    color: .white
                )
                BoardView(
                    bricks: $gameViewModel.board.bricks,
                    prepare: { boardFrame in
                        gameViewModel.prepare(boardFrame: boardFrame)
                    })
                BarStackView(
                    location: $gameViewModel.board.barPosition,
                    color: .black
                )
            }
            ForEach(0 ..< gameViewModel.board.balls.count, id: \.self) { ballIndex in
                BallView(ball: $gameViewModel.board.balls[ballIndex])
                    .position(CGPoint(x: gameViewModel.board.balls[ballIndex].position.x - safeareaInsets.left, y: gameViewModel.board.balls[ballIndex].position.y - safeareaInsets.top))
            }
        }
        .background(.gray)
        .onAppear {
            print(safeareaInsets)
        }
    }
}


#Preview {
    GameView(gameViewModel: .init(changeShowingView: {_ in}))
}
