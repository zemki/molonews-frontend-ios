//
//  CardTextContent.swift
//  Molecules
//

import Atoms
import SwiftUI

public struct CardTextContent: View {
    private let title: String
    private let titleLineLimit: Int
    private let content: String

    public init(title: String, titleLineLimit: Int, content: String) {
        self.title = title
        self.titleLineLimit = titleLineLimit
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CardTitleText(title, lineLimit: titleLineLimit)
                .padding(.bottom, .verticalDefault)

            CardContentText(content)

            Spacer()

            HStack(spacing: 0) {
                Spacer()
            }
        }
    }
}

#Preview {
    CardTextContent(
        title: "Der Wetterdienst warnt vor glatten Straßen in Norddeutschland",
        titleLineLimit: 2,
        content: "Der Wetterdienst warnt vor Glatteis in Norddeutschland. Im Laufe des Tages können auch der Osten, die Mitte des Landes sowie Süddeutschland betroffen sein."
    )
}
