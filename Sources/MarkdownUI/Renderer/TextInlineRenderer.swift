import SwiftUI

extension Sequence where Element == InlineNode {
    func renderText(
        baseURL: URL?,
        textStyles: InlineTextStyles,
        images: [String: Image],
        softBreakMode: SoftBreak.Mode,
        attributes: AttributeContainer,
        highlightConfiguration: HighlightConfiguration
    ) -> Text {
        var renderer = TextInlineRenderer(
            baseURL: baseURL,
            textStyles: textStyles,
            images: images,
            softBreakMode: softBreakMode,
            attributes: attributes,
            highlightConfiguration: highlightConfiguration
        )
        renderer.render(self)
        return renderer.result
    }
}

private struct TextInlineRenderer {
    var result = Text("")

    private let baseURL: URL?
    private let textStyles: InlineTextStyles
    private let images: [String: Image]
    private let softBreakMode: SoftBreak.Mode
    private let attributes: AttributeContainer
    private let highlightConfiguration: HighlightConfiguration
    private var shouldSkipNextWhitespace = false

    init(
        baseURL: URL?,
        textStyles: InlineTextStyles,
        images: [String: Image],
        softBreakMode: SoftBreak.Mode,
        attributes: AttributeContainer,
        highlightConfiguration: HighlightConfiguration
    ) {
        self.baseURL = baseURL
        self.textStyles = textStyles
        self.images = images
        self.softBreakMode = softBreakMode
        self.attributes = attributes
        self.highlightConfiguration = highlightConfiguration
    }

    mutating func render<S: Sequence>(_ inlines: S) where S.Element == InlineNode {
        for inline in inlines {
            render(inline)
        }
    }

    private mutating func render(_ inline: InlineNode) {
        switch inline {
        case let .text(content):
            renderText(content)
        case .softBreak:
            renderSoftBreak()
        case let .html(content):
            renderHTML(content)
        case let .image(source, _):
            renderImage(source)
        default:
            defaultRender(inline)
        }
    }

    private mutating func renderText(_ text: String) {
        var text = text

        if shouldSkipNextWhitespace {
            shouldSkipNextWhitespace = false
            text = text.replacingOccurrences(of: "^\\s+", with: "", options: .regularExpression)
        }

        defaultRender(.text(text))
    }

    private mutating func renderSoftBreak() {
        switch softBreakMode {
        case .space where shouldSkipNextWhitespace:
            shouldSkipNextWhitespace = false
        case .space:
            defaultRender(.softBreak)
        case .lineBreak:
            shouldSkipNextWhitespace = true
            defaultRender(.lineBreak)
        }
    }

    private mutating func renderHTML(_ html: String) {
        let tag = HTMLTag(html)

        switch tag?.name.lowercased() {
        case "br":
            defaultRender(.lineBreak)
            shouldSkipNextWhitespace = true
        default:
            defaultRender(.html(html))
        }
    }

    private mutating func renderImage(_ source: String) {
        if let image = images[source] {
            result = result + Text(image)
        }
    }

    private mutating func defaultRender(_ inline: InlineNode) {
        var attributedString = inline.renderAttributedString(
            baseURL: baseURL,
            textStyles: textStyles,
            softBreakMode: softBreakMode,
            attributes: attributes
        )

        // Apply highlighting if configured
        if let phrases = highlightConfiguration.phrases, !phrases.isEmpty {
            attributedString = applyHighlighting(to: attributedString, phrases: phrases)
        }

        result = result + Text(attributedString)
    }

    private func applyHighlighting(to attributedString: AttributedString, phrases: Set<String>) -> AttributedString {
        var result = attributedString
        let searchString = String(attributedString.characters)

        for phrase in phrases {
            let searchPhrase = highlightConfiguration.caseSensitive ? phrase : phrase.lowercased()
            let searchIn = highlightConfiguration.caseSensitive ? searchString : searchString.lowercased()

            // Find all occurrences of the phrase (no word boundary checking for phrases)
            var searchRange = searchIn.startIndex ..< searchIn.endIndex
            while let range = searchIn.range(of: searchPhrase, options: [], range: searchRange) {
                // For single words, check word boundaries; for phrases, highlight as-is
                let shouldHighlight: Bool
                if !phrase.contains(" ") {
                    // Single word - check boundaries
                    let isWordStart = range.lowerBound == searchIn.startIndex ||
                        !searchIn[searchIn.index(before: range.lowerBound)].isLetter
                    let isWordEnd = range.upperBound == searchIn.endIndex ||
                        !searchIn[range.upperBound].isLetter
                    shouldHighlight = isWordStart && isWordEnd
                } else {
                    // Phrase - highlight without boundary checking
                    shouldHighlight = true
                }

                if shouldHighlight {
                    // Convert String.Index to AttributedString.Index
                    let startOffset = searchIn.distance(from: searchIn.startIndex, to: range.lowerBound)
                    let endOffset = searchIn.distance(from: searchIn.startIndex, to: range.upperBound)

                    let attrStringStart = result.index(result.startIndex, offsetByCharacters: startOffset)
                    let attrStringEnd = result.index(result.startIndex, offsetByCharacters: endOffset)
                    let attrRange = attrStringStart ..< attrStringEnd

                    // Apply highlight colors
                    result[attrRange].backgroundColor = highlightConfiguration.backgroundColor
                    if let foregroundColor = highlightConfiguration.foregroundColor {
                        result[attrRange].foregroundColor = foregroundColor
                    }
                }

                // Move search range forward
                searchRange = range.upperBound ..< searchIn.endIndex
            }
        }

        return result
    }
}
