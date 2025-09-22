import Foundation

/// A highlighted text in a Markdown content block.
public struct Highlight: InlineContentProtocol {
    public var _inlineContent: InlineContent {
        .init(inlines: [.highlight(children: content.inlines)])
    }

    private let content: InlineContent

    init(content: InlineContent) {
        self.content = content
    }

    /// Creates a highlight inline by applying the highlight style to a string.
    /// - Parameter text: The text to highlight.
    public init(_ text: String) {
        self.init(content: .init(inlines: [.text(text)]))
    }

    /// Creates a highlight inline by applying the highlight style to other inline content.
    /// - Parameter content: An inline content builder that returns the inlines to highlight.
    public init(@InlineContentBuilder content: () -> InlineContent) {
        self.init(content: content())
    }
}
