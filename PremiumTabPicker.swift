import SwiftUI

struct PremiumTabPicker: View {
    @Binding var selection: Int
    let archiveCount: Int
    
    @Namespace private var tabNamespace
    
    var body: some View {
        HStack(spacing: 0) {
            tabButton(title: "Активные", tag: 0, icon: "bolt.fill")
            tabButton(title: "Архив", tag: 1, icon: "archivebox.fill", badge: archiveCount)
        }
        .padding(5)
        .glassCard(cornerRadius: 18, padding: 0)
        .padding(.horizontal, 16)
    }
    
    private func tabButton(title: String, tag: Int, icon: String, badge: Int = 0) -> some View {
        Button {
            guard selection != tag else { return }
            Haptics.light()
            withAnimation(AppTheme.spring) {
                selection = tag
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.caption.weight(.bold))
                    .symbolEffect(.bounce, value: selection == tag)
                
                Text(title)
                    .font(.subheadline.weight(.semibold))
                
                if badge > 0 {
                    Text("\(badge)")
                        .font(.caption2.weight(.bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(.white.opacity(selection == tag ? 0.25 : 0.12)))
                }
            }
            .foregroundStyle(selection == tag ? .white : .white.opacity(0.55))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background {
                if selection == tag {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [AppTheme.accent, AppTheme.accentSecondary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .matchedGeometryEffect(id: "tab", in: tabNamespace)
                        .shadow(color: AppTheme.glow.opacity(0.45), radius: 12, y: 4)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
