import Foundation

extension Array where Element == InlineNode {
    /// Processes inline nodes to convert <mark> HTML tags into highlight nodes
    func processMarkTags() -> [InlineNode] {
        var result: [InlineNode] = []
        var i = 0

        while i < count {
            let node = self[i]

            // Check if this is an opening <mark> tag
            if case let .html(html) = node,
               let tag = HTMLTag(html),
               tag.name.lowercased() == "mark",
               !tag.isClosingTag
            {
                // Look for the corresponding closing </mark> tag
                var content: [InlineNode] = []
                var j = i + 1
                var foundClosing = false

                while j < count {
                    let nextNode = self[j]

                    if case let .html(html) = nextNode,
                       let tag = HTMLTag(html),
                       tag.name.lowercased() == "mark",
                       tag.isClosingTag
                    {
                        // Found closing tag
                        foundClosing = true
                        break
                    } else {
                        // Collect content between marks
                        content.append(nextNode)
                    }
                    j += 1
                }

                if foundClosing {
                    // Create highlight node with collected content
                    result.append(.highlight(children: content))
                    i = j + 1 // Skip past the closing tag
                } else {
                    // No closing tag found, keep original HTML
                    result.append(node)
                    i += 1
                }
            } else if case let .emphasis(children) = node {
                // Recursively process emphasis children for tags
                result.append(.emphasis(children: children.processMarkTags()))
                i += 1
            } else if case let .strong(children) = node {
                // Recursively process strong children for tags
                result.append(.strong(children: children.processMarkTags()))
                i += 1
            } else if case let .strikethrough(children) = node {
                // Recursively process strikethrough children for tags
                result.append(.strikethrough(children: children.processMarkTags()))
                i += 1
            } else {
                // Not a mark tag and not a container with potential marks, keep as-is
                result.append(node)
                i += 1
            }
        }

        return result
    }
}

extension BlockNode {
    /// Processes the block node to convert <mark> tags in inline content
    func processMarkTags() -> BlockNode {
        switch self {
        case let .paragraph(content):
            return .paragraph(content: content.processMarkTags())
        case let .heading(level, content):
            return .heading(level: level, content: content.processMarkTags())
        case let .blockquote(children):
            return .blockquote(children: children.map { $0.processMarkTags() })
        case let .bulletedList(isTight, items):
            return .bulletedList(
                isTight: isTight,
                items: items.map { RawListItem(children: $0.children.map { $0.processMarkTags() }) }
            )
        case let .numberedList(isTight, start, items):
            return .numberedList(
                isTight: isTight,
                start: start,
                items: items.map { RawListItem(children: $0.children.map { $0.processMarkTags() }) }
            )
        case let .taskList(isTight, items):
            return .taskList(
                isTight: isTight,
                items: items.map { RawTaskListItem(isCompleted: $0.isCompleted, children: $0.children.map { $0.processMarkTags() }) }
            )
        case let .table(columnAlignments, rows):
            return .table(
                columnAlignments: columnAlignments,
                rows: rows.map { RawTableRow(cells: $0.cells.map { RawTableCell(content: $0.content.processMarkTags()) }) }
            )
        default:
            // Other block types don't contain inline content that needs processing
            return self
        }
    }
}

extension Array where Element == BlockNode {
    /// Process mark tags in all blocks
    func processMarkTags() -> [BlockNode] {
        return map { $0.processMarkTags() }
    }

    /// Highlight specific words in the markdown content
    func highlightingWords(_ words: [String]) -> [BlockNode] {
        guard !words.isEmpty else { return self }

        return map { $0.highlightingWords(words) }
    }
}

extension BlockNode {
    /// Highlight specific words in the block node
    func highlightingWords(_ words: [String]) -> BlockNode {
        switch self {
        case let .paragraph(content):
            .paragraph(content: content.highlightingWords(words))
        case let .heading(level, content):
            .heading(level: level, content: content.highlightingWords(words))
        case let .blockquote(children):
            .blockquote(children: children.highlightingWords(words))
        case let .bulletedList(isTight, items):
            .bulletedList(
                isTight: isTight,
                items: items.map { RawListItem(children: $0.children.highlightingWords(words)) }
            )
        case let .numberedList(isTight, start, items):
            .numberedList(
                isTight: isTight,
                start: start,
                items: items.map { RawListItem(children: $0.children.highlightingWords(words)) }
            )
        case let .taskList(isTight, items):
            .taskList(
                isTight: isTight,
                items: items.map { RawTaskListItem(isCompleted: $0.isCompleted, children: $0.children.highlightingWords(words)) }
            )
        case let .table(columnAlignments, rows):
            .table(
                columnAlignments: columnAlignments,
                rows: rows.map { RawTableRow(cells: $0.cells.map { RawTableCell(content: $0.content.highlightingWords(words)) }) }
            )
        case .codeBlock:
            // Don't highlight inside code blocks
            self
        case .htmlBlock:
            // Don't process HTML blocks
            self
        case .thematicBreak:
            // No content to highlight
            self
        }
    }
}

extension Array where Element == InlineNode {
    /// Highlight specific words in inline nodes
    func highlightingWords(_ words: [String]) -> [InlineNode] {
        guard !words.isEmpty else { return self }

        var result: [InlineNode] = []

        for node in self {
            switch node {
            case let .text(text):
                // Split text and wrap matching words with highlight
                result.append(contentsOf: text.highlightWords(words))
            case .code:
                // Don't highlight inside inline code
                result.append(node)
            case let .emphasis(children):
                result.append(.emphasis(children: children.highlightingWords(words)))
            case let .strong(children):
                result.append(.strong(children: children.highlightingWords(words)))
            case let .strikethrough(children):
                result.append(.strikethrough(children: children.highlightingWords(words)))
            case let .highlight(children):
                // Process children but keep existing highlight
                result.append(.highlight(children: children.highlightingWords(words)))
            case let .link(destination, children):
                result.append(.link(destination: destination, children: children.highlightingWords(words)))
            case let .image(source, children):
                result.append(.image(source: source, children: children.highlightingWords(words)))
            case .softBreak:
                result.append(node)
            case .lineBreak:
                result.append(node)
            case .html:
                // Keep HTML as-is
                result.append(node)
            }
        }

        return result
    }
}

extension String {
    /// Split text and create highlight nodes for matching words
    func highlightWords(_ words: [String]) -> [InlineNode] {
        guard !words.isEmpty else { return [.text(self)] }

        // Create pattern for word boundaries
        let sortedWords = words.sorted { $0.count > $1.count }
        let pattern = sortedWords
            .map { "\\b" + NSRegularExpression.escapedPattern(for: $0) + "\\b" }
            .joined(separator: "|")

        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            return [.text(self)]
        }

        var result: [InlineNode] = []
        var lastEnd = 0
        let nsString = self as NSString

        let matches = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))

        for match in matches {
            // Add text before match
            if match.range.location > lastEnd {
                let beforeRange = NSRange(location: lastEnd, length: match.range.location - lastEnd)
                let beforeText = nsString.substring(with: beforeRange)
                result.append(.text(beforeText))
            }

            // Add highlighted match
            let matchedText = nsString.substring(with: match.range)
            result.append(.highlight(children: [.text(matchedText)]))

            lastEnd = match.range.location + match.range.length
        }

        // Add remaining text
        if lastEnd < nsString.length {
            let remainingText = nsString.substring(from: lastEnd)
            result.append(.text(remainingText))
        }

        return result.isEmpty ? [.text(self)] : result
    }
}
