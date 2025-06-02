# 🎮 PokeVerse

PokeVerse is a modern, feature-rich Pokémon exploration and favorites app built for iOS.  
Developed with Swift & UIKit—modular, testable, and maintainable codebase.

---

## 🚀 Features

- **Pokémon List:**  
  Browse all Pokémon with visuals and names.
- **Detail Screens:**  
  Rich Pokémon details including about, stats, and evolution chain.
- **Favorites:**  
  Mark your favorite Pokémon and view them in a dedicated list.  
- **Offline Favorites:**  
  Favorites are stored securely on your device using **CoreData**.
- **Modern UI & UX:**  
  Clean, fast, and accessible interface.
- **Tabbed Detail View:**  
  Easily switch between About, Stats, and Evolution tabs.
- **Image Caching:**  
  Pokémon images are loaded efficiently and quickly.
- **Analytics:**  
  **Firebase Analytics** tracks screen and button interactions.
- **Comprehensive Unit Tests:**  
  Unit tests for all critical business logic.
- **Async Data Flow:**  
  All network and data operations use Swift's `async/await` for responsiveness.
- **Multi-language Support:**  
  The app supports both English and Turkish, auto-selected by your device language.

---

## 🏛️ Architecture & Technical Details

- **Layered Architecture:**  
  Separated into Presenters, Interactors, Services, and ViewControllers for testability and scalability.
- **Dependency Injection**
- **Protocol-Oriented Design**
- **Asynchronous Programming:**  
  All network and data operations use Swift’s `async/await`.
- **CoreData:**  
  Local storage for favorite Pokémon.
- **Firebase Analytics:**  
  User interaction tracking.
- **SwiftUI:**  
  Modern splash screen with SwiftUI.

---

## 🧪 Testing

The project includes comprehensive **unit tests**:
- Covers business logic (Interactor, Presenter) and service layers.
- Tests for error/success scenarios, favorite add/remove, data fetching, and error handling.
- Test reports are automatically generated as HTML under `fastlane/test_output`.

To run tests:
```bash
Cmd + U
```

---

## 🛠️ Tech Stack

- **Swift (UIKit + SwiftUI)**
- **CoreData**
- **Firebase Analytics**
- **PokeAPI** (REST)
- **async/await** (Swift 5.5+)
- **XCTest**
- **Layered architecture**
- **Localization (English & Turkish)**

---

## 🌐 Localization

PokeVerse is available in **English** and **Turkish**.  
The app detects your device language and displays the content accordingly.  
You can also add new languages by extending the localization files.

---

## ⚡ Installation

1. Clone the repo:
   ```bash
   git clone https://github.com/barisgorgun/PokeVerse.git
   ```
2. Open with Xcode.
3. Dependencies are managed automatically.
4. Optionally, add your own `GoogleService-Info.plist` for Firebase.
5. Run on simulator or device.

---

## 📱 Screens

- **Pokémon List**  
- **Detail**  
- **Favorites**

---

## 🤝 Contributing & License

Pull requests and issues are welcome.  
Please accompany your code with tests!

---

**Developer:** [Barış Görgün](https://github.com/barisgorgun)

[🇹🇷 Türkçe için tıklayın](README.tr.md)