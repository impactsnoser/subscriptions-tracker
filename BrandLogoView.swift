import SwiftUI

struct BrandLogoView: View {
    let subscription: Subscription
    var size: CGFloat = 44
    var animate: Bool = true
    
    @State private var glow = false
    
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
        .shadow(color: (brand?.accentColor ?? style.color).opacity(glow ? 0.55 : 0.25), radius: glow ? 14 : 6)
        .onAppear {
            guard animate else { return }
            withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                glow = true
            }
        }
    }
}
