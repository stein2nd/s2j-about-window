@testable import S2JAboutWindow
import Testing

struct AboutContentFormatTests {
    @Test
    func `automatic detects markdown`() {
        #expect(AboutContentType.effective(for: "# Title\n\nBody") == .markdown)
    }

    @Test
    func `automatic detects JSON`() {
        let json = """
        {"name":"About","version":1}
        """
        #expect(AboutContentType.effective(for: json) == .json)
    }

    @Test
    func `explicit markdown ignores JSON shape`() {
        let jsonShaped = #"{"not":"parsed"}"#
        #expect(AboutContentType.effective(for: jsonShaped, requested: .markdown) == .markdown)
    }

    @Test
    func `pretty printed JSON sorts keys`() throws {
        let input = #"{"z":1,"a":2}"#
        let pretty = try #require(AboutContentFormat.prettyPrintedJSON(from: input))
        #expect(pretty.contains("\"a\""))
        #expect(pretty.contains("\"z\""))
    }

    @Test
    func `invalid JSON falls back to markdown when automatic`() {
        let broken = "{ not valid json"
        #expect(AboutContentType.effective(for: broken) == .markdown)
    }

    @Test
    func `explicit JSON when invalid`() {
        let broken = "{ not valid json"
        #expect(AboutContentType.effective(for: broken, requested: .json) == .json)
    }

    @Test
    func `automatic detects RTF`() {
        let rtf = "{\\rtf1\\ansi Hello}"
        #expect(AboutContentType.effective(for: rtf) == .rtf)
    }

    @Test
    func `explicit RTF`() {
        let rtf = "{\\rtf1\\ansi Hello}"
        #expect(AboutContentType.effective(for: rtf, requested: .rtf) == .rtf)
    }
}
