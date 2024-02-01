import SwiftUI

struct ContentView: View {
    enum Views {
        case gameView
        case landingView
        case scoreView(score: Int, result: String)
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
        case .scoreView(let score, let result):
            ResultView(
                showingView: $showingView,
                result: result,
                score: score
            )
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
