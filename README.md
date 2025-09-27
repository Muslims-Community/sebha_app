# 🕌 Sebha App - Digital Islamic Tasbih

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey?style=for-the-badge)](https://github.com/Muslims-Community/sebha_app)

[![GitHub stars](https://img.shields.io/github/stars/Muslims-Community/sebha_app?style=social)](https://github.com/Muslims-Community/sebha_app/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/Muslims-Community/sebha_app?style=social)](https://github.com/Muslims-Community/sebha_app/network)
[![GitHub issues](https://img.shields.io/github/issues/Muslims-Community/sebha_app)](https://github.com/Muslims-Community/sebha_app/issues)
[![GitHub contributors](https://img.shields.io/github/contributors/Muslims-Community/sebha_app)](https://github.com/Muslims-Community/sebha_app/graphs/contributors)

> **A beautiful, feature-rich digital tasbih (prayer counter) app built with Flutter for the global Muslim community** 🌍

## 📱 Screenshots

<div align="center">
  <img src="screenshots/category_selection_light.png" width="200" alt="Category Selection - Light Mode">
  <img src="screenshots/dhikr_counting_light.png" width="200" alt="Dhikr Counting - Light Mode">
  <img src="screenshots/category_selection_dark.png" width="200" alt="Category Selection - Dark Mode">
  <img src="screenshots/dhikr_counting_dark.png" width="200" alt="Dhikr Counting - Dark Mode">
</div>

## ✨ Features

### 🎯 Core Features
- **📿 Digital Tasbih Counter** - Count dhikr with beautiful animations
- **🌙 Comprehensive Dark Theme** - Perfect for night prayers
- **🏷️ Multiple Dhikr Categories** - Morning, Evening, Prayer, and more
- **📝 Custom Categories** - Create and manage your own dhikr collections
- **🎨 Beautiful UI/UX** - Material Design 3 with Islamic aesthetics
- **🌐 Multi-language Support** - Arabic, English, and Urdu

### 🚀 Advanced Features
- **📊 Progress Tracking** - Monitor your spiritual journey
- **🎉 Completion Celebrations** - Confetti animations for motivation
- **📱 Responsive Design** - Works on phones, tablets, and web
- **🔔 Smart Notifications** - Reminder system for dhikr
- **📈 Analytics & Statistics** - Track your dhikr habits
- **🎵 Audio Feedback** - Optional sound effects

### 🛠️ Technical Features
- **🌓 Adaptive Theming** - Automatic light/dark mode detection
- **♿ Accessibility Support** - Screen reader compatible
- **🔤 Font Scaling** - Adjustable text sizes
- **💾 Offline Storage** - Works without internet
- **🔄 Data Backup** - Export/import your data
- **📲 Home Screen Widgets** - Quick access to tasbih

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Muslims-Community/sebha_app.git
   cd sebha_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate localization files**
   ```bash
   flutter gen-l10n
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

#### Android APK
```bash
flutter build apk --release
```

#### iOS IPA
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

## 📁 Project Structure

```
lib/
├── l10n/                          # Localization files
├── main.dart                      # App entry point
├── screens/                       # UI Screens
│   ├── category_selection/        # Category selection screen
│   ├── dhikr_counting/           # Main tasbih counter
│   ├── category_management/       # CRUD for categories
│   ├── settings/                  # App settings
│   └── statistics/                # Analytics dashboard
├── shared/
│   ├── models/                    # Data models
│   ├── providers/                 # State management (Riverpod)
│   ├── services/                  # Business logic
│   └── widgets/                   # Reusable components
└── assets/
    ├── fonts/                     # Arabic fonts (Amiri, Noto Sans)
    ├── images/                    # App icons and images
    └── audio/                     # Sound effects
```

## 🎨 Design Philosophy

### Islamic Aesthetics
- **🟢 Green Color Palette** - Traditional Islamic colors
- **🔤 Arabic Typography** - Beautiful Amiri and Noto Sans Arabic fonts
- **🌙 Crescent Moon Iconography** - Subtle Islamic design elements
- **📿 Prayer Bead Animations** - Visual metaphors for tasbih

### User Experience
- **🎯 Minimalist Design** - Focus on dhikr without distractions
- **👆 One-Handed Operation** - Easy thumb navigation
- **🔄 Intuitive Gestures** - Tap to count, swipe to navigate
- **🎭 Smooth Animations** - Delightful micro-interactions

## 🌍 Localization

The app supports multiple languages with RTL (Right-to-Left) layout:

- **🇸🇦 Arabic (العربية)** - Full RTL support
- **🇺🇸 English** - Primary language
- **🇵🇰 Urdu (اردو)** - RTL support

### Adding New Languages

1. Create new `.arb` file in `lib/l10n/`
2. Add translations following existing structure
3. Run `flutter gen-l10n` to generate code
4. Update `MaterialApp.supportedLocales`

## 🤝 Contributing

We welcome contributions from the Muslim developer community!

### How to Contribute

1. **🍴 Fork the repository**
2. **🌿 Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **💻 Make your changes**
4. **✅ Test thoroughly**
5. **📝 Commit with descriptive message**
   ```bash
   git commit -m "feat: add amazing feature"
   ```
6. **📤 Push to your fork**
   ```bash
   git push origin feature/amazing-feature
   ```
7. **🔄 Open a Pull Request**

### Contribution Guidelines

- Follow [Flutter Style Guide](https://docs.flutter.dev/development/tools/formatting)
- Write tests for new features
- Update documentation for API changes
- Respect Islamic values in contributions
- Use conventional commit messages

### Development Setup

```bash
# Install dependencies
flutter pub get

# Run code generation
flutter packages pub run build_runner build

# Run tests
flutter test

# Check code quality
flutter analyze
```

## 📚 Islamic Content Guidelines

### Dhikr Authenticity
- All dhikr must be from authentic Islamic sources
- Include Arabic text with proper diacritics
- Provide accurate transliterations
- Add meaningful translations

### Content Sources
- Quran and authentic Hadith
- Classical Islamic texts
- Verified by Islamic scholars
- Community reviewed content

## 🔧 Technical Architecture

### State Management
- **Riverpod** - Reactive state management
- **SharedPreferences** - Local data persistence
- **JSON Serialization** - Data modeling

### Key Dependencies
```yaml
dependencies:
  flutter: sdk: flutter
  flutter_riverpod: ^2.4.0
  shared_preferences: ^2.2.0
  confetti: ^0.7.0
  vibration: ^1.8.0
  json_annotation: ^4.8.0
```

### Performance Optimizations
- Lazy loading of dhikr categories
- Efficient list rendering with builders
- Optimized image assets
- Memory management for animations

## 📱 Platform Support

| Platform | Status | Features |
|----------|--------|----------|
| **Android** | ✅ Full Support | Widgets, Notifications, Haptics |
| **iOS** | ✅ Full Support | Widgets, Notifications, Haptics |
| **Web** | ✅ Full Support | Progressive Web App |
| **Windows** | 🔄 In Progress | Desktop optimizations |
| **macOS** | 🔄 In Progress | Native menu integration |
| **Linux** | 🔄 In Progress | GTK integration |

## 🐛 Known Issues

- [ ] Widget configuration on some Android versions
- [ ] iOS notification permissions edge cases
- [ ] Web audio playback in some browsers

See [Issues](https://github.com/Muslims-Community/sebha_app/issues) for full list and to report bugs.

## 🗺️ Roadmap

### Version 2.0
- [ ] 🕌 Qibla direction finder
- [ ] ⏰ Prayer times integration
- [ ] 🤲 Dua collections
- [ ] 👥 Community features

### Version 2.1
- [ ] 📱 Apple Watch support
- [ ] 🎧 Audio dhikr guide
- [ ] 📊 Advanced analytics
- [ ] ☁️ Cloud sync

### Version 3.0
- [ ] 🤖 AI-powered dhikr recommendations
- [ ] 🌐 Social sharing features
- [ ] 🎮 Gamification elements
- [ ] 📚 Islamic learning modules

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 Muslims Community

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

## 🙏 Acknowledgments

- **Allah (SWT)** - For guidance and blessings
- **Prophet Muhammad (PBUH)** - For the authentic dhikr
- **Flutter Team** - For the amazing framework
- **Muslim Developer Community** - For contributions and feedback
- **Islamic Scholars** - For content verification
- **Beta Testers** - For thorough testing

## 📞 Contact & Support

- **📧 Email**: support@muslimscommunity.org
- **🐦 Twitter**: [@MuslimsCommunity](https://twitter.com/MuslimsCommunity)
- **💬 Discord**: [Join our server](https://discord.gg/muslimscommunity)
- **📱 Telegram**: [@SebhaApp](https://t.me/SebhaApp)

## ⭐ Show Your Support

If this app benefits your spiritual journey, please:

- ⭐ **Star this repository**
- 🍴 **Fork and contribute**
- 📢 **Share with fellow Muslims**
- 🤲 **Make dua for the developers**

---

<div align="center">

**بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ**

*"In the name of Allah, the Most Gracious, the Most Merciful"*

**Built with ❤️ for the Muslim Ummah**

![Visitors](https://visitor-badge.laobi.icu/badge?page_id=Muslims-Community.sebha_app)

</div>
