import Foundation

struct HTMLTag {
    let name: String
    let isClosingTag: Bool
}

extension HTMLTag {
    private enum Constants {
        static let tagExpression = try! NSRegularExpression(pattern: "<(\\/?)([a-zA-Z0-9]+)[^>]*>")
    }

    init?(_ description: String) {
        guard
            let match = Constants.tagExpression.firstMatch(
                in: description,
                range: NSRange(description.startIndex..., in: description)
            ),
            let nameRange = Range(match.range(at: 2), in: description)
        else {
            return nil
        }

        name = String(description[nameRange])

        // Check if it's a closing tag
        if let closingRange = Range(match.range(at: 1), in: description) {
            isClosingTag = !description[closingRange].isEmpty
        } else {
            isClosingTag = false
        }
    }
}
