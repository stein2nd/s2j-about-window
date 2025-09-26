import SwiftUI

/// ライセンス情報表示用ビュー（今後Markdown対応など拡張可能）
struct LicenseView: View {
    let licenseText: String

    var body: some View {
        ScrollView {
            Text(licenseText)
                .font(.footnote)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(.quaternary, lineWidth: 1)
        )
        .accessibilityLabel(Text("License Section"))
    }
}

#Preview {
    LicenseView(licenseText: "Sample License Text\nCopyright (c) 2025 Example")
}
