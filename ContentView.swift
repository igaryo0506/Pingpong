import SwiftUI

struct ContentView: View {
    @State var board: [[Brick]] = Array(repeating: Array(repeating: .init(color: .black), count: 8), count: 8) + Array(repeating: Array(repeating: .init(), count: 8), count: 8)
    var body: some View {
        ZStack {
            Grid(horizontalSpacing: 1, verticalSpacing: 1) {
                ForEach(0 ..< board.count, id: \.self) { lineIndex in
                    GridRow {
                        ForEach(0 ..< board[lineIndex].count, id: \.self) { pixelIndex in
                            BrickView(brick: $board[lineIndex][pixelIndex])
                        }
                    }
                }
            }
            .padding(.vertical, 32)
            .background(.gray)
        }
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
