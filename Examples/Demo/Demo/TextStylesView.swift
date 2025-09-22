import MarkdownUI
import Splash
import SwiftUI

struct TextStylesView: View {
    @Environment(\.colorScheme) private var colorScheme
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
    **This text is _extremely_ important**
    ```
    **This text is _extremely_ important**
    ```
    ***All this text is important***
    ```
    ***All this text is important***
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
                BackgroundColor(.yellow.opacity(0.5))
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
            .markdownTextStyle(\.link) {
                ForegroundColor(.mint)
                UnderlineStyle(.init(pattern: .dot))
            }

            Section("Text Highlighting") {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Default yellow highlight:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Markdown("This example highlights the words **bold**, *text*, and `git` throughout the content. Even in different formatting contexts, the highlighting works consistently.")
                        .markdownHighlight(phrases: ["bold", "text", "git"])

                    Text("Custom colors with blue background:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top)

                    Markdown("You can customize the highlight colors. Here we highlight **CommonMark** and **MarkdownUI** with a blue background and white text.")
                        .markdownHighlight(
                            phrases: ["CommonMark", "MarkdownUI"],
                            backgroundColor: .blue.opacity(0.7),
                            foregroundColor: .white
                        )

                    Text("Case-sensitive highlighting:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top)

                    Markdown("The word 'use' appears but only 'Use' (capitalized) is highlighted when case-sensitive mode is enabled. use vs Use.")
                        .markdownHighlight(
                            phrases: ["Use"],
                            backgroundColor: .green.opacity(0.3),
                            caseSensitive: true
                        )
                }
            }

            Section("Anonymizer Example") {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Redacting sensitive information (full phrases):")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Markdown("""
                    **Original message:**
                    I'll see you soon at 123 Fake Street, and my phone number is 555-0123. 
                    Please send the package to john.doe@example.com by tomorrow.
                    """)
                    .markdownHighlight(
                        phrases: ["123 Fake Street", "555-0123", "john.doe@example.com"],
                        backgroundColor: .black,
                        foregroundColor: .white
                    )

                    Text("Anonymizing personal data:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top)

                    Markdown("""
                    The patient **Jane Smith** (DOB: 01/15/1985, SSN: 123-45-6789) was admitted 
                    to the hospital at 456 Medical Center Drive. Her emergency contact is 
                    Robert Smith at 555-9876.

                    ```json
                    {
                      "patient": {
                        "name": "Jane Smith",
                        "dob": "01/15/1985",
                        "ssn": "123-45-6789",
                        "admission": {
                          "location": "456 Medical Center Drive",
                          "date": "2024-03-15"
                        },
                        "emergency_contact": {
                          "name": "Robert Smith",
                          "phone": "555-9876"
                        }
                      }
                    }
                    ```

                    ```python
                    # Patient data processing script
                    class Patient:
                        def __init__(self, name, dob, ssn):
                            self.name = name  # Jane Smith
                            self.dob = dob    # 01/15/1985
                            self.ssn = ssn    # 123-45-6789

                    def process_admission(patient_name, location):
                        # Process admission for Jane Smith
                        print(f"Admitting {patient_name} to {location}")
                        # Contact: Robert Smith at 555-9876
                        return True

                    patient = Patient("Jane Smith", "01/15/1985", "123-45-6789")
                    process_admission(patient.name, "456 Medical Center Drive")
                    ```
                    """)
                    .markdownCodeSyntaxHighlighter(.splash(theme: splashTheme))
                    .markdownHighlight(
                        phrases: [
                            "Jane Smith",
                            "01/15/1985",
                            "123-45-6789",
                            "456 Medical Center Drive",
                            "Robert Smith",
                            "555-9876",
                        ],
                        backgroundColor: .black,
                        foregroundColor: .white
                    )

                    Text("Location and contact redaction:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top)

                    Markdown("""
                    Meeting scheduled at 1234 Oak Avenue, Suite 500 on Monday.
                    Contact me at (415) 555-0199 or email sarah.johnson@company.com.
                    The backup location is 789 Pine Street, Building A.
                    """)
                    .markdownHighlight(
                        phrases: [
                            "1234 Oak Avenue, Suite 500",
                            "(415) 555-0199",
                            "sarah.johnson@company.com",
                            "789 Pine Street, Building A",
                        ],
                        backgroundColor: .black,
                        foregroundColor: .white
                    )
                }
            }
        }
    }

    private var splashTheme: Splash.Theme {
        switch colorScheme {
        case .dark:
            return .wwdc17(withFont: .init(size: 14))
        default:
            return .sunset(withFont: .init(size: 14))
        }
    }
}

struct TextStylesView_Previews: PreviewProvider {
    static var previews: some View {
        TextStylesView()
    }
}
