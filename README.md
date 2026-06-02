# Subscriptions — трекер подписок (SwiftUI + SwiftData)

iOS 17+ приложение для учёта подписок с брендовыми иконками популярных сервисов в РФ.

## Залить на GitHub (PowerShell)

Установлены Git и GitHub CLI. В терминале:

```powershell
cd "c:\Users\pay9m\Downloads\ПИЗДЕЦ"
gh auth login
.\scripts\push-to-github.ps1
```

Или вручную после `gh auth login`:

```powershell
gh repo create subscriptions-tracker-ios --public --source=. --remote=origin --push
```

## Сборка IPA через GitHub Actions

1. Запушь репозиторий на GitHub.
2. Открой вкладку **Actions** → workflow **Build IPA** → **Run workflow** (или дождись запуска после push в `main`).
3. После успешной сборки открой run → **Artifacts** → скачай `Subscriptions-ipa-<commit>.zip` с файлом `Subscriptions-unsigned.ipa`.

### Важно про подпись

CI собирает **unsigned IPA** — для установки на iPhone нужна подпись Apple Developer (сертификат + provisioning profile). Варианты:

- Подписать локально в Xcode и экспортировать IPA;
- Добавить в репозиторий Secrets и расширить workflow (см. [документацию Apple](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases)).

## Локальная разработка (Mac)

```bash
brew install xcodegen
xcodegen generate
open Subscriptions.xcodeproj
```

## Структура

| Файл | Назначение |
|------|------------|
| `SubscriptionApp.swift` | Точка входа |
| `ContentView.swift` | Главный экран, списки, группировка |
| `SubscriptionModel.swift` | SwiftData модель |
| `SubscriptionBrand.swift` | Сопоставление названий и брендов |
| `BrandArtwork.swift` | Отрисовка логотипов |
| `project.yml` | Конфиг XcodeGen для CI |
