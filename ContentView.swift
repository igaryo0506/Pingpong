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
            ForEach(0 ..< gameViewModel.balls.count, id: \.self) { ballIndex in
                BallView(ball: $gameViewModel.balls[ballIndex])
                    .position(CGPoint(x: gameViewModel.balls[ballIndex].position.x, y: gameViewModel.balls[ballIndex].position.y))
            }
        }
        .background(.gray)
        .ignoresSafeArea()
    }
}

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


struct BallView: View {
    @Binding var ball: Ball
    var body: some View {
        Circle()
            .frame(width: 16, height: 16)
            .foregroundStyle(ball.color)
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
    var position: CGPoint {
        didSet {
            lastPosition = oldValue
        }
    }
    var color: Color
    var direction: CGVector
    var lastPosition: CGPoint
    init(position: CGPoint, color: Color, direction: CGVector = .init(dx: 3, dy: 1)) {
        self.position = position
        self.lastPosition = .zero
        self.color = color
        self.direction = direction
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
