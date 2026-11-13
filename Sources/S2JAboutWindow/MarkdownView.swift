import SwiftUI
import Textual

#if canImport(SwiftUI)
    enum MarkdownRenderingContext: Sendable {
        case about
        case legalDocument
    }

    /**
     * MarkdownView
     * @return MarkdownView
     */
    @available(macOS 15.0, iOS 18.0, *)
    public struct MarkdownView: View {
        let content: String
        private let context: MarkdownRenderingContext

        /**
         * @param content: 表示するコンテンツ（Markdown）
         */
        public init(content: String) {
            self.content = content
            context = .about
        }

        init(content: String, context: MarkdownRenderingContext) {
            self.content = content
            self.context = context
        }

        /**
         * MarkdownViewの本体
         * @return MarkdownViewの本体
         */
        public var body: some View {
            ScrollView {
                structuredText
                    .textual.textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
        }

        @ViewBuilder
        private var structuredText: some View {
            let text = StructuredText(markdown: content)
            switch context {
            case .about:
                text.textual.structuredTextStyle(.default)
            case .legalDocument:
                text.textual.structuredTextStyle(.gitHub)
            }
        }
    }

    #if DEBUG
        @available(macOS 15.0, iOS 18.0, *)
        struct MarkdownView_Previews: PreviewProvider {
            static var previews: some View {
                MarkdownView(content: """
                # About This App

                This is a **sample** about content with *markdown* formatting.

                ## Features
                - Feature 1
                - Feature 2
                - Feature 3

                [Visit our website](https://example.com)
                """)
            }
        }
    #endif
#endif
