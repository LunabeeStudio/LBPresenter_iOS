# LBPresenter

**LBPresenter** is a lightweight, state-driven architecture library for SwiftUI that facilitates predictable state management, side effects handling, and navigation flow control. It allows developers to build modular, testable, and scalable SwiftUI applications with minimal boilerplate.

---

## Features

- **State Management**: Centralized, predictable state handling with `Reducer` support.
- **Side Effects**: Clean handling of side effects like asynchronous tasks and cancellations.
- **Binding Support**: Easy SwiftUI binding with state values.
- **Navigation Management**: Seamless handling of navigation flows using state-driven logic.
- **Form Handling**: Text field binding, validation, and focus management with minimal code.
- **Task Cancellation**: Manage cancellable tasks cleanly to avoid unnecessary operations.

---

## Installation

Add `LBPresenter` to your Xcode project via Swift Package Manager.

1. In Xcode, go to **File > Swift Packages > Add Package Dependency...**
2. Enter the repository URL:
https://github.com/LunabeeStudio/LBPresenter_iOS
3. Add it to your project.

---

## Getting Started

### Core Concepts

1. **State**: Represents your app's UI state.
2. **Actions**: Events or intents that modify the state or trigger effects.
3. **Reducers**: Functions that describe how state changes in response to actions.
4. **Effects**: Side effects like network requests or timers.

---

## Why LBPresenter?

- Lightweight: Minimal overhead with only essential features.
- Scalable: Works well with small views or complex navigation flows.
- Testable: Pure reducers ensure deterministic behavior for easy testing.
- SwiftUI-friendly: Designed specifically to integrate cleanly with SwiftUI views.

---

## License
LBPresenter is available under the Apache license. See the LICENSE file for more details.

---

## Contributions

Contributions are welcome! Feel free to open issues or submit pull requests.
