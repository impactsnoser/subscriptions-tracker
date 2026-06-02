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
    
    private var lite: Bool { AppPerformance.useLiteEffects }
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background {
                Group {
                    if lite {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.11),
                                        Color.white.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    } else {
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
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(Color.white.opacity(lite ? 0.14 : 0.22), lineWidth: 1)
                )
            }
            .shadow(
                color: AppTheme.glow.opacity(lite ? 0.08 : 0.15),
                radius: lite ? 8 : 16,
                y: lite ? 4 : 8
            )
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 20, padding: CGFloat = 0) -> some View {
        modifier(GlassCard(cornerRadius: cornerRadius, padding: padding))
    }
}
