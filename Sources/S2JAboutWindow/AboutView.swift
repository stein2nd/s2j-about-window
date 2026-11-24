import SwiftUI

#if canImport(SwiftUI)
    #if os(macOS)
        import AppKit
    #endif

    #if os(iOS)
        import UIKit
    #endif

    private struct FooterLayoutWidthKey: PreferenceKey {
        static let defaultValue: CGFloat = 400
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }

    /**
     * AboutView
     * @return AboutView
     */
    @available(macOS 15.0, iOS 18.0, *)
    public struct AboutView: View {
        @StateObject private var viewModel: AboutViewModel

        private let headerOptions: AboutHeaderOptions
        private let licenseResourceName: String?
        private let acknowledgementsResourceName: String?
        private let resourceBundle: Bundle

        @State private var presentedLegalKind: LegalTextKind?
        @State private var footerUsesVerticalStack = false

        #if os(iOS)
            @Environment(\.horizontalSizeClass) private var horizontalSizeClass
        #endif

        public init(
            content: String,
            contentType: AboutContentType = .automatic,
            appName: String? = nil,
            version: String? = nil,
            copyright: String? = nil,
            headerOptions: AboutHeaderOptions = .default,
            licenseResourceName: String? = nil,
            acknowledgementsResourceName: String? = nil,
            resourceBundle: Bundle = .main
        ) {
            _viewModel = StateObject(wrappedValue: AboutViewModel(
                content: content,
                contentType: contentType,
                appName: appName,
                version: version,
                copyright: copyright
            ))
            self.headerOptions = headerOptions
            self.licenseResourceName = licenseResourceName
            self.acknowledgementsResourceName = acknowledgementsResourceName
            self.resourceBundle = resourceBundle
        }

        public var body: some View {
            VStack(spacing: 20) {
                headerSection

                AboutContentView(content: viewModel.content, contentType: viewModel.contentType)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()

                actionButtonsFooter

                Spacer()
            }
            .padding()
            .frame(minWidth: minimumContentWidth, minHeight: 500)
            .background(backgroundColor)
            .sheet(item: $presentedLegalKind) { kind in
                LegalTextDocumentSheet(
                    kind: kind,
                    resourceName: resourceName(for: kind),
                    resourceBundle: resourceBundle
                )
            }
        }

        private var minimumContentWidth: CGFloat {
            effectiveHeaderStyle == .classicHorizontal ? 480 : 400
        }

        private var effectiveHeaderStyle: AboutHeaderStyle {
            #if os(iOS)
                if headerOptions.style == .classicHorizontal, horizontalSizeClass == .compact {
                    return .vertical
                }
            #endif
            return headerOptions.style
        }

        @ViewBuilder
        private var headerSection: some View {
            switch effectiveHeaderStyle {
            case .vertical:
                VStack(spacing: 20) {
                    appIconView
                    appMetaColumn(alignment: .center)
                }
            case .classicHorizontal:
                HStack(alignment: .top, spacing: 16) {
                    appIconView
                    appMetaColumn(alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }

        @ViewBuilder
        private var actionButtonsFooter: some View {
            if hasActionButtons {
                Group {
                    if footerUsesVerticalStack {
                        VStack(spacing: 8) {
                            actionButtons
                        }
                    } else {
                        HStack(spacing: 16) {
                            actionButtons
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: FooterLayoutWidthKey.self, value: geometry.size.width)
                    }
                )
                .onPreferenceChange(FooterLayoutWidthKey.self) { width in
                    footerUsesVerticalStack = width < 420
                }
            }
        }

        @ViewBuilder
        private var actionButtons: some View {
            if let primary = headerOptions.resolvedPrimaryLink {
                Button(primary.title) {
                    openURL(primary.url)
                }
                .accessibilityLabel(primary.title)
                .accessibilityIdentifier("about.primaryLink.button")
            }
            if let licenseResourceName {
                Button(licenseButtonTitle) {
                    presentedLegalKind = .license
                }
                .accessibilityIdentifier("about.license.button")
                .disabled(licenseResourceName.isEmpty)
            }
            if let acknowledgementsResourceName {
                Button(acknowledgementsButtonTitle) {
                    presentedLegalKind = .acknowledgements
                }
                .accessibilityIdentifier("about.acknowledgements.button")
                .disabled(acknowledgementsResourceName.isEmpty)
            }
        }

        private var hasActionButtons: Bool {
            headerOptions.resolvedPrimaryLink != nil
                || licenseResourceName != nil
                || acknowledgementsResourceName != nil
        }

        private func openURL(_ url: URL) {
            #if os(macOS)
                NSWorkspace.shared.open(url)
            #elseif os(iOS)
                UIApplication.shared.open(url)
            #endif
        }

        private func resourceName(for kind: LegalTextKind) -> String {
            switch kind {
            case .license:
                licenseResourceName ?? ""
            case .acknowledgements:
                acknowledgementsResourceName ?? ""
            }
        }

        private var licenseButtonTitle: String {
            NSLocalizedString(
                "About.License.Button",
                bundle: Bundle.resourceBundle,
                comment: "License button"
            )
        }

        private var acknowledgementsButtonTitle: String {
            NSLocalizedString(
                "About.Acknowledgements.Button",
                bundle: Bundle.resourceBundle,
                comment: "Acknowledgements button"
            )
        }

        private var iconSideLength: CGFloat {
            headerOptions.iconSideLength ?? (effectiveHeaderStyle == .classicHorizontal ? 128 : 64)
        }

        private var appIconView: some View {
            Group {
                #if os(macOS)
                    if let icon = NSApplication.shared.applicationIconImage {
                        Image(nsImage: icon)
                            .resizable()
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray)
                    }
                #elseif os(iOS)
                    if let icon = UIImage(named: "AppIcon") ?? UIImage(named: "AppIcon-60x60") {
                        Image(uiImage: icon)
                            .resizable()
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray)
                    }
                #endif
            }
            .frame(width: iconSideLength, height: iconSideLength)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .accessibilityLabel(viewModel.appName)
        }

        private var backgroundColor: Color {
            #if os(macOS)
                Color(NSColor.windowBackgroundColor)
            #elseif os(iOS)
                Color(UIColor.systemBackground)
            #else
                Color.clear
            #endif
        }

        private func appMetaColumn(alignment: HorizontalAlignment) -> some View {
            VStack(alignment: alignment, spacing: 8) {
                Text(viewModel.appName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(alignment == .center ? .center : .leading)

                if let versionLine = versionDisplayLine {
                    Text(versionLine)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(alignment == .center ? .center : .leading)
                        .accessibilityLabel(versionLine)
                }

                accessoryImageView

                if let copyright = viewModel.copyright {
                    Text(copyright)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(alignment == .center ? .center : .leading)
                        .accessibilityLabel(copyright)
                }

                if let identifier = headerOptions.supportIdentifier, !identifier.isEmpty {
                    Text(supportIdentifierLine(identifier))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(alignment == .center ? .center : .leading)
                        .accessibilityLabel(supportIdentifierLine(identifier))
                }
            }
        }

        private var versionDisplayLine: String? {
            let versionLabel = NSLocalizedString(
                "About.Version",
                bundle: Bundle.resourceBundle,
                comment: "Version prefix"
            )
            return AboutVersionDisplay.formattedLine(
                marketingVersion: viewModel.version,
                showBuildNumber: headerOptions.showBuildNumber,
                buildNumber: viewModel.buildNumber,
                buildNumberOverride: headerOptions.buildNumberOverride,
                versionLabel: versionLabel
            )
        }

        private func supportIdentifierLine(_ value: String) -> String {
            let prefix = NSLocalizedString(
                "About.SupportIdentifier.Prefix",
                bundle: Bundle.resourceBundle,
                comment: "Support identifier label"
            )
            return "\(prefix) \(value)"
        }

        @ViewBuilder
        private var accessoryImageView: some View {
            if let name = headerOptions.headerAccessoryImageName, !name.isEmpty {
                #if os(macOS)
                    if let image = headerOptions.accessoryBundle.image(forResource: name) {
                        Image(nsImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 32)
                            .accessibilityHidden(true)
                    }
                #elseif os(iOS)
                    if let image = UIImage(named: name, in: headerOptions.accessoryBundle, compatibleWith: nil) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 32)
                            .accessibilityHidden(true)
                    }
                #endif
            }
        }
    }

    #if DEBUG
        @available(macOS 15.0, iOS 18.0, *)
        struct AboutView_Previews: PreviewProvider {
            static var previews: some View {
                Group {
                    AboutView(
                        content: PreviewContent.markdown(named: "AboutPreview"),
                        appName: "Sample App",
                        version: "1.0.0",
                        copyright: "© 2024 Sample Company"
                    )
                    AboutView(
                        content: PreviewContent.markdown(named: "AboutPreview"),
                        appName: "Classic Sample",
                        version: "1.0.23",
                        copyright: "© 2024 Sample Company",
                        headerOptions: AboutHeaderOptions(
                            style: .classicHorizontal,
                            showBuildNumber: true,
                            buildNumberOverride: "4",
                            primaryLinkTitle: "GitHub Repository",
                            primaryLinkURL: URL(string: "https://github.com/stein2nd/s2j-about-window")
                        )
                    )
                }
            }
        }
    #endif
#endif
