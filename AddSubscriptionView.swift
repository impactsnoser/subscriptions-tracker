import SwiftUI
import SwiftData

struct AddSubscriptionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var price = ""
    @State private var selectedCycle = "Месяц"
    @State private var selectedCategory: SubscriptionCategory = .other
    @State private var billingDate = Date()
    
    let cycles = ["Месяц", "Год"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Основное") {
                    TextField("Название (например, Яндекс Плюс)", text: $name)
                    TextField("Стоимость", text: $price)
                        .keyboardType(.decimalPad)
                }
                
                Section("Детали") {
                    Picker("Период", selection: $selectedCycle) {
                        ForEach(cycles, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("Категория", selection: $selectedCategory) {
                        ForEach(SubscriptionCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    
                    DatePicker("Дата списания", selection: $billingDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Новая подписка")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Добавить") {
                        if let finalPrice = Double(price), !name.isEmpty {
                            let newSub = Subscription(
                                name: name,
                                price: finalPrice,
                                nextBillingDate: billingDate,
                                cycle: selectedCycle,
                                category: selectedCategory
                            )
                            modelContext.insert(newSub)
                            dismiss()
                        }
                    }
                    .disabled(name.isEmpty || price.isEmpty)
                }
            }
        }
    }
}