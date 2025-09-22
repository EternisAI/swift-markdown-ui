import Foundation
import XCTest

@testable import MarkdownUI

final class MarkdownHighlightTests: XCTestCase {
    func testMarkTag() {
        // Test that mark tags are converted to highlight nodes
        let markdown = "This is <mark>highlighted</mark> text"
        let blocks = [BlockNode](markdown: markdown)

        XCTAssertEqual(blocks.count, 1, "Should have one block")

        if case let .paragraph(content) = blocks.first {
            // Should have: text("This is "), highlight([text("highlighted")]), text(" text")
            XCTAssertEqual(content.count, 3, "Should have 3 inline nodes")

            // Check first node is text
            if case let .text(text) = content[0] {
                XCTAssertEqual(text, "This is ")
            } else {
                XCTFail("First node should be text")
            }

            // Check second node is highlight
            if case let .highlight(children) = content[1] {
                XCTAssertEqual(children.count, 1)
                if case let .text(text) = children[0] {
                    XCTAssertEqual(text, "highlighted")
                } else {
                    XCTFail("Highlight should contain text")
                }
            } else {
                XCTFail("Second node should be highlight, got: \(content[1])")
            }

            // Check third node is text
            if case let .text(text) = content[2] {
                XCTAssertEqual(text, " text")
            } else {
                XCTFail("Third node should be text")
            }
        } else {
            XCTFail("Expected paragraph block")
        }
    }

    func testHighlightDSL() {
        // Test the DSL for creating highlighted content
        let highlight = Highlight("This is highlighted")
        let inlineContent = highlight._inlineContent

        XCTAssertEqual(inlineContent.inlines.count, 1)
        if case let .highlight(children) = inlineContent.inlines.first {
            XCTAssertEqual(children.count, 1)
            if case let .text(text) = children.first {
                XCTAssertEqual(text, "This is highlighted")
            } else {
                XCTFail("Expected text child in highlight")
            }
        } else {
            XCTFail("Expected highlight inline")
        }
    }

    func testHTMLTagParsing() {
        // Test basic HTML tag parsing
        let tag1 = HTMLTag("<mark>")
        XCTAssertNotNil(tag1)
        XCTAssertEqual(tag1?.name, "mark")
        XCTAssertFalse(tag1?.isClosingTag ?? true)

        let tag2 = HTMLTag("</mark>")
        XCTAssertNotNil(tag2)
        XCTAssertEqual(tag2?.name, "mark")
        XCTAssertTrue(tag2?.isClosingTag ?? false)

        let tag3 = HTMLTag("<br />")
        XCTAssertNotNil(tag3)
        XCTAssertEqual(tag3?.name, "br")
        XCTAssertFalse(tag3?.isClosingTag ?? true)
    }

    func testNestedHighlight() {
        // Test highlight with other inline styles
        let markdown = "This is <mark>**bold and highlighted**</mark> text"
        let blocks = [BlockNode](markdown: markdown)

        XCTAssertFalse(blocks.isEmpty)
        if case let .paragraph(content) = blocks.first {
            // The content should contain a mix of text and highlight nodes
            XCTAssertFalse(content.isEmpty)
        } else {
            XCTFail("Expected paragraph block")
        }
    }
}
