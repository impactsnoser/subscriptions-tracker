import SwiftUI

struct AnimatedMeshBackground: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            
            Canvas { context, size in
                let colors: [Color] = [
                    Color(red: 0.12, green: 0.08, blue: 0.28),
                    Color(red: 0.22, green: 0.10, blue: 0.38),
                    Color(red: 0.08, green: 0.14, blue: 0.32),
                    Color(red: 0.18, green: 0.06, blue: 0.22)
                ]
                
                context.fill(
                    Path(CGRect(origin: .zero, size: size)),
                    with: .linearGradient(
                        Gradient(colors: [colors[0], Color(red: 0.05, green: 0.05, blue: 0.12)]),
                        startPoint: .zero,
                        endPoint: CGPoint(x: size.width, y: size.height)
                    )
                )
                
                drawOrb(context: context, size: size, t: t, index: 0, color: AppTheme.accent.opacity(0.55))
                drawOrb(context: context, size: size, t: t, index: 1, color: AppTheme.accentSecondary.opacity(0.45))
                drawOrb(context: context, size: size, t: t, index: 2, color: Color.cyan.opacity(0.25))
            }
        }
        .ignoresSafeArea()
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
