//
//  GameView.swift
//  Pingpong
//
//  Created by 五十嵐諒 on 2024/01/30.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel = .init()
    @Binding var showingView: ContentView.Views
    private var safeareaInsets: UIEdgeInsets {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        return windowScene?.windows.first?.safeAreaInsets ?? .init()
    }
    var body: some View {
        ZStack {
            VStack {
                Text("Score: \(gameViewModel.score)")
                Spacer(minLength: 100)
                BoardView(
                    bricks: $gameViewModel.board.bricks,
                    prepare: { boardFrame in
                        gameViewModel.prepare(boardFrame: boardFrame)
                    })
                BarStackView(location: $gameViewModel.board.barPosition)
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
    GameView(showingView: .constant(.gameView))
}
