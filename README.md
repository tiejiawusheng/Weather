This is a weather application built using the native iOS technology stack. Users can view real-time weather information by searching for a city or using their current location. The project uses the OpenWeather public API to obtain weather data and supports weather icon display, basic caching, and automatic loading of the last search result upon startup.

This project was implemented strictly according to the interview assignment requirements, focusing on architecture design, code quality, and testability, rather than visual design.

---

Technology Stack & Architecture
• Language: Swift
• UI: SwiftUI + UIKit (no Storyboard)
• Architecture Pattern: MVVM-C (Model–View–ViewModel–Coordinator)
• UIKit's Coordinator is responsible for navigation and flow control
• SwiftUI is responsible for view presentation
• ViewModel is responsible for business logic and state management
• Dependency Management: Native Dependency Injection (protocol-based)
• Networking Layer: URLSession (no third-party libraries)
• Location: CoreLocation
• Caching: NSCache / URLCache
• Persistence: UserDefaults
• Testing: XCTest (Model & ViewModel)

---

Key Features
• 🔍 City weather search (US cities)
• 📍 Location permission support: Automatically retrieves current location weather after authorization
• ☁️ Real-time weather data (temperature, weather description, icon)
• 🖼️ Weather icon download and caching
• 🔁 Automatic restoration of the last searched city upon startup
• ⚠️ Comprehensive error handling
• Network errors
• Location failure
• Empty results / invalid input
• 📐 Supports portrait and landscape orientations and different Size Classes
• ♿ Basic accessibility support (VoiceOver / Dynamic Type)

---

Design Decisions
• Using MVVM-C is to clearly separate UI, business logic, and navigation logic, improving maintainability and testability.
• Choosing a SwiftUI + UIKit hybrid utilizes the advantages of SwiftUI's declarative UI while maintaining control over complex navigation flows.
• No third-party libraries were used to ensure complete control over the underlying implementation and to comply with enterprise-level coding standards.
• Network and location services are abstracted through protocols for easy mocking and unit testing. —

Areas for Improvement (Future Improvements)

With more time, the following could be further improved:

* More comprehensive UI test coverage
* Offline caching support
* Multilingual localization
* More granular error recovery strategies
* iPad split-screen and multi-window support
