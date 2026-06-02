import SwiftUI
import SwiftData

struct SubscriptionRow: View {
    let subscription: Subscription
    
    private var daysUntilBilling: Int {
        Calendar.current.dateComponents([.day], from: .now, to: subscription.nextBillingDate).day ?? 0
    }
    
    private var billingSubtitle: String {
        if !subscription.isActive { return "В архиве" }
        if daysUntilBilling < 0 { return "Списание просрочено" }
        if daysUntilBilling == 0 { return "Списание сегодня" }
        if daysUntilBilling == 1 { return "Завтра списание" }
        return "Через \(daysUntilBilling) дн. · \(subscription.nextBillingDate.formatted(.dateTime.day().month()))"
    }
    
    private var urgencyColor: Color {
        guard subscription.isActive else { return .secondary }
        if daysUntilBilling <= 1 { return .orange }
        if daysUntilBilling <= 3 { return .yellow }
        return .secondary
    }
    
    var body: some View {
        HStack(spacing: 16) {
            BrandLogoView(subscription: subscription)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(subscription.name)
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    if subscription.isActive && daysUntilBilling <= 3 {
                        Circle()
                            .fill(urgencyColor)
                            .frame(width: 6, height: 6)
                    }
                    Text(billingSubtitle)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(urgencyColor.opacity(subscription.isActive ? 1 : 0.7))
                }
            }
            
            Spacer(minLength: 8)
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(subscription.price)) \(subscription.currency)")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                Text(subscription.cycle == "Месяц" ? "/ мес" : "/ год")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.white.opacity(0.45))
            }
        }
        .padding(16)
        .glassCard(cornerRadius: 20)
        .opacity(subscription.isActive ? 1 : 0.72)
    }
}
