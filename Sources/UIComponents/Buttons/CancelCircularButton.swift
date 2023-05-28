//
//  CancelCircularButton.swift
//  
//
//  Created by Manu on 28/05/2023.
//

import SwiftUI

public struct CancelCircularButton: View {
    @GestureState private var isHighlighted = false
    @Environment(\.isEnabled) private var isEnabled
    private let size: CGFloat
    private let longPressDuration: CGFloat
    private let action: () -> Void

    public init(
        size: CGFloat = 60,
        longPressDuration: CGFloat = 3,
        action: @escaping () -> Void
    ) {
        self.size = size
        self.longPressDuration = longPressDuration
        self.action = action
    }

    public var body: some View {
        ZStack {
            Circle()
                .foregroundColor(
                    .pink.opacity(isHighlighted ? 0.1 : 0.2)
                )
                .animation(.default, value: isHighlighted)
            Circle()
                .trim(from: 0, to: isHighlighted ? 1 : 0)
                .stroke(.red, lineWidth: size * innerCircleStrokeLineWidthPercentage)
                .rotationEffect(.degrees(-90))
                .scaleEffect(x: innerCircleScaleEffectPercentage, y: innerCircleScaleEffectPercentage)
                .animation(.linear(duration: isHighlighted ? longPressDuration : 0.3), value: isHighlighted)

            Image(systemName: "xmark")
                .resizable()
                .frame(width: size * 0.3, height: size * 0.3)
                .foregroundColor(.red)
                .scaleEffect(isHighlighted ? 0.8 : 1)
                .animation(.spring(), value: isHighlighted)
        }
        .frame(width: size, height: size)
        .gesture(longPress)
        .opacity(isEnabled ? 1 : 0.5)
    }
}

private extension CancelCircularButton {
    /// The line width of the circular progress is a percentage of the size.
    var innerCircleStrokeLineWidthPercentage: CGFloat {
        0.1
    }

    /// Workaround to make it look like an inner-border.
    var innerCircleScaleEffectPercentage: CGFloat {
        1 - innerCircleStrokeLineWidthPercentage
    }

    var longPress: some Gesture {
        LongPressGesture(minimumDuration: longPressDuration)
            .updating($isHighlighted) { currentState, gestureState, _ in
                gestureState = currentState
            }
            .onEnded { _ in
                action()
            }
    }
}

struct CancelCircularButton_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            CancelCircularButton {
                print("Finished")
            }
        }
    }
}
