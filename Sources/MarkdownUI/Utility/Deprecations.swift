import SwiftUI

// MARK: - Deprecated after 2.1.0:

public extension DefaultImageProvider {
    @available(*, deprecated, message: "Use the 'default' static property")
    init(urlSession _: URLSession = .shared) {
        self.init()
    }
}

public extension DefaultInlineImageProvider {
    @available(*, deprecated, message: "Use the 'default' static property")
    init(urlSession _: URLSession = .shared) {
        self.init()
    }
}

// MARK: - Deprecated after 2.0.2:

public extension BlockStyle where Configuration == BlockConfiguration {
    @available(
        *,
        deprecated,
        message: "Use the initializer that takes a closure receiving a 'Configuration' value."
    )
    init<Body: View>(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
    ) {
        self.init { configuration in
            body(configuration.label)
        }
    }

    @available(
        *,
        deprecated,
        message: "Use the initializer that takes a closure receiving a 'Configuration' value."
    )
    init() {
        self.init { $0 }
    }
}

public extension View {
    @available(
        *,
        deprecated,
        message: """
        Use the version of this function that takes a closure receiving a generic 'Configuration'
        value.
        """
    )
    func markdownBlockStyle<Body: View>(
        _ keyPath: WritableKeyPath<Theme, BlockStyle<BlockConfiguration>>,
        @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
    ) -> some View {
        environment((\EnvironmentValues.theme).appending(path: keyPath), .init(body: body))
    }

    @available(
        *,
        deprecated,
        message: """
        Use the version of this function that takes a closure receiving a generic 'Configuration'
        value.
        """
    )
    func markdownBlockStyle<Body: View>(
        _ keyPath: WritableKeyPath<Theme, BlockStyle<CodeBlockConfiguration>>,
        @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
    ) -> some View {
        environment(
            (\EnvironmentValues.theme).appending(path: keyPath),
            .init { configuration in
                body(.init(configuration.label))
            }
        )
    }
}

public extension Theme {
    @available(
        *,
        deprecated,
        message: """
        Use the version of this function that takes a closure receiving a 'BlockConfiguration'
        value.
        """
    )
    func heading1<Body: View>(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
    ) -> Theme {
        var theme = self
        theme.heading1 = .init(body: body)
        return theme
    }

    @available(
        *,
        deprecated,
        message: """
        Use the version of this function that takes a closure receiving a 'BlockConfiguration'
        value.
        """
    )
    func heading2<Body: View>(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
    ) -> Theme {
        var theme = self
        theme.heading2 = .init(body: body)
        return theme
    }

    @available(
        *,
        deprecated,
        message: """
        Use the version of this function that takes a closure receiving a 'BlockConfiguration'
        value.
        """
    )
    func heading3<Body: View>(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
    ) -> Theme {
        var theme = self
        theme.heading3 = .init(body: body)
        return theme
    }

    @available(
        *,
        deprecated,
        message: """
        Use the version of this function that takes a closure receiving a 'BlockConfiguration'
        value.
        """
    )
    func heading4<Body: View>(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
    ) -> Theme {
        var theme = self
        theme.heading4 = .init(body: body)
        return theme
    }

    @available(
        *,
        deprecated,
        message: """
        Use the version of this function that takes a closure receiving a 'BlockConfiguration'
        value.
        """
    )
    func heading5<Body: View>(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
    ) -> Theme {
        var theme = self
        theme.heading5 = .init(body: body)
        return theme
    }

    @available(
        *,
        deprecated,
        message: """
        Use the version of this function that takes a closure receiving a 'BlockConfiguration'
        value.
        """
    )
    func heading6<Body: View>(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
    ) -> Theme {
        var theme = self
        theme.heading6 = .init(body: body)
        return theme
    }

    @available(
        *,
        deprecated,
        message: """
        Use the version of this function that takes a closure receiving a 'BlockConfiguration'
        value.
        """
    )
    func paragraph<Body: View>(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
    ) -> Theme {
        var theme = self
        theme.paragraph = .init(body: body)
        return theme
    }

    @available(
        *,
        deprecated,
        message: """
        Use the version of this function that takes a closure receiving a 'BlockConfiguration'
        value.
        """
    )
    func blockquote<Body: View>(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
    ) -> Theme {
        var theme = self
        theme.blockquote = .init(body: body)
        return theme
    }

    @available(
        *,
        deprecated,
        message: """
        Use the version of this function that takes a closure receiving a 'CodeBlockConfiguration'
        value.
        """
    )
    func codeBlock<Body: View>(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
    ) -> Theme {
        var theme = self
        theme.codeBlock = .init { configuration in
            body(.init(configuration.label))
        }
        return theme
    }

    @available(
        *,
        deprecated,
        message: """
        Use the version of this function that takes a closure receiving a 'BlockConfiguration'
        value.
        """
    )
    func image<Body: View>(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
    ) -> Theme {
        var theme = self
        theme.image = .init(body: body)
        return theme
    }

    @available(
        *,
        deprecated,
        message: """
        Use the version of this function that takes a closure receiving a 'BlockConfiguration'
        value.
        """
    )
    func list<Body: View>(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
    ) -> Theme {
        var theme = self
        theme.list = .init(body: body)
        return theme
    }

    @available(
        *,
        deprecated,
        message: """
        Use the version of this function that takes a closure receiving a 'BlockConfiguration'
        value.
        """
    )
    func listItem<Body: View>(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
    ) -> Theme {
        var theme = self
        theme.listItem = .init(body: body)
        return theme
    }

    @available(
        *,
        deprecated,
        message: """
        Use the version of this function that takes a closure receiving a 'BlockConfiguration'
        value.
        """
    )
    func table<Body: View>(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration.Label) -> Body
    ) -> Theme {
        var theme = self
        theme.table = .init(body: body)
        return theme
    }
}

// MARK: - Unavailable after 1.1.1:

public extension Heading {
    @available(*, unavailable, message: "Use 'init(_ level:content:)'")
    init(level _: Int, @InlineContentBuilder _: () -> InlineContent) {
        fatalError("Unimplemented")
    }
}

@available(*, unavailable, renamed: "Blockquote")
public typealias BlockQuote = Blockquote

@available(*, unavailable, renamed: "NumberedList")
public typealias OrderedList = NumberedList

@available(*, unavailable, renamed: "BulletedList")
public typealias BulletList = BulletedList

@available(*, unavailable, renamed: "Code")
public typealias InlineCode = Code

@available(
    *,
    unavailable,
    message: """
    "MarkdownImageHandler" has been superseded by the "ImageProvider" protocol and its conforming
    types "DefaultImageProvider" and "AssetImageProvider".
    """
)
public struct MarkdownImageHandler {
    public static var networkImage: Self {
        fatalError("Unimplemented")
    }

    public static func assetImage(
        name _: @escaping (URL) -> String = \.lastPathComponent,
        in _: Bundle? = nil
    ) -> Self {
        fatalError("Unimplemented")
    }
}

public extension Markdown {
    @available(
        *,
        unavailable,
        message: """
        "MarkdownImageHandler" has been superseded by the "ImageProvider" protocol and its conforming
        types "DefaultImageProvider" and "AssetImageProvider".
        """
    )
    func setImageHandler(
        _: MarkdownImageHandler,
        forURLScheme _: String
    ) -> Markdown {
        fatalError("Unimplemented")
    }
}

public extension View {
    @available(
        *,
        unavailable,
        message: "You can create a custom link action by overriding the \"openURL\" environment value."
    )
    func onOpenMarkdownLink(perform _: ((URL) -> Void)? = nil) -> some View {
        self
    }
}

@available(
    *,
    unavailable,
    message: """
    "MarkdownStyle" and its subtypes have been superseded by the "Theme", "TextStyle", and
    "BlockStyle" types.
    """
)
public struct MarkdownStyle: Hashable {
    public struct Font: Hashable {
        public static var largeTitle: Self { fatalError("Unimplemented") }
        public static var title: Self { fatalError("Unimplemented") }
        public static var title2: Self { fatalError("Unimplemented") }
        public static var title3: Self { fatalError("Unimplemented") }
        public static var headline: Self { fatalError("Unimplemented") }
        public static var subheadline: Self { fatalError("Unimplemented") }
        public static var body: Self { fatalError("Unimplemented") }
        public static var callout: Self { fatalError("Unimplemented") }
        public static var footnote: Self { fatalError("Unimplemented") }
        public static var caption: Self { fatalError("Unimplemented") }
        public static var caption2: Self { fatalError("Unimplemented") }

        public static func system(
            size _: CGFloat,
            weight _: SwiftUI.Font.Weight = .regular,
            design _: SwiftUI.Font.Design = .default
        ) -> Self {
            fatalError("Unimplemented")
        }

        public static func system(
            _: SwiftUI.Font.TextStyle,
            design _: SwiftUI.Font.Design = .default
        ) -> Self {
            fatalError("Unimplemented")
        }

        public static func custom(_: String, size _: CGFloat) -> Self {
            fatalError("Unimplemented")
        }

        public func bold() -> Self {
            fatalError("Unimplemented")
        }

        public func italic() -> Self {
            fatalError("Unimplemented")
        }

        public func monospacedDigit() -> Self {
            fatalError("Unimplemented")
        }

        public func monospaced() -> Self {
            fatalError("Unimplemented")
        }

        public func scale(_: CGFloat) -> Self {
            fatalError("Unimplemented")
        }
    }

    public struct HeadingScales: Hashable {
        public init(
            h1 _: CGFloat,
            h2 _: CGFloat,
            h3 _: CGFloat,
            h4 _: CGFloat,
            h5 _: CGFloat,
            h6 _: CGFloat
        ) {
            fatalError("Unimplemented")
        }

        public subscript(_: Int) -> CGFloat {
            fatalError("Unimplemented")
        }

        public static var `default`: Self {
            fatalError("Unimplemented")
        }
    }

    public struct Measurements: Hashable {
        public var codeFontScale: CGFloat
        public var headIndentStep: CGFloat
        public var tailIndentStep: CGFloat
        public var paragraphSpacing: CGFloat
        public var listMarkerSpacing: CGFloat
        public var headingScales: HeadingScales
        public var headingSpacing: CGFloat

        public init(
            codeFontScale _: CGFloat = 0.94,
            headIndentStep _: CGFloat = 1.97,
            tailIndentStep _: CGFloat = -1,
            paragraphSpacing _: CGFloat = 1,
            listMarkerSpacing _: CGFloat = 0.47,
            headingScales _: HeadingScales = .default,
            headingSpacing _: CGFloat = 0.67
        ) {
            fatalError("Unimplemented")
        }
    }

    public var font: MarkdownStyle.Font
    public var foregroundColor: SwiftUI.Color
    public var measurements: Measurements

    public init(
        font _: MarkdownStyle.Font = .body,
        foregroundColor _: SwiftUI.Color = .primary,
        measurements _: MarkdownStyle.Measurements = .init()
    ) {
        fatalError("Unimplemented")
    }
}

public extension View {
    @available(
        *,
        unavailable,
        message: """
        "MarkdownStyle" and its subtypes have been superseded by the "Theme", "TextStyle", and
        "BlockStyle" types.
        """
    )
    func markdownStyle(_: MarkdownStyle) -> some View {
        self
    }
}
