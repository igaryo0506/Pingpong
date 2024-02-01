//
//  BarStackView.swift
//
//
//  Created by 五十嵐諒 on 2024/02/01.
//

import SwiftUI

struct BarStackView: View {
    @Binding var location: CGPoint
    var color: Color
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundStyle(.clear)
                .contentShape(Rectangle())
                .frame(height: 100)
                .gesture(
                    DragGesture(minimumDistance: 1, coordinateSpace: .global)
                        .onChanged { value in
                            location.x = value.location.x
                        }
                )
            Rectangle()
                .frame(width: 100, height: 10)
                .offset(x: location.x - 50)
                .foregroundStyle(color)
                .background{
                    GeometryReader { proxy in
                        Rectangle()
                            .foregroundStyle(.clear)
                            .onAppear {
                                location.y = proxy.frame(in: .global).midY
                            }
                    }
                }
        }
    }
}

#Preview {
    BarStackView(location: .constant(.zero), color: .black)
}
