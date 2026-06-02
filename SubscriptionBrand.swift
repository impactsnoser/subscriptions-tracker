import SwiftUI

/// Популярные подписки в РФ: сопоставление названия → бренд → ассет `brand_*` в Assets.xcassets
enum SubscriptionBrand: String, CaseIterable, Sendable {
    case telegram
    case yandex
    case kinopoisk
    case vk
    case youtube
    case spotify
    case netflix
    case apple
    case google
    case ivi
    case okko
    case sber
    case tinkoff
    case ozon
    case wildberries
    case playstation
    case xbox
    case nintendo
    case microsoft
    case zoom
    case notion
    case openai
    case discord
    case steam
    case epicgames
    case github
    case dropbox
    case adguard
    case nordvpn
    case protonvpn
    case megafon
    case mts
    case amazon
    case linkedin
    case duolingo
    case rutube
    case dzen
    case wink
    case kion
    case premier
    case start
    case litres
    case chatgpt
    
    var accentColor: Color {
        switch self {
        case .telegram: return Color(red: 0.16, green: 0.60, blue: 0.88)
        case .yandex: return Color(red: 0.98, green: 0.17, blue: 0.09)
        case .kinopoisk: return Color(red: 1.0, green: 0.45, blue: 0.0)
        case .vk: return Color(red: 0.0, green: 0.47, blue: 1.0)
        case .youtube: return Color(red: 1.0, green: 0.0, blue: 0.0)
        case .spotify: return Color(red: 0.11, green: 0.73, blue: 0.33)
        case .netflix: return Color(red: 0.90, green: 0.04, blue: 0.08)
        case .apple: return Color(white: 0.15)
        case .google: return Color(red: 0.26, green: 0.52, blue: 0.96)
        case .ivi: return Color(red: 0.58, green: 0.20, blue: 0.92)
        case .okko: return Color(red: 0.55, green: 0.15, blue: 0.95)
        case .sber: return Color(red: 0.0, green: 0.65, blue: 0.25)
        case .tinkoff: return Color(red: 1.0, green: 0.34, blue: 0.0)
        case .ozon: return Color(red: 0.0, green: 0.35, blue: 1.0)
        case .wildberries: return Color(red: 0.67, green: 0.20, blue: 0.55)
        case .playstation: return Color(red: 0.0, green: 0.45, blue: 0.85)
        case .xbox: return Color(red: 0.10, green: 0.60, blue: 0.10)
        case .nintendo: return Color(red: 0.90, green: 0.10, blue: 0.15)
        case .microsoft: return Color(red: 0.0, green: 0.45, blue: 0.75)
        case .zoom: return Color(red: 0.15, green: 0.55, blue: 0.95)
        case .notion: return Color(white: 0.2)
        case .openai, .chatgpt: return Color(red: 0.05, green: 0.55, blue: 0.45)
        case .discord: return Color(red: 0.34, green: 0.40, blue: 0.95)
        case .steam: return Color(red: 0.10, green: 0.18, blue: 0.28)
        case .epicgames: return Color(white: 0.12)
        case .github: return Color(white: 0.12)
        case .dropbox: return Color(red: 0.0, green: 0.38, blue: 0.90)
        case .adguard: return Color(red: 0.15, green: 0.55, blue: 0.95)
        case .nordvpn: return Color(red: 0.20, green: 0.75, blue: 0.45)
        case .protonvpn: return Color(red: 0.40, green: 0.20, blue: 0.80)
        case .megafon: return Color(red: 0.0, green: 0.75, blue: 0.20)
        case .mts: return Color(red: 0.90, green: 0.0, blue: 0.15)
        case .amazon: return Color(red: 1.0, green: 0.60, blue: 0.0)
        case .linkedin: return Color(red: 0.0, green: 0.47, blue: 0.71)
        case .duolingo: return Color(red: 0.34, green: 0.80, blue: 0.0)
        case .rutube: return Color(red: 0.95, green: 0.15, blue: 0.10)
        case .dzen: return Color(red: 0.0, green: 0.0, blue: 0.0)
        case .wink: return Color(red: 0.55, green: 0.10, blue: 0.90)
        case .kion: return Color(red: 0.85, green: 0.0, blue: 0.20)
        case .premier: return Color(red: 0.95, green: 0.75, blue: 0.0)
        case .start: return Color(red: 0.95, green: 0.20, blue: 0.25)
        case .litres: return Color(red: 0.95, green: 0.55, blue: 0.0)
        }
    }
    
    var fallbackSymbol: String {
        switch self {
        case .telegram: return "paperplane.fill"
        case .yandex: return "y.circle.fill"
        case .kinopoisk: return "play.rectangle.fill"
        case .vk: return "person.2.fill"
        case .youtube: return "play.tv.fill"
        case .spotify: return "music.note"
        case .netflix: return "film.fill"
        case .apple: return "apple.logo"
        case .google: return "g.circle.fill"
        case .ivi, .okko, .wink, .kion, .premier, .start: return "film.fill"
        case .sber: return "leaf.fill"
        case .tinkoff: return "creditcard.fill"
        case .ozon, .wildberries: return "bag.fill"
        case .playstation, .xbox, .nintendo, .steam, .epicgames: return "gamecontroller.fill"
        case .microsoft: return "doc.text.fill"
        case .zoom: return "video.fill"
        case .notion: return "square.grid.2x2.fill"
        case .openai, .chatgpt: return "sparkles"
        case .discord: return "bubble.left.and.bubble.right.fill"
        case .github: return "chevron.left.forwardslash.chevron.right"
        case .dropbox: return "archivebox.fill"
        case .adguard, .nordvpn, .protonvpn: return "shield.fill"
        case .megafon, .mts: return "antenna.radiowaves.left.and.right"
        case .amazon: return "shippingbox.fill"
        case .linkedin: return "briefcase.fill"
        case .duolingo: return "character.book.closed.fill"
        case .rutube: return "play.circle.fill"
        case .dzen: return "newspaper.fill"
        case .litres: return "book.fill"
        }
    }
    
    private static let rules: [(SubscriptionBrand, [String])] = [
        (.telegram, ["telegram premium", "telegram", "телеграм премиум", "телеграм", "тг прем", "tg premium", "тг premium"]),
        (.dzen, ["дзен премиум", "яндекс дзен", "dzen premium", "dzen"]),
        (.kinopoisk, ["кинопоиск", "kinopoisk", "кино поиск"]),
        (.yandex, ["яндекс плюс", "yandex plus", "яндекс музыка", "yandex music", "яндекс go", "yandex go", "яндекс 360", "yandex 360", "яндекс диск", "яндекс", "yandex", "я.плюс", "я плюс"]),
        (.vk, ["vk mix", "vk music", "vk видео", "вк микс", "вк музыка", "вконтакте", "вконтакт", "vk combo", "vk", "вк"]),
        (.youtube, ["youtube premium", "youtube music", "youtube", "ютуб премиум", "ютуб"]),
        (.spotify, ["spotify", "спотифай"]),
        (.netflix, ["netflix", "нетфликс"]),
        (.apple, ["apple music", "apple one", "icloud", "айклауд", "icloud+", "эпл музыка", "apple tv", "appletv"]),
        (.google, ["google one", "google play", "google drive", "гугл ван", "гугл плей", "google"]),
        (.ivi, ["иви", "ivi"]),
        (.okko, ["окко", "okko"]),
        (.sber, ["сберпрайм", "sberprime", "сбер прайм", "сбер ", "sber "]),
        (.tinkoff, ["tinkoff", "тинькофф", "т-банк", "t-bank", "тинькоф"]),
        (.ozon, ["ozon premium", "ozon", "озон"]),
        (.wildberries, ["wildberries", "вайлдберриз", "wb клуб", "wb premium"]),
        (.playstation, ["playstation", "ps plus", "ps+", "пс плюс", "playstation plus"]),
        (.xbox, ["xbox", "game pass", "gamepass", "иксбокс"]),
        (.nintendo, ["nintendo", "switch online", "нейтендо"]),
        (.microsoft, ["microsoft 365", "office 365", "office365", "майкрософт", "ms office"]),
        (.zoom, ["zoom"]),
        (.notion, ["notion", "нotion"]),
        (.chatgpt, ["chatgpt plus", "chatgpt", "чатгпт"]),
        (.openai, ["openai", "gpt plus"]),
        (.discord, ["discord nitro", "discord", "дискорд"]),
        (.steam, ["steam", "стим"]),
        (.epicgames, ["epic games", "epic", "эпик"]),
        (.github, ["github copilot", "github", "гитхаб"]),
        (.dropbox, ["dropbox", "дропбокс"]),
        (.adguard, ["adguard", "адгард"]),
        (.nordvpn, ["nordvpn", "норд впн", "nord vpn"]),
        (.protonvpn, ["proton vpn", "protonvpn", "протон"]),
        (.megafon, ["мегафон", "megafon", "мега кино"]),
        (.mts, ["мтс premium", "мтс премиум", "мтс ", "mts "]),
        (.amazon, ["amazon prime", "prime video", "амазон"]),
        (.linkedin, ["linkedin premium", "linkedin", "линкедин"]),
        (.duolingo, ["duolingo", "дуолинго"]),
        (.rutube, ["rutube", "рутуб"]),
        (.wink, ["wink", "винк"]),
        (.kion, ["kion", "кион"]),
        (.premier, ["premier", "премьер"]),
        (.start, ["start.ru", " start ", " старт "]),
        (.litres, ["литрес", "litres", "литрес подписка"]),
        (.openai, ["midjourney", "миджорни", "perplexity", "перплексити"]),
        (.google, ["google photos", "google workspace", "гугл фото"]),
        (.apple, ["apple arcade", "эпл аркада"]),
        (.steam, ["ea play", "ea play pro", "origin", "ориджин", "ubisoft+"]),
        (.tinkoff, ["тинькофф про", "tinkoff premium"]),
        (.sber, ["сберзвук", "sberzvuk", "сбер звук"]),
        (.vk, ["vk cloud", "vk play"]),
    ]
    
    static func match(name: String) -> SubscriptionBrand? {
        let normalized = name
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "ё", with: "е")
        
        for (brand, keywords) in rules {
            if keywords.contains(where: { normalized.contains($0) }) {
                return brand
            }
        }
        return nil
    }
}

extension Subscription {
    var matchedBrand: SubscriptionBrand? {
        SubscriptionBrand.match(name: name)
    }
    
    var brandStyle: (icon: String, color: Color) {
        if let brand = matchedBrand {
            return (brand.fallbackSymbol, brand.accentColor)
        }
        switch SubscriptionCategory(rawValue: category) {
        case .entertainment: return ("popcorn.fill", Color.cyan)
        case .work: return ("briefcase.fill", Color.brown)
        case .gaming: return ("gamecontroller.fill", Color.green)
        case .vpn: return ("shield.fill", Color.gray)
        case .utility: return ("wrench.and.screwdriver.fill", Color.indigo)
        default: return ("creditcard.fill", Color.secondary)
        }
    }
}
