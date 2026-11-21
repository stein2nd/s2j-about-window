import Foundation
import SwiftUI

#if canImport(SwiftUI)
    /**
     * iPadOS向けのExtensions
     * @return Extensions
     */
    @ViewBuilder
    private func aboutSheetNavigationContent(
        isPresented: Binding<Bool>,
        content: String,
        appName: String?,
        version: String?,
        copyright: String?,
        licenseResourceName: String?,
        acknowledgementsResourceName: String?,
        resourceBundle: Bundle
    ) -> some View {
        NavigationView {
            AboutView(
                content: content,
                appName: appName,
                version: version,
                copyright: copyright,
                licenseResourceName: licenseResourceName,
                acknowledgementsResourceName: acknowledgementsResourceName,
                resourceBundle: resourceBundle
            )
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
         * @param appName: アプリ名
         * @param version: バージョン
         * @param copyright: 著作権情報
         * @return some View
         */
        func aboutSheet(
            isPresented: Binding<Bool>,
            content: String,
            appName: String? = nil,
            version: String? = nil,
            copyright: String? = nil,
            licenseResourceName: String? = nil,
            acknowledgementsResourceName: String? = nil,
            resourceBundle: Bundle = .main
        ) -> some View {
            sheet(isPresented: isPresented) {
                aboutSheetNavigationContent(
                    isPresented: isPresented,
                    content: content,
                    appName: appName,
                    version: version,
                    copyright: copyright,
                    licenseResourceName: licenseResourceName,
                    acknowledgementsResourceName: acknowledgementsResourceName,
                    resourceBundle: resourceBundle
                )
            }
        }

        /**
         * iPadOS向けのPopover表示用のAboutView
         * @param isPresented: 表示状態
         * @param content: 表示するコンテンツ（Markdown、JSON、RTF）
         * @param appName: アプリ名
         * @param version: バージョン
         * @param copyright: 著作権情報
         * @return some View
         */
        func aboutPopover(
            isPresented: Binding<Bool>,
            content: String,
            appName: String? = nil,
            version: String? = nil,
            copyright: String? = nil,
            licenseResourceName: String? = nil,
            acknowledgementsResourceName: String? = nil,
            resourceBundle: Bundle = .main
        ) -> some View {
            popover(isPresented: isPresented) {
                AboutView(
                    content: content,
                    appName: appName,
                    version: version,
                    copyright: copyright,
                    licenseResourceName: licenseResourceName,
                    acknowledgementsResourceName: acknowledgementsResourceName,
                    resourceBundle: resourceBundle
                )
                .frame(width: 400, height: 500)
            }
        }
    }
#endif
