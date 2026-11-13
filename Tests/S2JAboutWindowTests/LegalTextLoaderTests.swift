import Foundation
import S2JAboutWindow
import Testing

private final class LegalTextLoaderTestsBundleMarker: NSObject {}

private enum LegalTextLoaderTestsBundle {
    static var current: Bundle {
        #if SWIFT_PACKAGE
            Bundle.module
        #else
            Bundle(for: LegalTextLoaderTestsBundleMarker.self)
        #endif
    }
}

@Suite("LegalTextLoader")
struct LegalTextLoaderTests {
    private var testBundle: Bundle {
        LegalTextLoaderTestsBundle.current
    }

    @Test func `loads license via default extension order`() {
        let result = LegalTextLoader.load(
            bundle: testBundle,
            resourceName: "FixtureLicense",
            kind: .license
        )

        if case let .plainText(text) = result.content {
            #expect(text.contains("Sample bundled license"))
        } else {
            Issue.record("Expected plainText, got \(result.content)")
        }
        #expect(result.resolvedFileExtension == "txt")
    }

    @Test func `loads license with explicit txt preference`() {
        let result = LegalTextLoader.load(
            bundle: testBundle,
            resourceName: "FixtureLicenseAlt",
            kind: .license,
            preferredExtensions: ["txt"]
        )

        if case let .plainText(text) = result.content {
            #expect(text.contains("alternate txt"))
        } else {
            Issue.record("Expected plainText from txt")
        }
    }

    @Test func `empty license file returns empty`() {
        let result = LegalTextLoader.load(
            bundle: testBundle,
            resourceName: "FixtureLicenseEmpty",
            kind: .license
        )

        #expect(result.content == .empty)
    }

    @Test func `missing resource returns load failed`() {
        let result = LegalTextLoader.load(
            bundle: testBundle,
            resourceName: "FixtureMissingLicense",
            kind: .license
        )

        #expect(result.content == .loadFailed)
    }

    @Test func `loads acknowledgements markdown`() {
        let result = LegalTextLoader.load(
            bundle: testBundle,
            resourceName: "FixtureAcknowledgements.md",
            kind: .acknowledgements
        )

        if case let .plainText(text) = result.content {
            #expect(text.contains("OSS Notice"))
            #expect(text.contains("| Name | Version | License | Copyright |"))
        } else {
            Issue.record("Expected markdown acknowledgements text")
        }
        #expect(result.resolvedFileExtension == "md")
        #expect(LegalTextLoader.usesMarkdownRendering(kind: .acknowledgements, result: result))
    }

    @Test func `license does not use markdown rendering`() {
        let result = LegalTextLoader.load(
            bundle: testBundle,
            resourceName: "FixtureLicense",
            kind: .license
        )

        #expect(!LegalTextLoader.usesMarkdownRendering(kind: .license, result: result))
    }
}
