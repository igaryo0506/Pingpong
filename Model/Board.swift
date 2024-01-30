//
//  File.swift
//  
//
//  Created by 五十嵐諒 on 2024/01/30.
//

import Foundation
struct Board {
    var bricks: [[Brick]]
    var balls: [Ball] = []
    private var boardFrame: CGRect = .zero
    let size: Size
    
    var width: CGFloat {
        boardFrame.width
    }
    var height: CGFloat {
        boardFrame.height
    }
    
    init(bricks: [[Brick]], size: Size) {
        self.bricks = bricks
        self.size = size
    }
    
    mutating func setBalls(boardFrame: CGRect) {
        self.balls = [
            .init(
                position: .init(x: boardFrame.midX, y: boardFrame.minY + 10),
                color: .white,
                direction: .init(dx: 5, dy: 10)
            ),
            .init(
                position: .init(x: boardFrame.midX, y: boardFrame.maxY - 10),
                color: .black
            )
        ]
        self.boardFrame = boardFrame
    }
    
    mutating func update() {
        updateBallState()
        checkConflict()
    }
    
    mutating func updateBallState() {
        for ballIndex in 0 ..< self.balls.count {
            self.balls[ballIndex].update()
        }
    }
    
    mutating func checkConflict() {
        balls = balls.map { ball in
            var newBall = ball
            newBall = checkConflictWithWall(ball: newBall)
            (newBall, bricks) = checkConflictWithBrick(ball: newBall, bricks: bricks)
            return newBall
        }
    }
    
    func checkConflictWithWall(ball: Ball) -> Ball {
        var newBall = ball
        if boardFrame.minX > ball.position.x {
            newBall.toggleDirectionX()
            newBall.position.x = boardFrame.minX * 2 - newBall.position.x
        }
        if boardFrame.maxX < ball.position.x {
            newBall.toggleDirectionX()
            newBall.position.x = boardFrame.maxX * 2 - newBall.position.x
        }
        if boardFrame.minY > ball.position.y {
            newBall.toggleDirectionY()
            newBall.position.y = boardFrame.minY * 2 - newBall.position.y
        }
        if boardFrame.maxY <= ball.position.y {
            newBall.toggleDirectionY()
            newBall.position.y = boardFrame.maxY * 2 - newBall.position.y
        }
        return newBall
    }
    
    func checkConflictWithBrick(ball: Ball, bricks:[[Brick]]) -> (Ball,[[Brick]]) {
        var newBall = ball
        var newBricks = bricks
        let coordinate: Size = calcCoordinate(position: ball.position)
        let lastCoordinate: Size = calcCoordinate(position: ball.lastPosition)
        if 0 > coordinate.x || coordinate.x >= size.x || 0 > coordinate.y || coordinate.y >= size.y {
            print("error occured, ball is going out of wall")
            print("color:", ball.color)
            print("coordinate:", coordinate)
            print("position: ", ball.position, boardFrame.maxY)
            
            return (ball, bricks)
        }
        var isToggled = false
        if coordinate.x != lastCoordinate.x && newBall.color == bricks[coordinate.y][coordinate.x].color {
            if !isToggled {
                newBricks[coordinate.y][coordinate.x].toggle()
                isToggled = true
            }
            newBall.toggleDirectionX()
        }
        if coordinate.y != lastCoordinate.y && newBall.color == bricks[coordinate.y][coordinate.x].color{
            if !isToggled {
                newBricks[coordinate.y][coordinate.x].toggle()
                isToggled = true
            }
            newBall.toggleDirectionY()
        }
        return (newBall, newBricks)
    }
    
    func calcCoordinate(position: CGPoint) -> Size {
        return .init(
            x: Int((position.x - boardFrame.minX) / (width / CGFloat(size.x))),
            y: Int((position.y - boardFrame.minY) / (height / CGFloat(size.y)))
        )
    }
}
