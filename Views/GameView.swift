//
//  GameView.swift
//  Pingpong
//
//  Created by 五十嵐諒 on 2024/01/30.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel = .init()
    @State var dragLocation: CGPoint = .init(x: 100, y: 0)
    var body: some View {
        ZStack {
            VStack {
                Spacer(minLength: 100)
                GeometryReader { proxy in
                    Grid(horizontalSpacing: 1, verticalSpacing: 1) {
                        ForEach(0 ..< gameViewModel.board.bricks.count, id: \.self) { lineIndex in
                            GridRow {
                                ForEach(0 ..< gameViewModel.board.bricks[lineIndex].count, id: \.self) { pixelIndex in
                                    BrickView(brick: $gameViewModel.board.bricks[lineIndex][pixelIndex])
                                }
                            }
                        }
                    }
                    .onAppear{
                        gameViewModel.prepare(boardFrame: proxy.frame(in: .global))
                    }
                }
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundStyle(.clear)
                        .contentShape(Rectangle())
                        .frame(height: 100)
                        .gesture(
                            DragGesture(minimumDistance: 1, coordinateSpace: .global)
                                .onChanged { value in
                                  self.dragLocation = value.location
                                    print(dragLocation.x)
                                }
                        )
                    Rectangle()
                        .frame(width: 100, height: 10)
                        .offset(x: dragLocation.x - 50)
                }
            }
            ForEach(0 ..< gameViewModel.board.balls.count, id: \.self) { ballIndex in
                BallView(ball: $gameViewModel.board.balls[ballIndex])
                    .position(CGPoint(x: gameViewModel.board.balls[ballIndex].position.x, y: gameViewModel.board.balls[ballIndex].position.y))
            }
        }
        .background(.gray)
        .ignoresSafeArea()
    }
}


#Preview {
    GameView()
}
