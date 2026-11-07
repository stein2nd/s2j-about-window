import Foundation
import SwiftUI

#if canImport(SwiftUI)
    /**
     * MarkdownView
     * @return MarkdownView
     */
    @available(macOS 14.0, iOS 17.0, *)
    public struct MarkdownView: View {
        /**
         * @var content: 表示するコンテンツ（Markdown）
         */
        let content: String

        /**
         * @var attributedString: 表示するコンテンツ（AttributedString）
         */
        @State private var attributedString: AttributedString = .init()

        /**
         * @param content: 表示するコンテンツ（Markdown）
         */
        public init(content: String) {
            self.content = content
        }

        /**
         * MarkdownViewの本体
         * @return MarkdownViewの本体
         */
        public var body: some View {
            ScrollView {
                Text(attributedString)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .task(id: content) {
                parseMarkdown()
            }
        }

        /**
         * Markdownを解析する
         * @return void
         */
        private func parseMarkdown() {
            do {
                // Markdownを解析してAttributedStringを作成
                attributedString = try AttributedString(markdown: content)
            } catch {
                // Markdown解析に失敗した場合はプレーンテキストとして表示
                attributedString = AttributedString(content)
            }
        }
    }

    #if DEBUG
        /**
         * MarkdownView_Previews
         * @return MarkdownView_Previews
         */
        @available(macOS 14.0, iOS 17.0, *)
        struct MarkdownView_Previews: PreviewProvider {
            /**
             * MarkdownViewのプレビュー
             * @return MarkdownView_Previews
             */
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
