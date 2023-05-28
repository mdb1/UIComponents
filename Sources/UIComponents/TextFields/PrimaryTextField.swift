//
//  PrimaryTextField.swift
//  
//
//  Created by Manu on 28/05/2023.
//

import Foundation
import SwiftUI

public struct PrimaryTextField: View {
    private let type: `Type`
    private let submitLabel: SubmitLabel
    private let textInputAutocapitalization: TextInputAutocapitalization
    private let disableAutocorrection: Bool
    private let keyboardType: UIKeyboardType
    private let title: String
    @Binding private var text: String
    @Binding private var error: String?
    @FocusState private var isFocused: Bool

    public init(
        type: `Type` = .default,
        _ title: String,
        text: Binding<String>,
        error: Binding<String?> = .constant(nil),
        submitLabel: SubmitLabel = .next,
        textInputAutocapitalization: TextInputAutocapitalization = .words,
        disableAutocorrection: Bool = true,
        keyboardType: UIKeyboardType = .default
    ) {
        self.type = type
        self.title = title
        self._text = text
        self._error = error
        self.submitLabel = submitLabel
        self.textInputAutocapitalization = textInputAutocapitalization
        self.disableAutocorrection = disableAutocorrection
        self.keyboardType = keyboardType
    }

    public var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .trailing) {
                textFieldView
                    .font(.caption)
                    .tint(tintColor)
                    .disableAutocorrection(disableAutocorrection)
                    .keyboardType(keyboardType)
                    .padding()
                    .submitLabel(submitLabel)
                    .textInputAutocapitalization(textInputAutocapitalization)
                    .background(backgroundColor)
                    .cornerRadius(ViewConstants.cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: ViewConstants.cornerRadius)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
                    .focused($isFocused)
                    .onChange(of: text) { _ in
                        // Clear errors when the text changes
                        if error != nil {
                            error = nil
                        }
                    }

                closeButtonView
            }

            errorTextView
        }
        .animation(.default, value: error)
        .animation(.default, value: isFocused)
    }
}

public extension PrimaryTextField {
    enum `Type` {
        case `default`
        case secure
    }

    @ViewBuilder
    var textFieldView: some View {
        if type == .default {
            TextField(title, text: $text)
        } else {
            SecureField(title, text: $text)
        }
    }

    var backgroundColor: Color {
        isFocused ? ViewConstants.focusedBackgroundColor : ViewConstants.defaultBackgroundColor
    }

    var borderColor: Color {
        if error != nil {
            return ViewConstants.errorColor
        }

        return isFocused ? .clear : .gray
    }

    var closeButtonBackgroundColor: Color {
        if error != nil {
            return ViewConstants.errorColor
        }

        return .gray
    }

    var tintColor: Color {
        .init(uiColor: .label)
    }

    var borderWidth: CGFloat {
        if error != nil {
            return 1
        }

        return isFocused ? 0 : 1
    }
}

private extension PrimaryTextField {
    enum ViewConstants {
        static let cornerRadius: CGFloat = 4
        static let errorColor: Color = .red
        static let defaultBackgroundColor: Color = .init(uiColor: .systemBackground)
        static let focusedBackgroundColor: Color = .init(uiColor: .systemGray6)
    }

    @ViewBuilder
    var closeButtonView: some View {
        if isFocused, !text.isEmpty {
            Button {
                text = ""
            } label: {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .foregroundColor(closeButtonBackgroundColor)
                    .frame(width: 16, height: 16)
            }.padding(.horizontal)
        }
    }

    @ViewBuilder
    var errorTextView: some View {
        if let error {
            HStack {
                Text(error)
                    .font(.caption2)
                    .foregroundColor(ViewConstants.errorColor)
                Spacer()
            }
        }
    }
}

struct PrimaryTextField_Previews: PreviewProvider {
    struct PrimaryTextFieldContentView: View {
        @State var text1: String = ""
        @State var text2: String = ""
        @State var error1: String?
        @State var error2: String?

        var body: some View {
            VStack {
                PrimaryTextField("Email", text: $text1, error: $error1)
                PrimaryTextField(type: .secure, "Password", text: $text2, error: $error2)

                Button("Clear errors") {
                    error1 = nil
                    error2 = nil
                }
                Button("Set errors") {
                    error1 = "Error"
                    error2 = "Another error"
                }

                Spacer()
            }.padding()
        }
    }

    static var previews: some View {
        PrimaryTextFieldContentView()
    }
}
