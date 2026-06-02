import Foundation
import SwiftData
import SwiftUI

enum SubscriptionCategory: String, Codable, CaseIterable {
    case entertainment = "Развлечения"
    case work = "Работа и учеба"
    case gaming = "Игры"
    case vpn = "VPN и безопасность"
    case utility = "Утилиты"
    case other = "Другое"
}

@Model
class Subscription {
    var name: String
    var price: Double
    var currency: String
    var nextBillingDate: Date
    var cycle: String // "Месяц" или "Год"
    var category: String
    var isActive: Bool
    
    init(name: String, price: Double, currency: String = "₽", nextBillingDate: Date = Date(), cycle: String = "Месяц", category: SubscriptionCategory = .other, isActive: Bool = true) {
        self.name = name
        self.price = price
        self.currency = currency
        self.nextBillingDate = nextBillingDate
        self.cycle = cycle
        self.category = category.rawValue
        self.isActive = isActive
    }
    
}