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
            } else {
                // Not a mark tag, keep as-is
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
}
