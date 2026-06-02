import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Subscription.name) private var allSubscriptions: [Subscription]
    
    @State private var showingAddSheet = false
    @State private var selectedTab = 0
    @State private var appeared = false
    
    var activeSubscriptions: [Subscription] {
        allSubscriptions.filter { $0.isActive }
    }
    
    var archivedSubscriptions: [Subscription] {
        allSubscriptions.filter { !$0.isActive }
    }
    
    private var shouldGroupActiveByCategory: Bool {
        activeSubscriptions.count > 3
    }
    
    private var groupedActiveSubscriptions: [(category: SubscriptionCategory, items: [Subscription])] {
        let grouped = Dictionary(grouping: activeSubscriptions) { subscription in
            SubscriptionCategory(rawValue: subscription.category) ?? .other
        }
        return SubscriptionCategory.allCases.compactMap { category in
            guard let items = grouped[category] else { return nil }
            let sorted = items.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
            return (category: category, items: sorted)
        }
    }
    
    var totalMonthlyExpenses: Double {
        activeSubscriptions.reduce(0) { sum, sub in
            if sub.cycle == "Год" {
                return sum + (sub.price / 12.0)
            } else {
                return sum + sub.price
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedMeshBackground()
                
                VStack(spacing: 0) {
                    PremiumTabPicker(selection: $selectedTab, archiveCount: archivedSubscriptions.count)
                        .padding(.top, 8)
                        .padding(.bottom, 12)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : -12)
                    
                    ZStack {
                        if selectedTab == 0 {
                            activeTabContent
                                .transition(.asymmetric(
                                    insertion: .move(edge: .leading).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                        } else {
                            archiveTabContent
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .trailing).combined(with: .opacity)
                                ))
                        }
                    }
                    .animation(AppTheme.spring, value: selectedTab)
                }
            }
            .navigationTitle("Подписки")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Haptics.medium()
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.body.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [AppTheme.accent, AppTheme.accentSecondary],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: AppTheme.glow.opacity(0.5), radius: 10, y: 4)
                            }
                            .symbolEffect(.bounce, value: showingAddSheet)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddSubscriptionView()
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(28)
            }
            .onAppear {
                withAnimation(AppTheme.springBouncy.delay(0.05)) {
                    appeared = true
                }
            }
        }
    }
    
    // MARK: - Активные
    
    @ViewBuilder
    private var activeTabContent: some View {
        VStack(spacing: 12) {
            BudgetHeroCard(totalMonthly: totalMonthlyExpenses, activeCount: activeSubscriptions.count)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)
            
            if activeSubscriptions.isEmpty {
                emptyState(
                    title: "Пока пусто",
                    subtitle: "Добавь первую подписку — посчитаем траты за тебя",
                    icon: "sparkles"
                )
            } else {
                List {
                    if shouldGroupActiveByCategory {
                        ForEach(groupedActiveSubscriptions, id: \.category) { group in
                            Section {
                                ForEach(group.items) { subscription in
                                    activeSubscriptionRow(subscription)
                                }
                            } header: {
                                categorySectionHeader(group.category, count: group.items.count)
                            }
                        }
                    } else {
                        ForEach(activeSubscriptions) { subscription in
                            activeSubscriptionRow(subscription)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .listSectionSeparator(.hidden)
                .listRowSeparator(.hidden)
                .environment(\.defaultMinListRowHeight, 1)
            }
        }
    }
    
    // MARK: - Архив
    
    @ViewBuilder
    private var archiveTabContent: some View {
        if archivedSubscriptions.isEmpty {
            emptyState(
                title: "Архив пуст",
                subtitle: "Отключённые подписки появятся здесь",
                icon: "archivebox"
            )
        } else {
            List {
                ForEach(archivedSubscriptions) { subscription in
                    archivedSubscriptionRow(subscription)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
            .environment(\.defaultMinListRowHeight, 1)
        }
    }
    
    // MARK: - Компоненты
    
    private func emptyState(title: String, subtitle: String, icon: String) -> some View {
        VStack(spacing: 20) {
            Spacer()
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [AppTheme.accent.opacity(0.35), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 140, height: 140)
                
                Image(systemName: icon)
                    .font(.system(size: 48, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppTheme.accent, AppTheme.accentSecondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .symbolEffect(.pulse.byLayer, options: AppPerformance.useLiteEffects ? .nonRepeating : .repeating)
            }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            Spacer()
        }
        .frame(maxHeight: .infinity)
    }
    
    private func categorySectionHeader(_ category: SubscriptionCategory, count: Int) -> some View {
        HStack(spacing: 10) {
            Image(systemName: categoryIcon(category))
                .font(.caption.weight(.bold))
                .foregroundStyle(categoryAccent(category))
                .frame(width: 28, height: 28)
                .background(categoryAccent(category).opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            
            Text(category.rawValue)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white.opacity(0.85))
            
            Spacer()
            
            Text("\(count)")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.white.opacity(0.7))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Capsule().fill(.white.opacity(0.1)))
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
        .textCase(nil)
    }
    
    private func categoryIcon(_ category: SubscriptionCategory) -> String {
        switch category {
        case .entertainment: return "popcorn.fill"
        case .work: return "briefcase.fill"
        case .gaming: return "gamecontroller.fill"
        case .vpn: return "shield.fill"
        case .utility: return "wrench.and.screwdriver.fill"
        case .other: return "square.grid.2x2.fill"
        }
    }
    
    private func categoryAccent(_ category: SubscriptionCategory) -> Color {
        switch category {
        case .entertainment: return .cyan
        case .work: return .orange
        case .gaming: return .green
        case .vpn: return .indigo
        case .utility: return .mint
        case .other: return .secondary
        }
    }
    
    @ViewBuilder
    private func activeSubscriptionRow(_ subscription: Subscription) -> some View {
        SubscriptionRow(subscription: subscription)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    Haptics.medium()
                    withAnimation(AppTheme.spring) {
                        modelContext.delete(subscription)
                    }
                } label: {
                    Label("Удалить", systemImage: "trash")
                }
                
                Button {
                    Haptics.light()
                    withAnimation(AppTheme.spring) {
                        subscription.isActive = false
                    }
                } label: {
                    Label("В архив", systemImage: "archivebox")
                }
                .tint(.orange)
            }
    }
    
    @ViewBuilder
    private func archivedSubscriptionRow(_ subscription: Subscription) -> some View {
        SubscriptionRow(subscription: subscription)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    Haptics.medium()
                    withAnimation(AppTheme.spring) {
                        modelContext.delete(subscription)
                    }
                } label: {
                    Label("Удалить", systemImage: "trash")
                }
                
                Button {
                    Haptics.success()
                    withAnimation(AppTheme.springBouncy) {
                        subscription.isActive = true
                    }
                } label: {
                    Label("Вернуть", systemImage: "arrow.uturn.backward")
                }
                .tint(.green)
            }
    }
}
