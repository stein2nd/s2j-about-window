import SwiftUI

#if canImport(SwiftUI)
    /// プレーン長文のスクロール表示 (License および非 Markdown の Acknowledgements)。
    @available(macOS 14.0, iOS 17.0, *)
    public struct LegalTextView: View {
        private let content: LegalTextContent

        public init(content: LegalTextContent) {
            self.content = content
        }

        public var body: some View {
            ScrollView {
                Group {
                    switch content {
                    case let .plainText(text):
                        Text(text)
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .textSelection(.enabled)
                    case .empty:
                        Text(emptyMessage)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    case .loadFailed:
                        Text(loadFailedMessage)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }
        }

        private var emptyMessage: String {
            NSLocalizedString(
                "About.LegalText.Empty",
                bundle: Bundle.resourceBundle,
                comment: "Empty legal text document"
            )
        }

        private var loadFailedMessage: String {
            NSLocalizedString(
                "About.LegalText.LoadFailed",
                bundle: Bundle.resourceBundle,
                comment: "Failed to load legal text from bundle"
            )
        }
    }

    /// About から開くリーガル文書シート (ロードは表示時)。
    @available(macOS 14.0, iOS 17.0, *)
    struct LegalTextDocumentSheet: View {
        let kind: LegalTextKind
        let resourceName: String
        let resourceBundle: Bundle

        @Environment(\.dismiss) private var dismiss
        @State private var loadResult: LegalTextLoadResult?

        var body: some View {
            NavigationStack {
                Group {
                    if let loadResult {
                        documentBody(for: loadResult)
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .navigationTitle(sheetTitle)
                #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                #endif
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button(closeLabel) {
                                dismiss()
                            }
                        }
                    }
            }
            #if os(macOS)
            .frame(minWidth: 520, minHeight: 560)
            #endif
            .task(id: taskIdentity) {
                loadResult = LegalTextLoader.load(
                    bundle: resourceBundle,
                    resourceName: resourceName,
                    kind: kind
                )
            }
        }

        private var taskIdentity: String {
            "\(kind.rawValue)-\(resourceName)-\(ObjectIdentifier(resourceBundle))"
        }

        @ViewBuilder
        private func documentBody(for result: LegalTextLoadResult) -> some View {
            if LegalTextLoader.usesMarkdownRendering(kind: kind, result: result),
               case let .plainText(markdown) = result.content
            {
                MarkdownView(content: markdown)
            } else {
                LegalTextView(content: result.content)
            }
        }

        private var sheetTitle: String {
            switch kind {
            case .license:
                NSLocalizedString(
                    "About.LegalText.Title.License",
                    bundle: Bundle.resourceBundle,
                    comment: "License sheet title"
                )
            case .acknowledgements:
                NSLocalizedString(
                    "About.LegalText.Title.Acknowledgements",
                    bundle: Bundle.resourceBundle,
                    comment: "Acknowledgements sheet title"
                )
            }
        }

        private var closeLabel: String {
            NSLocalizedString(
                "About.Close",
                bundle: Bundle.resourceBundle,
                comment: "Close button"
            )
        }
    }
#endif
