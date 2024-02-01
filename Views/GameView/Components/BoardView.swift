//
//  BoardView.swift
//  
//
//  Created by 五十嵐諒 on 2024/01/30.
//

import SwiftUI

struct BoardView: View {
    @Binding var bricks: [[Brick]]
    var prepare: (CGRect) -> ()
    var body: some View {
        GeometryReader { proxy in
            Grid(horizontalSpacing: 1, verticalSpacing: 1) {
                ForEach(0 ..< bricks.count, id: \.self) { lineIndex in
                    GridRow {
                        ForEach(0 ..< bricks[lineIndex].count, id: \.self) { pixelIndex in
                            BrickView(brick: $bricks[lineIndex][pixelIndex])
                        }
                    }
                }
            }
            .onAppear{
                prepare(proxy.frame(in: .global))
            }
        }
    }
}

#Preview {
    BoardView(bricks: .constant([]), prepare: {_ in})
}
