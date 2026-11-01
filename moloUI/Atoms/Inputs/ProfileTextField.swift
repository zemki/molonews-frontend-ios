//
//  DefaultTextField.swift
//  Atoms
//

import Assets
import Dimensions
import SwiftUI

public struct ProfileTextField: View {
    @Binding var content: String
    @Binding var error: Bool

    private let label: LocalizedStringKey
    private let textContentType: UITextContentType?
    private let reserveSpace: Bool

    public init(
        label: String,
        textContentType: UITextContentType?,
        reserveSpace: Bool = false,
        contentBinding: Binding<String>,
        errorBinding: Binding<Bool>
    ) {
        self.label = LocalizedStringKey(label)
        self.textContentType = textContentType
        self.reserveSpace = reserveSpace
        _content = contentBinding
        _error = errorBinding
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(.moloContentDefault)
                .lineLimit(4)
                .foregroundStyle(error ? Colors.Text.error.swiftUIColor : Colors.Text.default.swiftUIColor)
                .padding(.bottom, .verticalDefault)

            if textContentType == .password || textContentType == .newPassword {
                SecureField("", text: $content)
                    .textFieldStyle(MoloProfileTextFieldStyle(error: error))
                    .textContentType(textContentType)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .font(.moloTitleSmall)
                    .onChange(of: content) { _, _ in
                        error = false
                    }
            } else if textContentType == nil {
                TextField("", text: $content, axis: .vertical)
                    .lineLimit(4, reservesSpace: reserveSpace)
                    .textFieldStyle(MoloProfileTextFieldStyle(error: error, fixedHeight: false))
                    .autocorrectionDisabled(false)
                    .textInputAutocapitalization(.sentences)
                    .keyboardType(.default)
                    .font(.moloTitleSmall)
                    .onChange(of: content) { _, _ in
                        error = false
                    }
            } else {
                TextField("", text: $content)
                    .textFieldStyle(MoloProfileTextFieldStyle(error: error))
                    .textContentType(textContentType)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .keyboardType(textContentType == .username ? .emailAddress : .default)
                    .font(.moloTitleSmall)
                    .onChange(of: content) { _, _ in
                        error = false
                    }
            }
        }
    }
}

#Preview("dark") {
    ZStack {
        Colors.Background.default.swiftUIColor
        
        VStack {
            ProfileTextField(label: "E-Mail", textContentType: .username, contentBinding: .constant("dev@example.com"), errorBinding: .constant(true))
                .padding(.horizontal, .horizontalDefault)
            ProfileTextField(label: "Passwort", textContentType: .password, contentBinding: .constant("geheim"), errorBinding: .constant(false))
                .padding(.horizontal, .horizontalDefault)
            ProfileTextField(label: "Vorname", textContentType: .username, contentBinding: .constant("Max"), errorBinding: .constant(false))
                .padding(.horizontal, .horizontalDefault)
        }
    }
    .preferredColorScheme(.dark)
}

#Preview("light") {
    ZStack {
        Colors.Background.default.swiftUIColor
        
        VStack {
            ProfileTextField(label: "E-Mail", textContentType: .username, contentBinding: .constant("dev@example.com"), errorBinding: .constant(true))
                .padding(.horizontal, .horizontalDefault)
            ProfileTextField(label: "Passwort", textContentType: .password, contentBinding: .constant("geheim"), errorBinding: .constant(false))
                .padding(.horizontal, .horizontalDefault)
            ProfileTextField(label: "Vorname", textContentType: .username, contentBinding: .constant("Max"), errorBinding: .constant(false))
                .padding(.horizontal, .horizontalDefault)
        }
    }
    .preferredColorScheme(.light)
}
