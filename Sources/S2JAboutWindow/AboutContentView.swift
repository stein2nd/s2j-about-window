import Foundation
import SwiftUI

#if canImport(SwiftUI)
    /// About 本文の表示形式。
    @available(macOS 15.0, iOS 18.0, *)
    public enum AboutContentType: Sendable, Equatable {
        /// 文字列の先頭・構造から Markdown / JSON / RTF を推定する。
        case automatic
        case markdown
        case json
        case rtf

        /// `requested` が `.automatic` のときは本文から推定し、それ以外は `requested` を返す。
        public static func effective(
            for content: String,
            requested: AboutContentType = .automatic
        ) -> AboutContentType {
            AboutContentFormat.kind(for: content, contentType: requested)
        }
    }

    enum AboutContentFormat: Equatable, Sendable {
        case markdown(String)
        case json(String)
        case rtf(AttributedString)

        static func resolve(_ content: String, contentType: AboutContentType = .automatic) -> AboutContentFormat {
            switch contentType {
            case .automatic:
                return resolveAutomatic(content)
            case .markdown:
                return .markdown(content)
            case .json:
                if let pretty = prettyPrintedJSON(from: content) {
                    return .json(pretty)
                }
                return .json(content)
            case .rtf:
                if let attributed = attributedStringFromRTF(content) {
                    return .rtf(attributed)
                }
                return .markdown(content)
            }
        }

        static func kind(for content: String, contentType: AboutContentType = .automatic) -> AboutContentType {
            if contentType != .automatic {
                return contentType
            }
            return inferredAutomaticKind(for: content)
        }

        private static func inferredAutomaticKind(for content: String) -> AboutContentType {
            let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.lowercased().hasPrefix("{\\rtf"), attributedStringFromRTF(content) != nil {
                return .rtf
            }
            if let first = trimmed.first, first == "{" || first == "[" {
                if prettyPrintedJSON(from: trimmed) != nil {
                    return .json
                }
            }
            return .markdown
        }

        private static func resolveAutomatic(_ content: String) -> AboutContentFormat {
            resolve(content, contentType: inferredAutomaticKind(for: content))
        }

        static func prettyPrintedJSON(from string: String) -> String? {
            guard let data = string.data(using: .utf8),
                  let object = try? JSONSerialization.jsonObject(with: data),
                  let prettyData = try? JSONSerialization.data(
                      withJSONObject: object,
                      options: [.prettyPrinted, .sortedKeys]
                  ),
                  let pretty = String(data: prettyData, encoding: .utf8)
            else {
                return nil
            }
            return pretty
        }

        static func attributedStringFromRTF(_ string: String) -> AttributedString? {
            guard let data = string.data(using: .utf8),
                  let nsAttributed = try? NSAttributedString(
                      data: data,
                      options: [.documentType: NSAttributedString.DocumentType.rtf],
                      documentAttributes: nil
                  ),
                  nsAttributed.length > 0
            else {
                return nil
            }
            return AttributedString(nsAttributed)
        }
    }

    @available(macOS 15.0, iOS 18.0, *)
    struct AboutContentView: View {
        let content: String
        let contentType: AboutContentType

        init(content: String, contentType: AboutContentType = .automatic) {
            self.content = content
            self.contentType = contentType
        }

        var body: some View {
            switch AboutContentFormat.resolve(content, contentType: contentType) {
            case let .markdown(markdown):
                MarkdownView(content: markdown)
            case let .json(pretty):
                jsonBody(pretty)
            case let .rtf(attributed):
                rtfBody(attributed)
            }
        }

        private func jsonBody(_ pretty: String) -> some View {
            ScrollView {
                Text(pretty)
                    .font(.system(.body, design: .monospaced))
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
        }

        private func rtfBody(_ attributed: AttributedString) -> some View {
            ScrollView {
                Text(attributed)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
        }
    }
#endif
