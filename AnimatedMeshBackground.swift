import SwiftUI

struct AnimatedMeshBackground: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    private var useStaticBackground: Bool {
        AppPerformance.useLiteEffects || reduceMotion
    }
    
    var body: some View {
        Group {
            if useStaticBackground {
                staticBackground
            } else {
                animatedBackground
            }
        }
        .ignoresSafeArea()
    }
    
    private var staticBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.10, green: 0.07, blue: 0.22),
                    Color(red: 0.14, green: 0.08, blue: 0.26),
                    Color(red: 0.05, green: 0.05, blue: 0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            RadialGradient(
                colors: [AppTheme.accent.opacity(0.4), .clear],
                center: .topLeading,
                startRadius: 20,
                endRadius: 320
            )
            
            RadialGradient(
                colors: [AppTheme.accentSecondary.opacity(0.3), .clear],
                center: .bottomTrailing,
                startRadius: 10,
                endRadius: 280
            )
        }
    }
    
    private var animatedBackground: some View {
        TimelineView(.animation(minimumInterval: 1 / 20)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            
            Canvas { context, size in
                context.fill(
                    Path(CGRect(origin: .zero, size: size)),
                    with: .linearGradient(
                        Gradient(colors: [
                            Color(red: 0.12, green: 0.08, blue: 0.28),
                            Color(red: 0.05, green: 0.05, blue: 0.12)
                        ]),
                        startPoint: .zero,
                        endPoint: CGPoint(x: size.width, y: size.height)
                    )
                )
                
                drawOrb(context: context, size: size, t: t, index: 0, color: AppTheme.accent.opacity(0.5))
                drawOrb(context: context, size: size, t: t, index: 1, color: AppTheme.accentSecondary.opacity(0.4))
            }
        }
    }
    
    private func drawOrb(context: GraphicsContext, size: CGSize, t: TimeInterval, index: Int, color: Color) {
        let offset = Double(index) * 2.1
        let x = size.width * (0.5 + 0.35 * cos(t * 0.35 + offset))
        let y = size.height * (0.35 + 0.25 * sin(t * 0.28 + offset * 1.3))
        let radius = min(size.width, size.height) * (0.35 + 0.08 * sin(t * 0.5 + offset))
        
        let rect = CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)
        context.fill(
            Path(ellipseIn: rect),
            with: .radialGradient(
                Gradient(colors: [color, color.opacity(0)]),
                center: CGPoint(x: rect.midX, y: rect.midY),
                startRadius: 0,
                endRadius: radius
            )
        )
    }
}
