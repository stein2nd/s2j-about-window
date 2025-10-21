import SwiftUI

#if canImport(SwiftUI)
@available(macOS 12.0, iOS 15.0, *)
public struct AboutView: View {
    @StateObject private var viewModel: AboutViewModel
    
    public init(
        content: String,
        appName: String? = nil,
        version: String? = nil,
        copyright: String? = nil
    ) {
        self._viewModel = StateObject(wrappedValue: AboutViewModel(
            content: content,
            appName: appName,
            version: version,
            copyright: copyright
        ))
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            // アプリアイコン
            appIconView
            
            // アプリ情報
            appInfoView
            
            // コンテンツ表示
            MarkdownView(content: viewModel.content)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            
            Spacer()
        }
        .padding()
        .frame(minWidth: 400, minHeight: 500)
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    private var appIconView: some View {
        Group {
            if let icon = NSApplication.shared.applicationIconImage {
                Image(nsImage: icon)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray)
                    .frame(width: 64, height: 64)
            }
        }
    }
    
    private var appInfoView: some View {
        VStack(spacing: 8) {
            Text(viewModel.appName)
                .font(.title2)
                .fontWeight(.bold)
            
            if let version = viewModel.version {
                Text("Version \(version)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if let copyright = viewModel.copyright {
                Text(copyright)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#if DEBUG
@available(macOS 12.0, iOS 15.0, *)
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView(
            content: "# About This App\n\nThis is a sample about content.",
            appName: "Sample App",
            version: "1.0.0",
            copyright: "© 2024 Sample Company"
        )
    }
}
#endif
#endif
