import SwiftUI
import Foundation

#if canImport(SwiftUI)
@available(macOS 12.0, iOS 15.0, *)
public struct MarkdownView: View {
    let content: String
    @State private var attributedString: AttributedString = AttributedString()
    
    public init(content: String) {
        self.content = content
    }
    
    public var body: some View {
        ScrollView {
            Text(attributedString)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .onAppear {
            parseMarkdown()
        }
        .onChange(of: content) { _ in
            parseMarkdown()
        }
    }
    
    private func parseMarkdown() {
        do {
            attributedString = try AttributedString(markdown: content)
        } catch {
            // Markdown解析に失敗した場合はプレーンテキストとして表示
            attributedString = AttributedString(content)
        }
    }
}

#if DEBUG
@available(macOS 12.0, iOS 15.0, *)
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
