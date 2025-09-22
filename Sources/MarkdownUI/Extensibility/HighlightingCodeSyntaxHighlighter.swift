import SwiftUI

/// A code syntax highlighter wrapper that adds phrase highlighting support to code blocks
public struct HighlightingCodeSyntaxHighlighter: CodeSyntaxHighlighter {
    private let baseHighlighter: CodeSyntaxHighlighter
    private let highlightConfiguration: HighlightConfiguration

    /// Creates a highlighting code syntax highlighter that wraps another highlighter
    /// - Parameters:
    ///   - baseHighlighter: The base syntax highlighter to wrap
    ///   - highlightConfiguration: The highlight configuration to apply
    public init(
        baseHighlighter: CodeSyntaxHighlighter = PlainTextCodeSyntaxHighlighter(),
        highlightConfiguration: HighlightConfiguration
    ) {
        self.baseHighlighter = baseHighlighter
        self.highlightConfiguration = highlightConfiguration
    }

    public func highlightCode(_ code: String, language: String?) -> Text {
        // If no phrases to highlight, return the base text
        guard let phrases = highlightConfiguration.phrases, !phrases.isEmpty else {
            return baseHighlighter.highlightCode(code, language: language)
        }

        // For plain text highlighter, apply our own highlighting
        if baseHighlighter is PlainTextCodeSyntaxHighlighter {
            return applyHighlighting(to: code)
        }

        // For other highlighters (like Splash), we can't easily combine the highlighting
        // So we'll just return the base syntax highlighting for now
        // TODO: Future enhancement could parse the attributed string from the base highlighter
        // and add our highlighting on top
        return baseHighlighter.highlightCode(code, language: language)
    }

    private func applyHighlighting(to code: String) -> Text {
        // Create an attributed string for the entire code
        var attributedString = AttributedString(code)

        // Get phrases from configuration
        guard let phrases = highlightConfiguration.phrases, !phrases.isEmpty else {
            return Text(attributedString)
        }

        // Find and highlight all occurrences
        for word in phrases {
            let searchWord = highlightConfiguration.caseSensitive ? word : word.lowercased()
            let searchCode = highlightConfiguration.caseSensitive ? code : code.lowercased()

            var searchStartIndex = searchCode.startIndex
            while let range = searchCode.range(of: searchWord, range: searchStartIndex ..< searchCode.endIndex) {
                // Map the range back to the original code indices
                let originalRange = code.index(code.startIndex, offsetBy: code.distance(from: searchCode.startIndex, to: range.lowerBound)) ..< code.index(code.startIndex, offsetBy: code.distance(from: searchCode.startIndex, to: range.upperBound))

                // Convert String.Index range to AttributedString.Index range
                if let attrRange = Range(NSRange(originalRange, in: code), in: attributedString) {
                    #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
                        attributedString[attrRange].backgroundColor = UIColor(highlightConfiguration.backgroundColor)
                        if let foregroundColor = highlightConfiguration.foregroundColor {
                            attributedString[attrRange].foregroundColor = UIColor(foregroundColor)
                        }
                    #elseif os(macOS)
                        attributedString[attrRange].backgroundColor = NSColor(highlightConfiguration.backgroundColor)
                        if let foregroundColor = highlightConfiguration.foregroundColor {
                            attributedString[attrRange].foregroundColor = NSColor(foregroundColor)
                        }
                    #endif
                }

                searchStartIndex = range.upperBound
            }
        }

        return Text(attributedString)
    }
}

public extension CodeSyntaxHighlighter where Self == HighlightingCodeSyntaxHighlighter {
    /// A code syntax highlighter that adds phrase highlighting to plain text
    static func highlighting(_ configuration: HighlightConfiguration) -> Self {
        HighlightingCodeSyntaxHighlighter(highlightConfiguration: configuration)
    }

    /// Wraps an existing syntax highlighter with phrase highlighting
    static func highlighting(
        _ baseHighlighter: CodeSyntaxHighlighter,
        configuration: HighlightConfiguration
    ) -> Self {
        HighlightingCodeSyntaxHighlighter(
            baseHighlighter: baseHighlighter,
            highlightConfiguration: configuration
        )
    }
}
