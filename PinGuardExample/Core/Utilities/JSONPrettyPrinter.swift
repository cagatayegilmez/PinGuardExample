import Foundation

/// Formats response payloads for UI display.
enum JSONPrettyPrinter {
    /// Returns pretty-printed JSON if possible; otherwise falls back to UTF-8 text.
    static func stringify(_ data: Data) -> String {
        if
            let jsonObject = try? JSONSerialization.jsonObject(with: data),
            let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys]),
            let prettyString = String(data: prettyData, encoding: .utf8)
        {
            return prettyString
        }

        if let stringValue = String(data: data, encoding: .utf8), !stringValue.isEmpty {
            return stringValue
        }

        return "<empty response>"
    }
}
