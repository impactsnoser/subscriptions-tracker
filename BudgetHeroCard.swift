import SwiftUI

struct BudgetHeroCard: View {
    let totalMonthly: Double
    let activeCount: Int
    
    @State private var displayedAmount: Double = 0
    @State private var shimmer: CGFloat = -1
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label("Траты в месяц", systemImage: "chart.line.uptrend.xyaxis")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.75))
                Spacer()
                Text("\(activeCount) активных")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.white.opacity(0.5))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(.white.opacity(0.1)))
            }
            
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(formattedAmount(displayedAmount))
                    .font(.system(size: 44, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.85)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .contentTransition(.numericText(value: displayedAmount))
                
                Text("₽")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(AppTheme.accentSecondary)
                    .offset(y: -4)
            }
            
            if activeCount > 0 {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.white.opacity(0.08))
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [AppTheme.accent, AppTheme.accentSecondary],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(geo.size.width * budgetBarProgress, 12))
                            .shadow(color: AppTheme.glow.opacity(0.6), radius: 8)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding(22)
        .glassCard(cornerRadius: 28)
        .overlay {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.clear, .white.opacity(0.15), .clear],
                        startPoint: UnitPoint(x: shimmer, y: 0),
                        endPoint: UnitPoint(x: shimmer + 0.35, y: 1)
                    )
                )
                .allowsHitTesting(false)
        }
        .padding(.horizontal, 16)
        .onAppear {
            animateAmount(to: totalMonthly)
            withAnimation(.linear(duration: 2.8).repeatForever(autoreverses: false)) {
                shimmer = 1.4
            }
        }
        .onChange(of: totalMonthly) { _, newValue in
            animateAmount(to: newValue)
        }
    }
    
    private var budgetBarProgress: CGFloat {
        let cap: Double = 15_000
        return CGFloat(min(totalMonthly / cap, 1))
    }
    
    private func formattedAmount(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.groupingSeparator = " "
        return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value))"
    }
    
    private func animateAmount(to value: Double) {
        withAnimation(AppTheme.springBouncy) {
            displayedAmount = value
        }
    }
}
