import SwiftUI

struct ContentView: View {
    var body: some View {
        GameView()
    }
}

struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel = .init()
    var body: some View {
        ZStack {
            VStack {
                Spacer(minLength: 100)
                GeometryReader { proxy in
                    Grid(horizontalSpacing: 1, verticalSpacing: 1) {
                        ForEach(0 ..< gameViewModel.bricks.count, id: \.self) { lineIndex in
                            GridRow {
                                ForEach(0 ..< gameViewModel.bricks[lineIndex].count, id: \.self) { pixelIndex in
                                    BrickView(brick: $gameViewModel.bricks[lineIndex][pixelIndex])
                                }
                            }
                        }
                    }
                    .onAppear{
                        gameViewModel.prepare(boardFrame: proxy.frame(in: .global))
                        gameViewModel.start()
                    }
                }
                Spacer(minLength: 100)
            }
            BallView(ball: $gameViewModel.ball)
                .position(CGPoint(x: gameViewModel.ball.position.x, y: gameViewModel.ball.position.y))
        }
        .background(.gray)
        .ignoresSafeArea()
    }
}

class GameViewModel: ObservableObject {
    let xLength = 8
    let yLength = 16
    @Published var bricks: [[Brick]]
    @Published var ball: Ball
    private var boardFrame: CGRect = .zero
    var width: CGFloat {
        boardFrame.width
    }
    var height: CGFloat {
        boardFrame.height
    }
    
    init() {
        self.bricks = Array(repeating: Array(repeating: .init(color: .black), count: xLength), count: yLength / 2) + Array(repeating: Array(repeating: .init(), count: xLength), count: yLength / 2)
        self.ball = .init(position: .zero, color: .blue)
    }
    
    func prepare(boardFrame: CGRect) {
        self.ball.position = .init(x: boardFrame.midX, y: boardFrame.minY + 10)
        self.boardFrame = boardFrame
    }
    
    func start() {
        var timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.ball.update()
            checkConflict()
        }
    }
    
    func checkConflict() {
        if boardFrame.minX > ball.position.x {
            ball.toggleDirectionX()
        }
        if boardFrame.maxX < ball.position.x {
            ball.toggleDirectionX()
        }
        if boardFrame.minY > ball.position.y {
            ball.toggleDirectionY()
        }
        if boardFrame.maxY < ball.position.y {
            ball.toggleDirectionY()
        }
        var xIndex = Int((ball.position.x - boardFrame.minX) / (width / CGFloat(xLength)))
        var yIndex = Int((ball.position.y - boardFrame.minY) / (height / CGFloat(yLength)))
        if 0 <= xIndex && xIndex < xLength && 0 <= yIndex && yIndex < yLength {
            bricks[yIndex][xIndex].toggle()
        }
        print(xIndex, yIndex)
    }
}


struct BallView: View {
    @Binding var ball: Ball
    var body: some View {
        Circle()
            .frame(width: 16, height: 16)
            .foregroundStyle(.blue)
    }
}

struct BrickView: View {
    @Binding var brick: Brick
    var body: some View {
        Rectangle()
            .foregroundStyle(brick.color)
            .onTapGesture {
                brick.toggle()
            }
    }
}

struct Ball {
    var id: UUID = .init()
    var position: CGPoint
    var color: Color
    var direction: CGVector
    init(position: CGPoint, color: Color) {
        self.position = position
        self.color = color
        self.direction = .init(dx: 10, dy: 5)
    }
    mutating func update() {
        position = CGPoint(x: position.x + direction.dx, y: position.y + direction.dy)
    }
    
    mutating func toggleDirectionX(){
        direction.dx = -direction.dx
    }
    
    mutating func toggleDirectionY(){
        direction.dy = -direction.dy
    }
}

struct Brick {
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
