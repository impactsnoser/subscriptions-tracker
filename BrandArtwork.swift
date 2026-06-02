import SwiftUI

/// Узнаваемые мини-логотипы популярных подписок в РФ (векторная отрисовка, без внешних ассетов)
struct BrandArtwork: View {
    let brand: SubscriptionBrand
    var size: CGFloat = 44
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(background)
            
            foreground
        }
        .frame(width: size, height: size)
    }
    
    private var background: some ShapeStyle {
        switch brand {
        case .google:
            return AnyShapeStyle(Color.white)
        case .apple:
            return AnyShapeStyle(LinearGradient(colors: [.pink, .purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
        default:
            return AnyShapeStyle(brand.accentColor.gradient)
        }
    }
    
    @ViewBuilder
    private var foreground: some View {
        switch brand {
        case .telegram:
            Image(systemName: "paperplane.fill")
                .font(.system(size: size * 0.38, weight: .semibold))
                .foregroundStyle(.white)
                .rotationEffect(.degrees(-45))
                .offset(x: -1, y: 1)
            
        case .yandex:
            Text("Я")
                .font(.system(size: size * 0.52, weight: .black, design: .rounded))
                .foregroundStyle(.white)
            
        case .kinopoisk:
            Text("K")
                .font(.system(size: size * 0.48, weight: .black, design: .rounded))
                .foregroundStyle(.white)
            
        case .vk:
            Text("VK")
                .font(.system(size: size * 0.28, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
            
        case .youtube:
            ZStack {
                RoundedRectangle(cornerRadius: 3)
                    .fill(.white)
                    .frame(width: size * 0.42, height: size * 0.30)
                Image(systemName: "play.fill")
                    .font(.system(size: size * 0.16, weight: .bold))
                    .foregroundStyle(.red)
                    .offset(x: size * 0.02)
            }
            
        case .spotify:
            SpotifyMark()
                .stroke(.white, style: StrokeStyle(lineWidth: size * 0.055, lineCap: .round))
                .frame(width: size * 0.5, height: size * 0.5)
            
        case .netflix:
            Text("N")
                .font(.system(size: size * 0.5, weight: .black, design: .default))
                .foregroundStyle(.white)
                .italic()
            
        case .apple:
            Image(systemName: "apple.logo")
                .font(.system(size: size * 0.42, weight: .medium))
                .foregroundStyle(.white)
            
        case .google:
            GoogleMark(size: size * 0.55)
            
        case .ivi:
            brandText("ivi", size: size * 0.34)
            
        case .okko:
            brandText("okko", size: size * 0.28)
            
        case .sber:
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: size * 0.4))
                .foregroundStyle(.white)
            
        case .tinkoff:
            brandText("T", size: size * 0.46)
            
        case .ozon:
            brandText("OZ", size: size * 0.3)
            
        case .wildberries:
            brandText("WB", size: size * 0.3)
            
        case .playstation:
            Text("PS")
                .font(.system(size: size * 0.3, weight: .black, design: .rounded))
                .foregroundStyle(.white)
            
        case .xbox:
            Image(systemName: "xbox.logo")
                .font(.system(size: size * 0.38))
                .foregroundStyle(.white)
            
        case .nintendo:
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: size * 0.34))
                .foregroundStyle(.white)
            
        case .microsoft:
            MicrosoftMark(grid: size * 0.2)
            
        case .zoom:
            brandText("zoom", size: size * 0.26)
            
        case .notion:
            Text("N")
                .font(.system(size: size * 0.46, weight: .semibold, design: .serif))
                .foregroundStyle(.white)
                .padding(.bottom, 2)
            
        case .openai, .chatgpt:
            Image(systemName: "sparkles")
                .font(.system(size: size * 0.36, weight: .semibold))
                .foregroundStyle(.white)
            
        case .discord:
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: size * 0.32))
                .foregroundStyle(.white)
            
        case .steam:
            Image(systemName: "circle.hexagongrid.fill")
                .font(.system(size: size * 0.36))
                .foregroundStyle(.white)
            
        case .epicgames:
            brandText("EPIC", size: size * 0.22)
            
        case .github:
            Image(systemName: "cat.fill")
                .font(.system(size: size * 0.34))
                .foregroundStyle(.white)
            
        case .dropbox:
            Image(systemName: "archivebox.fill")
                .font(.system(size: size * 0.34))
                .foregroundStyle(.white)
            
        case .adguard:
            Image(systemName: "shield.checkered")
                .font(.system(size: size * 0.36))
                .foregroundStyle(.white)
            
        case .nordvpn:
            brandText("N", size: size * 0.44)
            
        case .protonvpn:
            brandText("P", size: size * 0.44)
            
        case .megafon:
            brandText("M", size: size * 0.44)
            
        case .mts:
            brandText("MTS", size: size * 0.24)
            
        case .amazon:
            VStack(spacing: 0) {
                Image(systemName: "arrow.right")
                    .font(.system(size: size * 0.22, weight: .bold))
                Image(systemName: "arrow.right")
                    .font(.system(size: size * 0.28, weight: .bold))
            }
            .foregroundStyle(Color(red: 0.12, green: 0.12, blue: 0.15))
            
        case .linkedin:
            Text("in")
                .font(.system(size: size * 0.34, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal, 4)
                .background(Circle().fill(Color.white.opacity(0.25)))
            
        case .duolingo:
            Image(systemName: "owl.fill")
                .font(.system(size: size * 0.36))
                .foregroundStyle(.white)
            
        case .rutube:
            Image(systemName: "play.circle.fill")
                .font(.system(size: size * 0.4))
                .foregroundStyle(.white)
            
        case .dzen:
            brandText("Д", size: size * 0.46)
            
        case .wink:
            brandText("W", size: size * 0.44)
            
        case .kion:
            brandText("K", size: size * 0.44)
            
        case .premier:
            brandText("P", size: size * 0.44)
            
        case .start:
            brandText("S", size: size * 0.44)
            
        case .litres:
            Image(systemName: "book.closed.fill")
                .font(.system(size: size * 0.34))
                .foregroundStyle(.white)
        }
    }
    
    private func brandText(_ text: String, size: CGFloat) -> some View {
        Text(text)
            .font(.system(size: size, weight: .heavy, design: .rounded))
            .foregroundStyle(.white)
            .minimumScaleFactor(0.5)
            .lineLimit(1)
    }
}

// MARK: - Вспомогательные формы

private struct SpotifyMark: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        path.move(to: CGPoint(x: w * 0.1, y: h * 0.72))
        path.addQuadCurve(to: CGPoint(x: w * 0.95, y: h * 0.55), control: CGPoint(x: w * 0.55, y: h * 0.95))
        path.move(to: CGPoint(x: w * 0.05, y: h * 0.48))
        path.addQuadCurve(to: CGPoint(x: w * 0.95, y: h * 0.28), control: CGPoint(x: w * 0.5, y: h * 0.72))
        path.move(to: CGPoint(x: w * 0.0, y: h * 0.24))
        path.addQuadCurve(to: CGPoint(x: w * 0.95, y: h * 0.02), control: CGPoint(x: w * 0.45, y: h * 0.48))
        return path
    }
}

private struct GoogleMark: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Circle().fill(Color(red: 0.26, green: 0.52, blue: 0.96)).frame(width: size * 0.28).offset(x: -size * 0.12, y: -size * 0.1)
            Circle().fill(Color(red: 0.98, green: 0.26, blue: 0.21)).frame(width: size * 0.28).offset(x: size * 0.12, y: -size * 0.1)
            Circle().fill(Color(red: 0.98, green: 0.75, blue: 0.18)).frame(width: size * 0.28).offset(x: -size * 0.12, y: size * 0.14)
            Circle().fill(Color(red: 0.15, green: 0.65, blue: 0.35)).frame(width: size * 0.28).offset(x: size * 0.12, y: size * 0.14)
        }
        .frame(width: size, height: size)
    }
}

private struct MicrosoftMark: View {
    let grid: CGFloat
    
    var body: some View {
        VStack(spacing: grid * 0.15) {
            HStack(spacing: grid * 0.15) {
                square(.red)
                square(.green)
            }
            HStack(spacing: grid * 0.15) {
                square(.blue)
                square(.yellow)
            }
        }
    }
    
    private func square(_ color: Color) -> some View {
        RoundedRectangle(cornerRadius: 1)
            .fill(color)
            .frame(width: grid, height: grid)
    }
}
