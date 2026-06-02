import SwiftUI
import SwiftData

struct SubscriptionRow: View {
    let subscription: Subscription
    
    var body: some View {
        HStack(spacing: 16) {
            BrandLogoView(subscription: subscription)
            
            // Название и дата
            VStack(alignment: .leading, spacing: 4) {
                Text(subscription.name)
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                
                if subscription.isActive {
                    Text("Списание: \(subscription.nextBillingDate.formatted(.dateTime.day().month().year()))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("В архиве")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Цена
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(subscription.price)) \(subscription.currency)")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                Text(subscription.cycle == "Месяц" ? "/ мес" : "/ год")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}