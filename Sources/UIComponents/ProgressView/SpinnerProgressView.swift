//
//  SpinnerProgressView.swift
//  
//
//  Created by Manu on 28/05/2023.
//

import Foundation
import SwiftUI

public struct SpinnerProgressView: View {
    @State private var isLoading = false
    private let color: Color
    private let size: CGFloat
    private let lineWidth: CGFloat

    public init(
        color: Color = .accentColor,
        size: CGFloat = 20,
        lineWidth: CGFloat = 3
    ) {
        self.color = color
        self.size = size
        self.lineWidth = lineWidth
    }

    public var body: some View {
        Circle()
            .trim(from: 0, to: 0.67)
            .stroke(lineWidth: lineWidth)
            .foregroundColor(color)
            .frame(width: size, height: size)
            .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
            .animation(
                .linear.speed(0.75).repeatForever(autoreverses: false),
                value: isLoading
            )
            .onAppear {
                isLoading = true
            }
    }
}

struct SpinnerProgressView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            SpinnerProgressView()
            SpinnerProgressView(color: .gray)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 60)
                    .foregroundColor(.accentColor)
                SpinnerProgressView(color: .white)
            }
            Spacer()
        }.padding()
    }
}
