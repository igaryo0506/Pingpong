//
//  Brick.swift
//  Pingpong
//
//  Created by 五十嵐諒 on 2024/01/30.
//

import SwiftUI
struct Brick: Equatable {
    var id: UUID = .init()
    var color: Color
    init(color: Color = .white) {
        self.color = color
    }
    mutating func toggle() {
        if color == .white {
            color = .black
        } else {
            color = .white
        }
    }
}
