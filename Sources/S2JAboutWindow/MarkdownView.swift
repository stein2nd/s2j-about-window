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
            let blocks = Self.markdownBlocks(from: content)
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(blocks.enumerated()), id: \.offset) { _, block in
                        markdownBlockText(block)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }

        @ViewBuilder
        private func markdownBlockText(_ block: String) -> some View {
            if let attributed = try? AttributedString(markdown: block) {
                Text(attributed)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text(block)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }

        /**
         * Markdown を表示用ブロックに分割する。
         * `Text(AttributedString)` は段落間の改行を描画しないため、ブロックごとに `Text` を並べる。
         */
        static func markdownBlocks(from content: String) -> [String] {
            var blocks: [String] = []

            for section in content.components(separatedBy: "\n\n") {
                let trimmedSection = section.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmedSection.isEmpty else { continue }

                let lines = trimmedSection
                    .split(separator: "\n", omittingEmptySubsequences: true)
                    .map { String($0).trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }

                if lines.count > 1, lines.allSatisfy(isListLine) {
                    blocks.append(contentsOf: lines)
                } else {
                    blocks.append(lines.joined(separator: "\n"))
                }
            }

            return blocks
        }

        private static func isListLine(_ line: String) -> Bool {
            line.hasPrefix("- ")
                || line.hasPrefix("* ")
                || line.hasPrefix("+ ")
                || line.range(of: #"^\d+\.\s"#, options: .regularExpression) != nil
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
