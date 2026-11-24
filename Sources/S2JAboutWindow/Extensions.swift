import Foundation
import SwiftUI

#if canImport(SwiftUI)
    /**
     * iPadOS向けのExtensions
     * @return Extensions
     */
    private func aboutSheetNavigationChrome(
        isPresented: Binding<Bool>,
        about: () -> AboutView
    ) -> some View {
        NavigationView {
            about()
                .navigationTitle(
                    NSLocalizedString(
                        "About.Title",
                        bundle: Bundle.resourceBundle,
                        comment: "About Window Title"
                    )
                )
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(
                            NSLocalizedString(
                                "About.Close",
                                bundle: Bundle.resourceBundle,
                                comment: "Close button"
                            )
                        ) {
                            isPresented.wrappedValue = false
                        }
                    }
                }
            #endif
        }
    }

    @available(macOS 15.0, iOS 18.0, *)
    public extension View {
        /**
         * iPadOS向けのSheet表示用のAboutView
         * @param isPresented: 表示状態
         * @param content: 表示するコンテンツ（Markdown、JSON、RTF）
         * @param contentType: 本文の表示形式 (デフォルト `.automatic`)
         * @param appName: アプリ名
         * @param version: バージョン
         * @param copyright: 著作権情報
         * @return some View
         */
        func aboutSheet(
            isPresented: Binding<Bool>,
            content: String,
            contentType: AboutContentType = .automatic,
            appName: String? = nil,
            version: String? = nil,
            copyright: String? = nil,
            headerOptions: AboutHeaderOptions = .default,
            licenseResourceName: String? = nil,
            acknowledgementsResourceName: String? = nil,
            resourceBundle: Bundle = .main
        ) -> some View {
            sheet(isPresented: isPresented) {
                aboutSheetNavigationChrome(isPresented: isPresented) {
                    AboutView(
                        content: content,
                        contentType: contentType,
                        appName: appName,
                        version: version,
                        copyright: copyright,
                        headerOptions: headerOptions,
                        licenseResourceName: licenseResourceName,
                        acknowledgementsResourceName: acknowledgementsResourceName,
                        resourceBundle: resourceBundle
                    )
                }
            }
        }

        /**
         * iPadOS向けのPopover表示用のAboutView
         * @param isPresented: 表示状態
         * @param content: 表示するコンテンツ（Markdown、JSON、RTF）
         * @param contentType: 本文の表示形式 (デフォルト `.automatic`)
         * @param appName: アプリ名
         * @param version: バージョン
         * @param copyright: 著作権情報
         * @return some View
         */
        func aboutPopover(
            isPresented: Binding<Bool>,
            content: String,
            contentType: AboutContentType = .automatic,
            appName: String? = nil,
            version: String? = nil,
            copyright: String? = nil,
            headerOptions: AboutHeaderOptions = .default,
            licenseResourceName: String? = nil,
            acknowledgementsResourceName: String? = nil,
            resourceBundle: Bundle = .main
        ) -> some View {
            let popoverWidth: CGFloat = headerOptions.style == .classicHorizontal ? 480 : 400
            return popover(isPresented: isPresented) {
                AboutView(
                    content: content,
                    contentType: contentType,
                    appName: appName,
                    version: version,
                    copyright: copyright,
                    headerOptions: headerOptions,
                    licenseResourceName: licenseResourceName,
                    acknowledgementsResourceName: acknowledgementsResourceName,
                    resourceBundle: resourceBundle
                )
                .frame(width: popoverWidth, height: 500)
            }
        }
    }
#endif
