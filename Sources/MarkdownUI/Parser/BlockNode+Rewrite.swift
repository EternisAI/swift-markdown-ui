import Foundation

extension Sequence where Element == BlockNode {
    func rewrite(_ r: (BlockNode) throws -> [BlockNode]) rethrows -> [BlockNode] {
        try flatMap { try $0.rewrite(r) }
    }

    func rewrite(_ r: (InlineNode) throws -> [InlineNode]) rethrows -> [BlockNode] {
        try flatMap { try $0.rewrite(r) }
    }
}

extension BlockNode {
    func rewrite(_ r: (BlockNode) throws -> [BlockNode]) rethrows -> [BlockNode] {
        switch self {
        case let .blockquote(children):
            return try r(.blockquote(children: children.rewrite(r)))
        case let .bulletedList(isTight, items):
            return try r(
                .bulletedList(
                    isTight: isTight,
                    items: items.map {
                        try RawListItem(children: $0.children.rewrite(r))
                    }
                )
            )
        case let .numberedList(isTight, start, items):
            return try r(
                .numberedList(
                    isTight: isTight,
                    start: start,
                    items: items.map {
                        try RawListItem(children: $0.children.rewrite(r))
                    }
                )
            )
        case let .taskList(isTight, items):
            return try r(
                .taskList(
                    isTight: isTight,
                    items: items.map {
                        try RawTaskListItem(isCompleted: $0.isCompleted, children: $0.children.rewrite(r))
                    }
                )
            )
        default:
            return try r(self)
        }
    }

    func rewrite(_ r: (InlineNode) throws -> [InlineNode]) rethrows -> [BlockNode] {
        switch self {
        case let .blockquote(children):
            return try [.blockquote(children: children.rewrite(r))]
        case let .bulletedList(isTight, items):
            return try [
                .bulletedList(
                    isTight: isTight,
                    items: items.map {
                        try RawListItem(children: $0.children.rewrite(r))
                    }
                ),
            ]
        case let .numberedList(isTight, start, items):
            return try [
                .numberedList(
                    isTight: isTight,
                    start: start,
                    items: items.map {
                        try RawListItem(children: $0.children.rewrite(r))
                    }
                ),
            ]
        case let .taskList(isTight, items):
            return try [
                .taskList(
                    isTight: isTight,
                    items: items.map {
                        try RawTaskListItem(isCompleted: $0.isCompleted, children: $0.children.rewrite(r))
                    }
                ),
            ]
        case let .paragraph(content):
            return try [.paragraph(content: content.rewrite(r))]
        case let .heading(level, content):
            return try [.heading(level: level, content: content.rewrite(r))]
        case let .table(columnAlignments, rows):
            return try [
                .table(
                    columnAlignments: columnAlignments,
                    rows: rows.map {
                        try RawTableRow(
                            cells: $0.cells.map {
                                try RawTableCell(content: $0.content.rewrite(r))
                            }
                        )
                    }
                ),
            ]
        default:
            return [self]
        }
    }
}
