import SwiftUI

struct CodeBlockView: View {
    @Environment(\.theme.codeBlock) private var codeBlock
    @Environment(\.codeSyntaxHighlighter) private var codeSyntaxHighlighter
    @Environment(\.highlightConfiguration) private var highlightConfiguration

    private let fenceInfo: String?
    private let content: String

    init(fenceInfo: String?, content: String) {
        self.fenceInfo = fenceInfo
        self.content = content.hasSuffix("\n") ? String(content.dropLast()) : content
    }

    var body: some View {
        codeBlock.makeBody(
            configuration: .init(
                language: fenceInfo,
                content: content,
                label: .init(label)
            )
        )
    }

    private var label: some View {
        effectiveHighlighter.highlightCode(content, language: fenceInfo)
            .textStyleFont()
            .textStyleForegroundColor()
    }

    private var effectiveHighlighter: CodeSyntaxHighlighter {
        // If there's a highlight configuration with phrases, wrap the existing highlighter
        if let phrases = highlightConfiguration.phrases, !phrases.isEmpty {
            return HighlightingCodeSyntaxHighlighter(
                baseHighlighter: codeSyntaxHighlighter,
                highlightConfiguration: highlightConfiguration
            )
        }
        // Otherwise use the base highlighter
        return codeSyntaxHighlighter
    }
}
