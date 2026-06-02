import SwiftUI

struct BrandLogoView: View {
    let subscription: Subscription
    var size: CGFloat = 44
    
    private var brand: SubscriptionBrand? { subscription.matchedBrand }
    private var style: (icon: String, color: Color) { subscription.brandStyle }
    
    var body: some View {
        Group {
            if let brand {
                BrandArtwork(brand: brand, size: size)
            } else {
                Image(systemName: style.icon)
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: size, height: size)
                    .background(style.color.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
    }
}
