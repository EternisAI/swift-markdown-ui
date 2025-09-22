import Foundation

extension InlineNode {
    func renderAttributedString(
        baseURL: URL?,
        textStyles: InlineTextStyles,
        softBreakMode: SoftBreak.Mode,
        attributes: AttributeContainer,
        highlightConfiguration: HighlightConfiguration = .none
    ) -> AttributedString {
        var renderer = AttributedStringInlineRenderer(
            baseURL: baseURL,
            textStyles: textStyles,
            softBreakMode: softBreakMode,
            attributes: attributes,
            highlightConfiguration: highlightConfiguration
        )
        renderer.render(self)

        // Apply highlighting after rendering
        if let phrases = highlightConfiguration.phrases, !phrases.isEmpty {
            renderer.applyHighlighting(phrases: phrases)
        }

        return renderer.result.resolvingFonts()
    }
}

private struct AttributedStringInlineRenderer {
    var result = AttributedString()

    private let baseURL: URL?
    private let textStyles: InlineTextStyles
    private let softBreakMode: SoftBreak.Mode
    private let highlightConfiguration: HighlightConfiguration
    private var attributes: AttributeContainer
    private var shouldSkipNextWhitespace = false

    init(
        baseURL: URL?,
        textStyles: InlineTextStyles,
        softBreakMode: SoftBreak.Mode,
        attributes: AttributeContainer,
        highlightConfiguration: HighlightConfiguration
    ) {
        self.baseURL = baseURL
        self.textStyles = textStyles
        self.softBreakMode = softBreakMode
        self.attributes = attributes
        self.highlightConfiguration = highlightConfiguration
    }

    mutating func render(_ inline: InlineNode) {
        switch inline {
        case let .text(content):
            renderText(content)
        case .softBreak:
            renderSoftBreak()
        case .lineBreak:
            renderLineBreak()
        case let .code(content):
            renderCode(content)
        case let .html(content):
            renderHTML(content)
        case let .emphasis(children):
            renderEmphasis(children: children)
        case let .strong(children):
            renderStrong(children: children)
        case let .strikethrough(children):
            renderStrikethrough(children: children)
        case let .link(destination, children):
            renderLink(destination: destination, children: children)
        case let .image(source, children):
            renderImage(source: source, children: children)
        }
    }

    private mutating func renderText(_ text: String) {
        var text = text

        if shouldSkipNextWhitespace {
            shouldSkipNextWhitespace = false
            text = text.replacingOccurrences(of: "^\\s+", with: "", options: .regularExpression)
        }

        result += .init(text, attributes: attributes)
    }

    private mutating func renderSoftBreak() {
        switch softBreakMode {
        case .space where shouldSkipNextWhitespace:
            shouldSkipNextWhitespace = false
        case .space:
            result += .init(" ", attributes: attributes)
        case .lineBreak:
            renderLineBreak()
        }
    }

    private mutating func renderLineBreak() {
        result += .init("\n", attributes: attributes)
    }

    private mutating func renderCode(_ code: String) {
        result += .init(code, attributes: textStyles.code.mergingAttributes(attributes))
    }

    private mutating func renderHTML(_ html: String) {
        let tag = HTMLTag(html)

        switch tag?.name.lowercased() {
        case "br":
            renderLineBreak()
            shouldSkipNextWhitespace = true
        default:
            renderText(html)
        }
    }

    private mutating func renderEmphasis(children: [InlineNode]) {
        let savedAttributes = attributes
        attributes = textStyles.emphasis.mergingAttributes(attributes)

        for child in children {
            render(child)
        }

        attributes = savedAttributes
    }

    private mutating func renderStrong(children: [InlineNode]) {
        let savedAttributes = attributes
        attributes = textStyles.strong.mergingAttributes(attributes)

        for child in children {
            render(child)
        }

        attributes = savedAttributes
    }

    private mutating func renderStrikethrough(children: [InlineNode]) {
        let savedAttributes = attributes
        attributes = textStyles.strikethrough.mergingAttributes(attributes)

        for child in children {
            render(child)
        }

        attributes = savedAttributes
    }

    private mutating func renderLink(destination: String, children: [InlineNode]) {
        let savedAttributes = attributes
        attributes = textStyles.link.mergingAttributes(attributes)
        attributes.link = URL(string: destination, relativeTo: baseURL)

        for child in children {
            render(child)
        }

        attributes = savedAttributes
    }

    private mutating func renderImage(source _: String, children _: [InlineNode]) {
        // AttributedString does not support images
    }

    fileprivate mutating func applyHighlighting(phrases: Set<String>) {
        let searchString = String(result.characters)

        for phrase in phrases {
            let searchPhrase = highlightConfiguration.caseSensitive ? phrase : phrase.lowercased()
            let searchIn = highlightConfiguration.caseSensitive ? searchString : searchString.lowercased()

            // Find all occurrences of the phrase
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
    }
}

private extension TextStyle {
    func mergingAttributes(_ attributes: AttributeContainer) -> AttributeContainer {
        var newAttributes = attributes
        _collectAttributes(in: &newAttributes)
        return newAttributes
    }
}
