//
//  GameViewModel.swift
//  Pingpong
//
//  Created by 五十嵐諒 on 2024/01/30.
//

import SwiftUI
class GameViewModel: ObservableObject {
    let xLength = 8
    let yLength = 16
    @Published var bricks: [[Brick]]
    @Published var balls: [Ball] = []
    private var boardFrame: CGRect = .zero
    var width: CGFloat {
        boardFrame.width
    }
    var height: CGFloat {
        boardFrame.height
    }
    
    init() {
        self.bricks = Array(repeating: Array(repeating: .init(color: .black), count: xLength), count: yLength / 2) + Array(repeating: Array(repeating: .init(), count: xLength), count: yLength / 2)
    }
    
    func prepare(boardFrame: CGRect) {
        self.balls = [
            .init(
                position: .init(x: boardFrame.midX, y: boardFrame.minY + 10),
                color: .white,
                direction: .init(dx: 5, dy: 10)
            ),
            .init(position: .init(x: boardFrame.midX, y: boardFrame.maxY - 10), color: .black)
        ]
        self.boardFrame = boardFrame
    }
    
    func start() {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self else { return }
            for ballIndex in 0 ..< self.balls.count {
                self.balls[ballIndex].update()
            }
            checkConflict()
        }
    }
    
    func checkConflict() {
        for ballIndex in 0 ..< self.balls.count {
            if boardFrame.minX > balls[ballIndex].position.x {
                balls[ballIndex].toggleDirectionX()
            }
            if boardFrame.maxX < balls[ballIndex].position.x {
                balls[ballIndex].toggleDirectionX()
            }
            if boardFrame.minY > balls[ballIndex].position.y {
                balls[ballIndex].toggleDirectionY()
            }
            if boardFrame.maxY < balls[ballIndex].position.y {
                balls[ballIndex].toggleDirectionY()
            }
            let coordinate: (Int,Int) = (
                Int((balls[ballIndex].position.x - boardFrame.minX) / (width / CGFloat(xLength))),
                Int((balls[ballIndex].position.y - boardFrame.minY) / (height / CGFloat(yLength)))
            )
            let lastCoordinate: (Int,Int) = (
                Int((balls[ballIndex].lastPosition.x - boardFrame.minX) / (width / CGFloat(xLength))),
                Int((balls[ballIndex].lastPosition.y - boardFrame.minY) / (height / CGFloat(yLength)))
            )
            if 0 > coordinate.0 || coordinate.0 >= xLength || 0 > coordinate.1 || coordinate.1 >= yLength {
                continue
            }
            if coordinate.0 != lastCoordinate.0 && balls[ballIndex].color == bricks[coordinate.1][coordinate.0].color {
                bricks[coordinate.1][coordinate.0].toggle()
                balls[ballIndex].toggleDirectionX()
            }
            if coordinate.1 != lastCoordinate.1 && balls[ballIndex].color == bricks[coordinate.1][coordinate.0].color{
                bricks[coordinate.1][coordinate.0].toggle()
                balls[ballIndex].toggleDirectionY()
            }
        }
        print("")
    }
}
