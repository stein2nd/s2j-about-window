import SwiftUI

/// アバウトウインドウのメインビュー
struct AboutWindowView: View {
    @StateObject private var viewModel = AboutWindowViewModel()

    var body: some View {
        VStack(spacing: 16) {
            // アプリアイコン
            if let appIcon = viewModel.appIcon {
                Image(nsImage: appIcon)
                    .resizable()
                    .frame(width: 96, height: 96)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            // アプリ名
            Text(viewModel.appName)
                .font(.title)
                .fontWeight(.bold)
            // バージョン
            Text(viewModel.versionString)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Divider()
            // 著作権
            Text(viewModel.copyright)
                .font(.footnote)
                .foregroundStyle(.secondary)
            // ライセンス情報
            LicenseView(licenseText: viewModel.licenseText)
                .frame(maxWidth: .infinity, maxHeight: 120)
        }
        .padding(32)
        .frame(minWidth: 360, idealWidth: 400, minHeight: 420)
        .background(.background)
    }
}

#Preview {
    AboutWindowView()
}
