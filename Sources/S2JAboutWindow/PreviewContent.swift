#if DEBUG
    import Foundation

    /// Loads markdown from the repository `Preview Content/` folder (Xcode `SRCROOT`) for Canvas previews.
    enum PreviewContent {
        private static let subdirectory = "Preview Content"

        static func markdown(named name: String) -> String {
            if let url = urlForPreviewFile(name: name, extension: "md"),
               let text = try? String(contentsOf: url, encoding: .utf8),
               !text.isEmpty
            {
                return text
            }
            return "# Preview\n\n\(name).md is not on disk; using fallback."
        }

        private static func urlForPreviewFile(name: String, extension ext: String) -> URL? {
            let fileName = "\(name).\(ext)"
            if let srcRoot = ProcessInfo.processInfo.environment["SRCROOT"] {
                let candidate = URL(fileURLWithPath: srcRoot)
                    .appendingPathComponent(subdirectory, isDirectory: true)
                    .appendingPathComponent(fileName)
                if FileManager.default.fileExists(atPath: candidate.path) {
                    return candidate
                }
            }

            // SwiftPM / CLI: repo root is a few levels above this source file
            var directory = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
            for _ in 0 ..< 6 {
                let candidate = directory
                    .appendingPathComponent(subdirectory, isDirectory: true)
                    .appendingPathComponent(fileName)
                if FileManager.default.fileExists(atPath: candidate.path) {
                    return candidate
                }
                let parent = directory.deletingLastPathComponent()
                if parent.path == directory.path {
                    break
                }
                directory = parent
            }
            return nil
        }
    }
#endif
