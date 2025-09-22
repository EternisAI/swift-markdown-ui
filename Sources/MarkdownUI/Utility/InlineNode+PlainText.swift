import Foundation

extension Sequence where Element == InlineNode {
    func renderPlainText() -> String {
        collect { inline in
            switch inline {
            case let .text(content):
                return [content]
            case .softBreak:
                return [" "]
            case .lineBreak:
                return ["\n"]
            case let .code(content):
                return [content]
            case let .html(content):
                return [content]
            default:
                return []
            }
        }
        .joined()
    }
}
