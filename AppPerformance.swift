import UIKit

/// Оптимизация для iPhone X / XS / XR и режима энергосбережения
enum AppPerformance {
    static var useLiteEffects: Bool {
        if ProcessInfo.processInfo.isLowPowerModeEnabled { return true }
        return UIDevice.current.isLegacyPerformanceTier
    }
}

private extension UIDevice {
    var machineIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        return mirror.children.reduce(into: "") { result, element in
            guard let value = element.value as? Int8, value != 0 else { return }
            result.append(String(UnicodeScalar(UInt8(value))))
        }
    }
    
    /// iPhone 8 и новее до XS/XR включительно (A11–A12)
    var isLegacyPerformanceTier: Bool {
        let id = machineIdentifier
        if id == "i386" || id == "x86_64" || id.hasPrefix("arm64") { return false }
        if id.hasPrefix("iPhone8") { return true }
        if id.hasPrefix("iPhone9") { return true }
        if id.hasPrefix("iPhone10") { return true }
        if id.hasPrefix("iPhone11") { return true }
        return false
    }
}
