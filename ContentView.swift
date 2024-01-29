import SwiftUI

struct ContentView: View {
    var body: some View {
        GameView()
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
