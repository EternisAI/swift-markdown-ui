# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MarkdownUI is a SwiftUI library for displaying and customizing Markdown text. It's compatible with the GitHub Flavored Markdown Spec and provides comprehensive theming capabilities.

## Development Commands

### Testing
```bash
# Run all tests across all platforms
make test

# Run tests for specific platforms
make test-macos        # macOS
make test-ios          # iOS Simulator
make test-tvos         # tvOS Simulator
make test-watchos      # watchOS Simulator

# Run tests using Swift Package Manager
swift test

# Run a specific test
swift test --filter <TestName>
```

### Code Formatting
```bash
# Format all Swift files in the project
make format
```

### Building
```bash
# Build the package
swift build

# Build for a specific platform
xcodebuild -scheme MarkdownUI -destination platform="macOS"
```

## Architecture Overview

### Core Components

**Parser Layer** (`Sources/MarkdownUI/Parser/`)
- `MarkdownParser`: Main parser using cmark-gfm for converting Markdown strings to AST
- `BlockNode` and `InlineNode`: AST node representations
- Supports GitHub Flavored Markdown extensions (tables, task lists, strikethrough)

**Theme System** (`Sources/MarkdownUI/Theme/`)
- `Theme`: Central theming struct that defines text and block styles
- Built-in themes: `basic`, `gitHub`, `docC`
- Extensible through custom text styles (via `TextStyle` protocol) and block styles (via `BlockStyle` protocol)
- Styles cascade through view hierarchy via environment

**Rendering Pipeline** (`Sources/MarkdownUI/Renderer/`)
- `TextInlineRenderer`: Converts inline nodes to SwiftUI Text views
- `AttributedStringInlineRenderer`: Converts inline nodes to AttributedString
- Handles inline styles, links, and code spans

**View Layer** (`Sources/MarkdownUI/Views/`)
- `Markdown`: Main view that displays Markdown content
- `MarkdownContent`: Pre-parsed content for performance optimization
- Supports both string-based and DSL-based content creation

**DSL** (`Sources/MarkdownUI/DSL/`)
- Domain-specific language for building Markdown content programmatically
- Components: `Heading`, `Paragraph`, `BlockQuote`, `CodeBlock`, `Table`, etc.
- Inline elements: `Strong`, `Emphasis`, `InlineLink`, `InlineCode`

### Key Design Patterns

1. **Environment-based Theming**: Themes propagate through SwiftUI environment, allowing local overrides
2. **Builder Pattern**: Content builders (`MarkdownContentBuilder`, `InlineContentBuilder`) for DSL
3. **Protocol-oriented Styling**: `TextStyle` and `BlockStyle` protocols for extensible styling
4. **Lazy Rendering**: Content is parsed once and cached in `MarkdownContent`

## Platform Requirements

- macOS 12.0+
- iOS 15.0+
- tvOS 15.0+
- watchOS 8.0+
- Swift 5.6+

Tables and multi-image paragraphs require macOS 13.0+, iOS 16.0+, tvOS 16.0+, watchOS 9.0+

## Dependencies

- `swift-cmark`: CommonMark parsing library
- `NetworkImage`: Async image loading
- `swift-snapshot-testing`: Testing framework (dev dependency)