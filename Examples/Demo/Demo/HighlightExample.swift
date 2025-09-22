import MarkdownUI
import SwiftUI

struct HighlightExample: View {
    @State private var highlightPhrases = Set(["Swift", "Markdown", "highlight", "great apps"])
    @State private var markdownText = """
    # Highlight Feature Demo

    This is a demo of the new **highlight** feature in MarkdownUI.

    The word **Swift** appears multiple times in this text. Swift is a powerful
    programming language, and Swift makes it easy to build great apps.

    You can highlight any phrase you want, including the word Markdown.
    The Markdown parser will highlight all instances of your chosen phrases.

    Multi-word phrases like "great apps" are also highlighted!

    ## Features

    - Words are highlighted with a yellow background by default
    - You can customize both background and foreground colors
    - Case-insensitive matching is supported
    - The highlight feature works with all Markdown formatting

    Even in **bold text containing Swift** or *italic text with Markdown*, 
    the highlight feature still works!

    ### Code blocks

    The word `Swift` in inline code should also be highlighted.
    """

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Default yellow highlight
                Markdown(markdownText)
                    .markdownHighlight(
                        phrases: highlightPhrases
                    )
                    .padding()

                Divider()

                // Custom colors
                Markdown(markdownText)
                    .markdownHighlight(
                        phrases: highlightPhrases,
                        backgroundColor: .blue.opacity(0.3),
                        foregroundColor: .white
                    )
                    .padding()

                Divider()

                // Case sensitive example
                Markdown("The word swift (lowercase) vs Swift (uppercase)")
                    .markdownHighlight(
                        phrases: ["Swift"],
                        backgroundColor: .green.opacity(0.3),
                        caseSensitive: true
                    )
                    .padding()
            }
        }
        .navigationTitle("Highlight Demo")
    }
}

#Preview {
    NavigationView {
        HighlightExample()
    }
}
