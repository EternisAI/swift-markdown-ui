import MarkdownUI
import SwiftUI

struct TextStylesView: View {
    private let content = """
    ```
    **This is bold text**
    ```
    **This is bold text**
    ```
    *This text is italicized*
    ```
    *This text is italicized*
    ```
    ~~This was mistaken text~~
    ```
    ~~This was mistaken text~~
    ```
    <mark>This text is highlighted</mark>
    ```
    <mark>This text is highlighted</mark>
    ```
    **This text is _extremely_ important**
    ```
    **This text is _extremely_ important**
    ```
    ***All this text is important***
    ```
    ***All this text is important***
    ```
    You can <mark>**combine highlight with bold**</mark> and <mark>*italic*</mark>
    ```
    You can <mark>**combine highlight with bold**</mark> and <mark>*italic*</mark>
    ```
    MarkdownUI is fully compliant with the [CommonMark Spec](https://spec.commonmark.org/current/).
    ```
    MarkdownUI is fully compliant with the [CommonMark Spec](https://spec.commonmark.org/current/).
    ```
    Visit https://github.com.
    ```
    Visit https://github.com.
    ```
    Use `git status` to list all new or modified files that haven't yet been committed.
    ```
    Use `git status` to list all new or modified files that haven't yet been committed.
    """

    var body: some View {
        DemoView {
            Markdown(self.content)

            Section("Customization Example") {
                Markdown(self.content)
            }
            .markdownTextStyle(\.code) {
                FontFamilyVariant(.monospaced)
                BackgroundColor(.purple.opacity(0.2))
            }
            .markdownTextStyle(\.emphasis) {
                FontStyle(.italic)
                UnderlineStyle(.single)
            }
            .markdownTextStyle(\.strong) {
                FontWeight(.heavy)
            }
            .markdownTextStyle(\.strikethrough) {
                StrikethroughStyle(.init(pattern: .solid, color: .red))
            }
            .markdownTextStyle(\.highlight) {
                BackgroundColor(.cyan.opacity(0.3))
                ForegroundColor(.blue)
            }
            .markdownTextStyle(\.link) {
                ForegroundColor(.mint)
                UnderlineStyle(.init(pattern: .dot))
            }

            Section("Highlighting Words API") {
                Markdown(
                    """
                    ## Highlight specific words
                    You can highlight specific words using the new API.
                    The words 'specific', 'highlight', and 'API' are highlighted in this text.
                    It works with **bold specific text** and *italic API mentions* too!
                    `API key: API_a123`
                    ```swift
                    This is specific API key API_123
                    ```
                    """,
                    highlightingWords: ["specific", "highlight", "API"]
                )
                .markdownTheme(.gitHub)

            }
        }
    }
}

struct TextStylesView_Previews: PreviewProvider {
    static var previews: some View {
        TextStylesView()
    }
}
