//
//  PostingSectionTitle.swift
//  Molecules
//

import Assets
import Atoms
import Dimensions
import SwiftUI

public struct PostingSectionTitle: View {
    private var title: String
    private var content: String
    
    public init(
        title: String,
        content: String,
    ) {
        self.title = title
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: .verticalLarge) {
            HStack(spacing: .horizontalMedium) {
                Assets.Icons.Navigation.topics.swiftUIImage
                    .renderingMode(.template)
                    .foregroundStyle(Colors.Icons.button.swiftUIColor)
                
                Text(title)
                    .font(.moloTitleDefault)
                
                Spacer()
            }
            
            Text(content)
                .font(.moloContentDefault)
        }
    }
}

#Preview("light") {
    ZStack {
        Colors.Background.default.swiftUIColor
        
        PostingSectionTitle(
            title: "Themen",
            content: "Pick die Themen, die zu deinem Post passen. Unsere molo-KI hat schon mal ein paar Vorschläge gemacht."
        )
    }
    .colorScheme(.light)
}

#Preview("dark") {
    ZStack {
        Colors.Background.default.swiftUIColor
        
        PostingSectionTitle(
            title: "Themen",
            content: "Pick die Themen, die zu deinem Post passen. Unsere molo-KI hat schon mal ein paar Vorschläge gemacht."
        )
    }
    .colorScheme(.dark)
}
