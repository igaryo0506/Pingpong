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
                BarStackView(location: $gameViewModel.board.enemyBarPosition, color: .white)
                BoardView(
                    bricks: $gameViewModel.board.bricks,
                    prepare: { boardFrame in
                        gameViewModel.prepare(boardFrame: boardFrame)
                    })
                BarStackView(location: $gameViewModel.board.barPosition, color: .black)
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

struct BarStackView: View {
    @Binding var location: CGPoint
    var color: Color
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundStyle(.clear)
                .contentShape(Rectangle())
                .frame(height: 100)
                .gesture(
                    DragGesture(minimumDistance: 1, coordinateSpace: .global)
                        .onChanged { value in
                            location.x = value.location.x
                        }
                )
            Rectangle()
                .frame(width: 100, height: 10)
                .offset(x: location.x - 50)
                .foregroundStyle(color)
                .background{
                    GeometryReader { proxy in
                        Rectangle()
                            .foregroundStyle(.clear)
                            .onAppear {
                                location.y = proxy.frame(in: .global).midY
                            }
                    }
                }
        }
    }
}

#Preview {
    GameView(gameViewModel: .init(changeShowingView: {_ in}))
}
