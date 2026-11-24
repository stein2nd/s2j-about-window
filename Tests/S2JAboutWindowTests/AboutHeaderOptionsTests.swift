import Foundation
@testable import S2JAboutWindow
import Testing

struct AboutHeaderOptionsTests {
    @Test
    func `version line without build`() {
        let line = AboutVersionDisplay.formattedLine(
            marketingVersion: "1.0.23",
            showBuildNumber: false,
            buildNumber: "99",
            buildNumberOverride: nil,
            versionLabel: "Version"
        )
        #expect(line == "Version 1.0.23")
    }

    @Test
    func `version line with build from bundle`() {
        let line = AboutVersionDisplay.formattedLine(
            marketingVersion: "1.0.23",
            showBuildNumber: true,
            buildNumber: "4",
            buildNumberOverride: nil,
            versionLabel: "Version"
        )
        #expect(line == "Version 1.0.23 (4)")
    }

    @Test
    func `version line with build override`() {
        let line = AboutVersionDisplay.formattedLine(
            marketingVersion: "3.6.5",
            showBuildNumber: true,
            buildNumber: "ignored",
            buildNumberOverride: "24380",
            versionLabel: "Version"
        )
        #expect(line == "Version 3.6.5 (24380)")
    }

    @Test
    func `primary link requires title and URL`() {
        var options = AboutHeaderOptions(
            primaryLinkTitle: "  ",
            primaryLinkURL: URL(string: "https://example.com")
        )
        #expect(options.resolvedPrimaryLink == nil)

        options = AboutHeaderOptions(
            primaryLinkTitle: "GitHub",
            primaryLinkURL: URL(string: "https://github.com/stein2nd/s2j-about-window")
        )
        #expect(options.resolvedPrimaryLink?.title == "GitHub")
    }

    @Test
    func `default header options are vertical`() {
        #expect(AboutHeaderOptions.default.style == .vertical)
        #expect(AboutHeaderOptions.default.showBuildNumber == false)
    }
}
