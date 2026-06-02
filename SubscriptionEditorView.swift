import SwiftUI
import SwiftData

/// Добавление (subscription == nil) или редактирование существующей подписки
struct SubscriptionEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var subscription: Subscription?
    
    @State private var name = ""
    @State private var price = ""
    @State private var selectedCycle = "Месяц"
    @State private var selectedCategory: SubscriptionCategory = .other
    @State private var billingDate = Date()
    @State private var appeared = false
    
    private let cycles = ["Месяц", "Год"]
    
    private var isEditing: Bool { subscription != nil }
    
    private var previewSubscription: Subscription {
        Subscription(
            name: name.isEmpty ? (subscription?.name ?? "Новая подписка") : name,
            price: Double(price.replacingOccurrences(of: ",", with: "."))
                ?? subscription?.price ?? 0,
            currency: subscription?.currency ?? "₽",
            nextBillingDate: billingDate,
            cycle: selectedCycle,
            category: selectedCategory,
            isActive: subscription?.isActive ?? true
        )
    }
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
            && Double(price.replacingOccurrences(of: ",", with: ".")) != nil
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedMeshBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        previewCard
                            .padding(.top, 8)
                        
                        formSection(title: "Основное", icon: "textformat") {
                            styledField("Название", text: $name, prompt: "Яндекс Плюс, Telegram…")
                            styledField("Стоимость", text: $price, prompt: "299")
                                .keyboardType(.decimalPad)
                        }
                        
                        formSection(title: "Детали", icon: "slider.horizontal.3") {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Период")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.5))
                                
                                HStack(spacing: 8) {
                                    ForEach(cycles, id: \.self) { cycle in
                                        cycleChip(cycle)
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Категория")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.5))
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(SubscriptionCategory.allCases, id: \.self) { category in
                                            categoryChip(category)
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Дата списания")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.5))
                                
                                DatePicker("", selection: $billingDate, displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .tint(AppTheme.accent)
                                    .colorScheme(.dark)
                                    .padding(12)
                                    .glassCard(cornerRadius: 16)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 24)
                }
            }
            .navigationTitle(isEditing ? "Редактировать" : "Новая подписка")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        Haptics.light()
                        dismiss()
                    }
                    .foregroundStyle(.white.opacity(0.7))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Сохранить" : "Добавить") {
                        save()
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(canSave ? AppTheme.accentSecondary : .white.opacity(0.3))
                    .disabled(!canSave)
                }
            }
            .onAppear {
                loadExistingValues()
                withAnimation(AppTheme.springBouncy.delay(0.08)) {
                    appeared = true
                }
            }
        }
    }
    
    private func loadExistingValues() {
        guard let subscription, name.isEmpty else { return }
        name = subscription.name
        price = formatPrice(subscription.price)
        selectedCycle = subscription.cycle
        selectedCategory = SubscriptionCategory(rawValue: subscription.category) ?? .other
        billingDate = subscription.nextBillingDate
    }
    
    private func formatPrice(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(value))
        }
        return String(value)
    }
    
    private var previewCard: some View {
        VStack(spacing: 12) {
            Text("Превью")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.45))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            SubscriptionRow(subscription: previewSubscription)
                .allowsHitTesting(false)
        }
        .animation(AppTheme.spring, value: name)
        .animation(AppTheme.spring, value: price)
        .animation(AppTheme.spring, value: selectedCategory)
    }
    
    private func formSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(title, systemImage: icon)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
            
            VStack(spacing: 14) {
                content()
            }
            .padding(18)
            .glassCard(cornerRadius: 22)
        }
    }
    
    private func styledField(_ title: String, text: Binding<String>, prompt: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.5))
            TextField("", text: text, prompt: Text(prompt).foregroundStyle(.white.opacity(0.25)))
                .font(.body.weight(.medium))
                .foregroundStyle(.white)
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(.white.opacity(0.06))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(.white.opacity(0.1), lineWidth: 1)
                        )
                )
        }
    }
    
    private func cycleChip(_ cycle: String) -> some View {
        Button {
            Haptics.light()
            withAnimation(AppTheme.spring) { selectedCycle = cycle }
        } label: {
            Text(cycle)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(selectedCycle == cycle ? .white : .white.opacity(0.55))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background {
                    if selectedCycle == cycle {
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [AppTheme.accent, AppTheme.accentSecondary],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    } else {
                        Capsule().fill(.white.opacity(0.08))
                    }
                }
        }
        .buttonStyle(.plain)
    }
    
    private func categoryChip(_ category: SubscriptionCategory) -> some View {
        Button {
            Haptics.light()
            withAnimation(AppTheme.spring) { selectedCategory = category }
        } label: {
            Text(category.rawValue)
                .font(.caption.weight(.semibold))
                .foregroundStyle(selectedCategory == category ? .white : .white.opacity(0.55))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background {
                    if selectedCategory == category {
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [AppTheme.accent.opacity(0.9), AppTheme.accentSecondary.opacity(0.9)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    } else {
                        Capsule().fill(.white.opacity(0.08))
                    }
                }
        }
        .buttonStyle(.plain)
    }
    
    private func save() {
        guard let finalPrice = Double(price.replacingOccurrences(of: ",", with: ".")),
              !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        Haptics.success()
        
        if let subscription {
            subscription.name = name.trimmingCharacters(in: .whitespaces)
            subscription.price = finalPrice
            subscription.nextBillingDate = billingDate
            subscription.cycle = selectedCycle
            subscription.category = selectedCategory.rawValue
        } else {
            let newSub = Subscription(
                name: name.trimmingCharacters(in: .whitespaces),
                price: finalPrice,
                nextBillingDate: billingDate,
                cycle: selectedCycle,
                category: selectedCategory
            )
            modelContext.insert(newSub)
        }
        
        dismiss()
    }
}
