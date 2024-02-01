import SwiftUI

struct ContentView: View {
    enum Views {
        case gameView
        case landingView
        case scoreView
    }
    @State var showingView: Views = .landingView
    var body: some View {
        switch(showingView) {
        case .gameView:
            GameView(
                gameViewModel: .init(
                    changeShowingView: { view in
                        showingView = view
                    }
                )
            )
        case .landingView:
            LandingView(showingView: $showingView)
        case .scoreView:
            Text("hello")
        }
    }
}



struct BrickView: View {
    @Binding var brick: Brick
    var body: some View {
        Rectangle()
            .foregroundStyle(brick.color)
    }
}
