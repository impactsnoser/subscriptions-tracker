import SwiftUI
import UIKit

enum AppTheme {
    static let accent = Color(red: 0.45, green: 0.35, blue: 1.0)
    static let accentSecondary = Color(red: 0.95, green: 0.35, blue: 0.65)
    static let glow = Color(red: 0.55, green: 0.45, blue: 1.0)
    
    static let cardFill = Color.white.opacity(0.07)
    static let cardStroke = Color.white.opacity(0.14)
    
    static let spring = Animation.spring(response: 0.48, dampingFraction: 0.78, blendDuration: 0.15)
    static let springBouncy = Animation.spring(response: 0.55, dampingFraction: 0.68)
    static let smooth = Animation.smooth(duration: 0.35)
}

enum Haptics {
    static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    static func medium() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    static func soft() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
}

struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat = 20
    var padding: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.12),
                                        Color.white.opacity(0.03)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.35),
                                        Color.white.opacity(0.06),
                                        Color.white.opacity(0.02)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            }
            .shadow(color: AppTheme.glow.opacity(0.15), radius: 20, y: 10)
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 20, padding: CGFloat = 0) -> some View {
        modifier(GlassCard(cornerRadius: cornerRadius, padding: padding))
    }
}
