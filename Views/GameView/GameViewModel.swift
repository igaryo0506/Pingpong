//
//  GameViewModel.swift
//  Pingpong
//
//  Created by 五十嵐諒 on 2024/01/30.
//

import SwiftUI
class GameViewModel: ObservableObject {
    @Published var board: Board
    @Published var score: Int = 0
    private let xLength = 16
    private let yLength = 16
    private var timer: Timer?
    var changeShowingView: (ContentView.Views) -> ()
    init(changeShowingView: @escaping (ContentView.Views) -> ()) {
        let bricks: [[Brick]] = Array(repeating: Array(repeating: .init(color: .black), count: xLength), count: yLength / 2) + Array(repeating: Array(repeating: .init(), count: xLength), count: yLength / 2)
        self.board = .init(
            bricks: bricks,
            size: .init(x: xLength, y: yLength)
        )
        self.changeShowingView = changeShowingView
    }
    
    func prepare(boardFrame: CGRect) {
        board.addScore = { [weak self] point in
            self?.score += point
        }
        board.finish = { [weak self] text in
            self?.timer?.invalidate()
            self?.changeShowingView(.scoreView(score: self?.score ?? 0, result: text))
        }
        board.setBalls(boardFrame: boardFrame)
        start()
    }
    
    func start() {
        Task { @MainActor in
            try await Task.sleep(nanoseconds: 1000 * 1000 * 1000)
            await MainActor.run {
                timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] _ in
                    guard let self else { return }
                    board.update()
                }
            }
        }
    }
    
    func back() {
        changeShowingView(.landingView)
    }
}
