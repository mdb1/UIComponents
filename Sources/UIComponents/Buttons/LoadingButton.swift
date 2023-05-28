//
//  LoadingButton.swift
//  
//
//  Created by Manu on 28/05/2023.
//

import Foundation
import SwiftUI

/// A button with 4 states:
/// * `initial`: The only state where the button can be tapped.
/// * `loading`: Displays a progress view to the right of the text.
/// * `success`: Changes the background color to a success color.
/// * `error`: Changes the background color to an error color.
public struct LoadingButton: View {
    private var title: String
    private var loadingTitle: String?
    private var successTitle: String?
    private var errorTitle: String?
    @Binding private var state: LoadingButton.State
    private var action: () -> Void

    /// Initializer.
    /// - Parameters:
    ///   - title: The title of the button.
    ///   - loadingTitle: Optional text to display when the state is `loading`. If `nil` it will display the title.
    ///   - successTitle: Optional text to display when the state is `success`. If `nil` it will display the title.
    ///   - errorTitle: Optional text to display when the state is `error`. If `nil` it will display the title.
    ///   - state: The binding state for the button.
    ///   - action: The action to execute when tapping the button.
    public init(
        _ title: String,
        loadingTitle: String? = nil,
        successTitle: String? = nil,
        errorTitle: String? = nil,
        state: Binding<LoadingButton.State>,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.loadingTitle = loadingTitle
        self.successTitle = successTitle
        self.errorTitle = errorTitle
        self._state = state
        self.action = action
    }

    public var body: some View {
        Button {
            action()
        } label: {
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
        }
        .background(state.backgroundColor)
        .foregroundColor(ViewConstants.foregroundColor)
        .cornerRadius(ViewConstants.cornerRadius)
        .disabled(isDisabled)
    }
}

public extension LoadingButton {
    /// The state representing the source of truth for the button.
    enum State {
        /// Initial state. The only state where the button can be tapped.
        case initial
        /// Displays a progress view to the right of the text.
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

private extension LoadingButton {
    enum ViewConstants {
        static let font: Font = .title3.bold()
        static let foregroundColor: Color = .white
        static let cornerRadius: CGFloat = 8
        static let spacing: CGFloat = 8
    }

    var isDisabled: Bool {
        state != .initial
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

struct LoadingButton_Previews: PreviewProvider {
    /// Example of Loading usage.
    struct LoadingButtonPreviewer: View {
        @Binding var state: LoadingButton.State
        var action: () -> Void

        var body: some View {
            LoadingButton(
                "Button",
                loadingTitle: "Loading",
                successTitle: "Success",
                errorTitle: "Error",
                state: $state
            ) {
                action()
            }
        }
    }

    struct LoadingButtonsContainer: View {
        @State var firstState = LoadingButton.State.initial
        @State var secondState = LoadingButton.State.initial
        @State var thirdState = LoadingButton.State.initial
        @State var fourthState = LoadingButton.State.initial

        var body: some View {
            VStack {
                LoadingButtonPreviewer(state: $firstState) { firstState = .loading }
                LoadingButtonPreviewer(state: $secondState) { secondState = .success }
                HStack {
                    LoadingButtonPreviewer(state: $thirdState) { thirdState = .error }
                    LoadingButtonPreviewer(state: $fourthState) {
                        fourthState = .loading
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                fourthState = .success
                            }
                        }
                    }
                }

                LoadingButton(
                    "Reset All",
                    state: .constant(.initial)
                ) {
                    firstState = .initial
                    secondState = .initial
                    thirdState = .initial
                    fourthState = .initial
                }

                LoadingButton("Loading", state: .constant(.loading)) {}
                LoadingButton("Success", state: .constant(.success)) {}
                LoadingButton("Error", state: .constant(.error)) {}

            }.padding()
        }
    }

    static var previews: some View {
        ScrollView {
            LoadingButtonsContainer()
        }
    }
}
