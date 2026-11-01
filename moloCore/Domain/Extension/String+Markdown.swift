//
//  String+HTML.swift
//  Domain
//

import Foundation
import UIKit

public extension String {
    func toMarkdown() -> String? {
        return replacingOccurrences(of: "<i>", with: "*", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "</i>", with: "*", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "<b>", with: "**", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "</b>", with: "**", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "<strong>", with: "**", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "</strong>", with: "**", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "<s>", with: "~~", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "</s>", with: "~~", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "<br>", with: "\n", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "<br/>", with: "\n", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "<br />", with: "\n", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "<p>", with: "", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "</p>", with: "\n", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "<code>", with: "`", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "</code>", with: "`", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "<tt>", with: "`", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "</tt>", with: "`", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            .replacing(/<a\s+href=.(.*?).>(.*)<\/a>/.ignoresCase()) { match in
                "[\(match.2)](\(match.1))"
            }
    }

    func fromHtml() -> String? {
        let htmlString = NSString(string: self)
        if let htmldata = htmlString.data(using: NSUTF8StringEncoding),
           let attributedString = try? NSAttributedString(
               data: htmldata,
               options: [
                   .documentType: NSAttributedString.DocumentType.html,
                   .characterEncoding: String.Encoding.utf8.rawValue
               ],
               documentAttributes: nil
           ) {
            return attributedString.string
        }
        return self
    }
}
