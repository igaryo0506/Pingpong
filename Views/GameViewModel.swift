//
//  GameViewModel.swift
//  Pingpong
//
//  Created by 五十嵐諒 on 2024/01/30.
//

import SwiftUI
class GameViewModel: ObservableObject {
    @Published var board: Board
    private let xLength = 8
    private let yLength = 16
    init() {
        let bricks: [[Brick]] = Array(repeating: Array(repeating: .init(color: .black), count: xLength), count: yLength / 2) + Array(repeating: Array(repeating: .init(), count: xLength), count: yLength / 2)
        self.board = .init(bricks: bricks, size: .init(x: xLength, y: yLength))
        start()
    }
    
    func prepare(boardFrame: CGRect) {
        board.setBalls(boardFrame: boardFrame)
    }
    
    func start() {
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] _ in
            guard let self else { return }
            board.update()
        }
    }
}
