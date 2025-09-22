import SwiftUI

/// Configuration for text highlighting in Markdown content
public struct HighlightConfiguration {
    /// Phrases to highlight in the content (can be single words or multi-word phrases)
    /// When nil, no highlighting is performed
    public let phrases: Set<String>?

    /// Background color for highlighted text
    public let backgroundColor: Color

    /// Foreground color for highlighted text (nil means keep original color)
    public let foregroundColor: Color?

    /// Whether the search should be case sensitive
    public let caseSensitive: Bool

    /// Creates a highlight configuration
    /// - Parameters:
    ///   - phrases: Phrases to highlight (can be single words or multi-word phrases), nil for no highlighting
    ///   - backgroundColor: Background color for highlights (default: yellow)
    ///   - foregroundColor: Text color for highlights (default: nil to keep original)
    ///   - caseSensitive: Whether phrase matching is case sensitive (default: false)
    public init(
        phrases: Set<String>?,
        backgroundColor: Color = .yellow,
        foregroundColor: Color? = nil,
        caseSensitive: Bool = false
    ) {
        self.phrases = phrases
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.caseSensitive = caseSensitive
    }

    /// Default configuration with no highlighting
    public static let none = HighlightConfiguration(phrases: nil)
}

// Environment key for highlight configuration
private struct HighlightConfigurationKey: EnvironmentKey {
    static let defaultValue = HighlightConfiguration.none
}

public extension EnvironmentValues {
    /// The current highlight configuration
    var highlightConfiguration: HighlightConfiguration {
        get { self[HighlightConfigurationKey.self] }
        set { self[HighlightConfigurationKey.self] = newValue }
    }
}

public extension View {
    /// Configures text highlighting for Markdown content
    /// - Parameter configuration: The highlight configuration to apply
    /// - Returns: A view with the highlight configuration applied
    func markdownHighlight(_ configuration: HighlightConfiguration) -> some View {
        environment(\.highlightConfiguration, configuration)
    }

    /// Configures text highlighting for Markdown content
    /// - Parameters:
    ///   - phrases: Phrases to highlight (can be single words or multi-word phrases), nil for no highlighting
    ///   - backgroundColor: Background color for highlights
    ///   - foregroundColor: Text color for highlights (nil keeps original)
    ///   - caseSensitive: Whether matching is case sensitive
    /// - Returns: A view with highlighting configured
    func markdownHighlight(
        phrases: Set<String>? = nil,
        backgroundColor: Color = .yellow,
        foregroundColor: Color? = nil,
        caseSensitive: Bool = false
    ) -> some View {
        markdownHighlight(
            HighlightConfiguration(
                phrases: phrases,
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                caseSensitive: caseSensitive
            )
        )
    }
}
