import Foundation

// Hexadecimal string initializer for UnifiedColor. This provides a convenient
// and industry-standard way for designers and developers to define colors.
public extension UnifiedColor {
    init(hex: String) {
        let hexStr = hex.trimmingCharacters(in: .whitespacesAndNewlines).dropFirst(hex.hasPrefix("#") ? 1 : 0)
        var hexValue: UInt64 = 0
        guard Scanner(string: String(hexStr)).scanHexInt64(&hexValue) else {
            self.init(red: 0, green: 0, blue: 0); return
        }

        let r, g, b, a: Double
        switch hexStr.count {
        case 3: // RGB (e.g., "F0C")
            r = Double((hexValue & 0xF00) >> 8) / 15.0
            g = Double((hexValue & 0x0F0) >> 4) / 15.0
            b = Double(hexValue & 0x00F) / 15.0
            a = 1.0
        case 6: // RRGGBB (e.g., "FF00CC")
            r = Double((hexValue & 0xFF0000) >> 16) / 255.0
            g = Double((hexValue & 0x00FF00) >> 8) / 255.0
            b = Double(hexValue & 0x0000FF) / 255.0
            a = 1.0
        case 8: // RRGGBBAA (e.g., "FF00CC80")
            r = Double((hexValue & 0xFF000000) >> 24) / 255.0
            g = Double((hexValue & 0x00FF0000) >> 16) / 255.0
            b = Double((hexValue & 0x0000FF00) >> 8) / 255.0
            a = Double(hexValue & 0x000000FF) / 255.0
        default:
            (r, g, b, a) = (0, 0, 0, 1)
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
