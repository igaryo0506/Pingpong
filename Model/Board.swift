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
    var barPosition: CGPoint = .init(x: 100, y: 0)
    var enemyBarPosition: CGPoint = .init(x: 100, y: 0)
    var addScore: ((Int) -> ())?
    var finish: ((String) -> ())?
    var gameMode: GameMode = .single
    
    var width: CGFloat {
        boardFrame.width
    }
    var height: CGFloat {
        boardFrame.height
    }
    
    init(bricks: [[Brick]], size: Size, gameMode: GameMode) {
        self.bricks = bricks
        self.size = size
        self.gameMode = gameMode
    }
    
    mutating func setBalls(boardFrame: CGRect) {
        self.balls = [
            .init(
                position: .init(x: boardFrame.midX, y: boardFrame.minY),
                color: .white,
                direction: .init(dx: 3.0 / 5, dy: 4.0 / 5),
                speed: 10.0
            ),
            .init(
                position: .init(x: boardFrame.midX, y: boardFrame.maxY),
                color: .black,
                direction: .init(dx: -3.0 / 5, dy: -4.0 / 5),
                speed: 10.0
            )
        ]
        self.boardFrame = boardFrame
    }
    
    mutating func update() {
        var newBricks:[[Brick]] = bricks
        var newBalls: [Ball] = []
        for ball in balls {
            var newBall = ball
            newBall.update()
            if gameMode == .single {
                if ball.color == .white {
                    enemyBarPosition.x = ball.position.x
                }
            }
            (newBall, newBricks) = checkConflict(ball: newBall, oldBricks: newBricks)
            newBalls += [newBall]
        }
        bricks = newBricks
        balls = newBalls
    }
    
    func checkConflict(ball: Ball, oldBricks: [[Brick]]) -> (Ball, [[Brick]]) {
        var newBall = ball
        var newBricks = oldBricks
        newBall = checkConflictWithWall(ball: newBall)
        (newBall, newBricks) = checkConflictWithBrick(ball: newBall, oldBricks: newBricks)
        newBall = checkConflictWithBar(ball: newBall)
        return (newBall,newBricks)
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
        if enemyBarPosition.y - 300 > ball.position.y {
            finish?("Win")
        }
        if barPosition.y + 300 <= ball.position.y {
            finish?("Lose")
        }
        return newBall
    }
    
    func checkConflictWithBrick(ball: Ball, oldBricks:[[Brick]]) -> (Ball,[[Brick]]) {
        var newBall = ball
        var newBricks = oldBricks
        let coordinate: Size = calcCoordinate(position: ball.position)
        let lastCoordinate: Size = calcCoordinate(position: ball.lastPosition)
        if 0 > coordinate.x || coordinate.x >= size.x || 0 > coordinate.y || coordinate.y >= size.y {
//            print("error occured, ball is going out of wall")
//            print("color:", ball.color)
//            print("coordinate:", coordinate)
//            print("position: ", ball.position, boardFrame.maxY)
//            
            return (ball, newBricks)
        }
        var isToggled = false
        if coordinate.x != lastCoordinate.x && newBall.color == bricks[coordinate.y][coordinate.x].color {
            if !isToggled {
                newBricks[coordinate.y][coordinate.x].toggle()
                isToggled = true
            }
            newBall.toggleDirectionX()
            addScore?(1)
        }
        if coordinate.y != lastCoordinate.y && newBall.color == bricks[coordinate.y][coordinate.x].color{
            if !isToggled {
                newBricks[coordinate.y][coordinate.x].toggle()
                isToggled = true
            }
            newBall.toggleDirectionY()
            addScore?(1)
        }
        return (newBall, newBricks)
    }
    
    func checkConflictWithBar(ball: Ball) -> Ball {
        var newBall = ball
        if (barPosition.y - ball.lastPosition.y) >= -5 &&
            (ball.position.y - barPosition.y) >= -5 &&
            barPosition.x - 50 < ball.position.x &&
            ball.position.x < barPosition.x + 50
        {
            let offset = ball.position.x - barPosition.x
            newBall.conflictWithBar(offset: offset)
            newBall.toggleDirectionY()
            newBall.position.y = ball.position.y * 2 - barPosition.y
            addScore?(5)
        }
        if (ball.lastPosition.y - enemyBarPosition.y) >= -5 &&
            (enemyBarPosition.y - ball.position.y) >= -5 &&
            enemyBarPosition.x - 50 < ball.position.x &&
            ball.position.x < enemyBarPosition.x + 50
        {
            newBall.toggleDirectionY()
            newBall.position.y = ball.position.y * 2 - enemyBarPosition.y
            addScore?(5)
        }
        return newBall
    }
    
    func calcCoordinate(position: CGPoint) -> Size {
        return .init(
            x: Int((position.x - boardFrame.minX) / (width / CGFloat(size.x))),
            y: Int((position.y - boardFrame.minY) / (height / CGFloat(size.y)))
        )
    }
}
