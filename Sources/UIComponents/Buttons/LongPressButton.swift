//
//  LongPressButton.swift
//  
//
//  Created by Manu on 28/05/2023.
//

import SwiftUI

/// A button that needs to be pressed for a given amount of seconds before executing it's action.
/// It contain 4 states:
/// * `initial`: The only state where the button can be tapped.
/// * `loading`: Displays a progress view to the right of the text.
/// * `success`.
/// * `error`.
public struct LongPressButton: View {
    @GestureState private var isHighlighted = false
    @Binding private var state: LongPressButton.State
    private var onLongPressEnd: () -> Void
    private var title: String
    private var loadingTitle: String?
    private var successTitle: String?
    private var errorTitle: String?
    private var longPressDuration: CGFloat

    /// Initializer.
    /// - Parameters:
    ///   - title: The title of the button.
    ///   - loadingTitle: Optional text to display when the state is `loading`. If `nil` it will display the title.
    ///   - successTitle: Optional text to display when the state is `success`. If `nil` it will display the title.
    ///   - errorTitle: Optional text to display when the state is `error`. If `nil` it will display the title.
    ///   - state: The binding state for the button.
    ///   - longPressDuration: The long press duration for the tap gesture. Default = 5 seconds.
    ///   - onLongPressEnd: The action to execute after the long tap gesture is finished.
    public init(
        _ title: String,
        loadingTitle: String? = nil,
        successTitle: String? = nil,
        errorTitle: String? = nil,
        state: Binding<LongPressButton.State>,
        longPressDuration: CGFloat = 5,
        onLongPressEnd: @escaping () -> Void
    ) {
        self.title = title
        self.loadingTitle = loadingTitle
        self.successTitle = successTitle
        self.errorTitle = errorTitle
        _state = state
        self.longPressDuration = longPressDuration
        self.onLongPressEnd = onLongPressEnd
    }

    public var body: some View {
        HStack(spacing: ViewConstants.spacing) {
            Text(buttonTitle)
                .font(ViewConstants.font)
                .lineLimit(1)
                .minimumScaleFactor(0.1)

            if state == .loading {
                ProgressView()
                    .tint(ViewConstants.foregroundColor)
                    .transition(.slide)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(state.backgroundColor)
        .cornerRadius(ViewConstants.cornerRadius)
        .foregroundColor(foregroundColor)
        .gesture(longPress)
        .overlay {
            animationOverlay
        }
        .disabled(isDisabled)
    }
}

public extension LongPressButton {
    /// The state representing the source of truth for the button.
    enum State {
        /// Initial state. The only state where the button can be tapped.
        case initial
        /// Displays a ProgressView.
        case loading
        /// Changes the background color to a success color.
        case success
        /// Changes the background color to an error color.
        case error

        var backgroundColor: Color {
            switch self {
            case .initial, .loading:
                return .accentColor
            case .success:
                return .green
            case .error:
                return .red
            }
        }
    }
}

private extension LongPressButton {
    enum ViewConstants {
        static let font: Font = .title3.bold()
        static let foregroundColor: Color = .white
        static let cornerRadius: CGFloat = 8
        static let spacing: CGFloat = 8

        enum Overlay {
            static let foregroundColor: Color = .black.opacity(0.1)
        }
    }

    var longPress: some Gesture {
        LongPressGesture(minimumDuration: longPressDuration)
            .updating($isHighlighted) { currentState, gestureState, _ in
                gestureState = currentState
            }
            .onEnded { _ in
                withAnimation {
                    /// Usually the callers will change the state of the button here.
                    /// So we change it with an animation.
                    onLongPressEnd()
                }
            }
    }

    var foregroundColor: Color {
        ViewConstants.foregroundColor.opacity(isHighlighted ? 0.8 : 1)
    }

    var isDisabled: Bool {
        state != .initial
    }

    var animationOverlay: some View {
        Rectangle()
            .foregroundColor(ViewConstants.Overlay.foregroundColor)
            .scaleEffect(x: isHighlighted ? 1 : 0, anchor: .leading)
            .clipShape(RoundedRectangle(cornerRadius: ViewConstants.cornerRadius))
            .animation(.linear(duration: isHighlighted ? longPressDuration : 1), value: isHighlighted)
    }

    var buttonTitle: String {
        switch state {
        case .initial:
            return title
        case .loading:
            return loadingTitle ?? title
        case .success:
            return successTitle ?? title
        case .error:
            return errorTitle ?? title
        }
    }
}

struct LongPressButton_Previews: PreviewProvider {
    /// Example of LongPressButton usage.
    struct LongPressButtonPreviewer: View {
        @Binding var state: LongPressButton.State
        var action: () -> Void

        var body: some View {
            LongPressButton(
                "Button",
                loadingTitle: "Loading",
                successTitle: "Success",
                errorTitle: "Error",
                state: $state,
                longPressDuration: 2
            ) {
                action()
            }
        }
    }

    struct LongPressButtonsContainer: View {
        @State var firstState = LongPressButton.State.initial
        @State var secondState = LongPressButton.State.initial
        @State var thirdState = LongPressButton.State.initial
        @State var fourthState = LongPressButton.State.initial

        var body: some View {
            VStack {
                LongPressButtonPreviewer(state: $firstState) { firstState = .loading }
                LongPressButtonPreviewer(state: $secondState) { secondState = .success }
                HStack {
                    LongPressButtonPreviewer(state: $thirdState) { thirdState = .error }
                    LongPressButtonPreviewer(state: $fourthState) {
                        fourthState = .loading
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                fourthState = .success
                            }
                        }
                    }
                }

                LongPressButton(
                    "Reset All",
                    state: .constant(.initial),
                    longPressDuration: 2
                ) {
                    firstState = .initial
                    secondState = .initial
                    thirdState = .initial
                    fourthState = .initial
                }

                LongPressButton("Loading", state: .constant(.loading), onLongPressEnd: {})
                LongPressButton("Success", state: .constant(.success), onLongPressEnd: {})
                LongPressButton("Error", state: .constant(.error), onLongPressEnd: {})

            }.padding()
        }
    }

    static var previews: some View {
        ScrollView {
            LongPressButtonsContainer()
        }
    }
}
