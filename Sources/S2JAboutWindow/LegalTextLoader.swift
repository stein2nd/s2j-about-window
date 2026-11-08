import Foundation

#if canImport(SwiftUI)
    /// License と Acknowledgements を区別する。
    public enum LegalTextKind: String, Sendable, CaseIterable, Identifiable {
        case license
        case acknowledgements

        public var id: String {
            rawValue
        }
    }

    /// バンドルからのロード結果。
    public enum LegalTextContent: Equatable, Sendable {
        case plainText(String)
        case empty
        case loadFailed
    }

    /// ロード結果と、解決したファイル拡張子 (小文字、ドットなし)。
    public struct LegalTextLoadResult: Equatable, Sendable {
        public let content: LegalTextContent
        public let resolvedFileExtension: String?

        public init(content: LegalTextContent, resolvedFileExtension: String?) {
            self.content = content
            self.resolvedFileExtension = resolvedFileExtension
        }
    }

    public enum LegalTextLoader {
        public static func load(
            bundle: Bundle,
            resourceName: String,
            kind: LegalTextKind,
            preferredExtensions: [String]? = nil
        ) -> LegalTextLoadResult {
            let (name, explicitExtension) = splitResourceName(resourceName)
            let extensionsToTry = extensionsToTry(
                kind: kind,
                explicitExtension: explicitExtension,
                preferredExtensions: preferredExtensions
            )

            for fileExtension in extensionsToTry {
                guard let url = bundle.url(
                    forResource: name,
                    withExtension: fileExtension.nilIfEmpty
                ) else {
                    continue
                }

                let resolvedExtension = fileExtension.nilIfEmpty ?? url.pathExtension.lowercased()
                let text = readText(at: url)
                let content = contentFromText(text)
                return LegalTextLoadResult(
                    content: content,
                    resolvedFileExtension: resolvedExtension.nilIfEmpty
                )
            }

            return LegalTextLoadResult(content: .loadFailed, resolvedFileExtension: nil)
        }

        /// Acknowledgements を `MarkdownView` で表示するか。
        public static func usesMarkdownRendering(kind: LegalTextKind, result: LegalTextLoadResult) -> Bool {
            guard kind == .acknowledgements,
                  case .plainText = result.content
            else {
                return false
            }
            return result.resolvedFileExtension?.lowercased() == "md"
        }

        private static func splitResourceName(_ resourceName: String) -> (name: String, explicitExtension: String?) {
            let trimmed = resourceName.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let dotIndex = trimmed.lastIndex(of: "."),
                  dotIndex > trimmed.startIndex
            else {
                return (trimmed, nil)
            }
            let name = String(trimmed[..<dotIndex])
            let ext = String(trimmed[trimmed.index(after: dotIndex)...])
            guard !name.isEmpty, !ext.isEmpty else {
                return (trimmed, nil)
            }
            return (name, ext)
        }

        private static func extensionsToTry(
            kind: LegalTextKind,
            explicitExtension: String?,
            preferredExtensions: [String]?
        ) -> [String] {
            if let explicitExtension {
                return [explicitExtension]
            }
            if let preferredExtensions, !preferredExtensions.isEmpty {
                return preferredExtensions
            }
            switch kind {
            case .license:
                return ["", "txt"]
            case .acknowledgements:
                return ["md", "txt", ""]
            }
        }

        private static func readText(at url: URL) -> String? {
            if let utf8 = try? String(contentsOf: url, encoding: .utf8) {
                return utf8
            }
            if let utf16 = try? String(contentsOf: url, encoding: .utf16) {
                return utf16
            }
            return nil
        }

        private static func contentFromText(_ text: String?) -> LegalTextContent {
            guard let text else {
                return .loadFailed
            }
            if text.isEmpty {
                return .empty
            }
            return .plainText(text)
        }
    }

    private extension String {
        var nilIfEmpty: String? {
            isEmpty ? nil : self
        }
    }
#endif
