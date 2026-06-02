import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allSubscriptions: [Subscription]
    
    @State private var showingAddSheet = false
    @State private var selectedTab = 0 // 0 - Активные, 1 - Архив
    
    var activeSubscriptions: [Subscription] {
        allSubscriptions.filter { $0.isActive }
    }
    
    var archivedSubscriptions: [Subscription] {
        allSubscriptions.filter { !$0.isActive }
    }
    
    /// Секции по категориям — только если активных подписок больше трёх
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
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Picker("Режим", selection: $selectedTab) {
                        Text("Активные").tag(0)
                        Text("Архив (\(archivedSubscriptions.count))").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    if selectedTab == 0 {
                        activeTabContent
                    } else {
                        archiveTabContent
                    }
                }
            }
            .navigationTitle("Мои подписки")
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddSubscriptionView()
            }
        }
    }
    
    // MARK: - Активные
    
    @ViewBuilder
    private var activeTabContent: some View {
        VStack(spacing: 16) {
            budgetCard
            
            if activeSubscriptions.isEmpty {
                ContentUnavailableView(
                    "Нет подписок",
                    systemImage: "creditcard",
                    description: Text("Нажмите +, чтобы добавить первую подписку")
                )
                .frame(maxHeight: .infinity)
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
            ContentUnavailableView(
                "Архив пуст",
                systemImage: "archivebox",
                description: Text("Сюда будут попадать отключенные подписки")
            )
            .frame(maxHeight: .infinity)
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
    
    // MARK: - Общие компоненты
    
    private var budgetCard: some View {
        VStack(spacing: 4) {
            Text("Траты в месяц")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("\(Int(totalMonthlyExpenses)) ₽")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.black)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
    }
    
    private func categorySectionHeader(_ category: SubscriptionCategory, count: Int) -> some View {
        HStack(spacing: 8) {
            Image(systemName: categoryIcon(category))
                .font(.caption.weight(.semibold))
                .foregroundStyle(categoryAccent(category))
            Text(category.rawValue)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            Spacer()
            Text("\(count)")
                .font(.caption.weight(.medium))
                .foregroundStyle(.tertiary)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Color(.tertiarySystemFill))
                .clipShape(Capsule())
        }
        .padding(.top, 4)
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
        case .work: return .brown
        case .gaming: return .green
        case .vpn: return .gray
        case .utility: return .indigo
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
                    modelContext.delete(subscription)
                } label: {
                    Label("Удалить", systemImage: "trash")
                }
                
                Button {
                    subscription.isActive = false
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
                    modelContext.delete(subscription)
                } label: {
                    Label("Удалить", systemImage: "trash")
                }
                
                Button {
                    subscription.isActive = true
                } label: {
                    Label("Вернуть", systemImage: "arrow.uturn.backward")
                }
                .tint(.green)
            }
    }
}
