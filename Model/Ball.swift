//
//  Ball.swift
//  Pingpong
//
//  Created by 五十嵐諒 on 2024/01/30.
//

import SwiftUI
struct Ball {
    var id: UUID = .init()
    var position: CGPoint {
        didSet {
            lastPosition = oldValue
        }
    }
    var lastPosition: CGPoint = .zero
    var color: Color
    var direction: CGVector
    var speed: Double
    init(
        position: CGPoint,
        color: Color,
        direction: CGVector = .init(dx: 3, dy: 1),
        speed: Double
    ) {
        self.position = position
        self.color = color
        self.direction = direction
        self.speed = speed
    }
    mutating func update() {
        position = CGPoint(x: position.x + speed * direction.dx, y: position.y + speed * direction.dy)
    }
    
    mutating func toggleDirectionX(){
        direction.dx = -direction.dx
    }
    
    mutating func toggleDirectionY(){
        direction.dy = -direction.dy
    }
    
    mutating func conflictWithBar(offset: Double) {
        let ratio = offset / 50
        direction = CGVector(dx: sin(ratio), dy: cos(ratio))
    }
}
