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
5. **Presenter**: Manages the state and dispatches actions to reducers and effects.

## Glossary

### Main type

- LBPresenter -> Manages the state and dispatches actions to reducers and effects.

- PresenterState -> defines the requirements for a state object used in a Presenter, enabling consistent management of `UiState` and `Action`.
- Action -> a type used to represent events, user interactions, or commands that can trigger state changes or initiate side effects within the application's state management system. Actions are sent to the presenter to update the state and handle side effects.
- UiState -> represents the state visible to the UI

- Actionning -> ensures that actions conform to Sendable & Equatable.

- Reducer -> defines how to handle actions and compute the next state, along with potential side effects. It encapsulates the logic for updating the application's state and triggering side effects based on user or system-initiated actions.


- NavPresenterState -> custom Actionnable that handles the path 
- NavReducer -> generic reducer for managing navigation-related state transitions. It encapsulates the logic for updating a navigation state (NavState) in response to navigation actions.

- SheetPresenterState -> extends PresenterState to manage the state of presented sheets in the application. It includes an associated type Sheet, which represents the sheet, and properties and methods to present or dismiss the sheet.
- Sheet -> type of the data used to present or not based on its value.

### Utils

- DefaultNavPresenterState -> Used to define a simple NavPresenterState for push navigation as it will often be the same

### Hidden type

- LBPresenterProtocol -> This protocol is used to define the basic requirements for a presenter in the LBPresenter architecture.

- Actionnable -> requires conforming types to have an associated Action type that must conform to Actionning

- LBNavPresenter -> extends `LBPresenterProtocol` to handle navigation actions. It defines a method sendNavigation(navAction: any Actionning) which is used to send navigation-specific actions. This protocol ensures that any presenter conforming to it can manage navigation-related state and actions.
- NavState -> refers to a navigation-related state used within a presenter. It is typically defined by conforming to the `NavPresenterState` protocol, which manages navigation paths, destinations, and actions. This state allows for handling navigation transitions like navigating to a new screen, popping the current screen, or resetting to the root.
 
- LBSheetPresenter -> simple interface for presenting and dismissing sheets

- Destination -> represents a specific target or screen for navigation within the app. It is typically used in conjunction with the NavPresenterState protocol to manage navigation paths and actions. A Destination must conform to Hashable and Sendable to ensure unique identification and safe concurrent access.

- Destinable -> represent a navigation destination with a unique identifier

- Send -> a utility for dispatching actions to the system, typically used within effects. It provides a way to send actions back into the system, enabling state updates or triggering additional operations from asynchronous effects. The Send struct ensures that actions are dispatched safely on the main actor and supports optional transaction handling for smoother UI updates.
- Effect -> represents possible side effects produced by a reducer in response to an action. These side effects encapsulate asynchronous operations or external behaviors that occur as a result of handling an action. The Effect enum has the following cases:
    - none: No side effect is produced, and the action only updates the state.
    - run: Represents an asynchronous operation that can dispatch additional actions.
    - cancel: Cancels an ongoing effect associated with a specific cancelId.
    - dismiss: Used to dismiss currently presented flow. Crash if not presented.

- CancellableCollection -> This helps in organizing and canceling Tasks in a thread-safe manner.

---

## Why LBPresenter?

- Lightweight: Minimal overhead with only essential features.
- Scalable: Works well with small views or complex navigation flows.
- Testable: Pure reducers ensure deterministic behavior for easy testing.
- SwiftUI-friendly: Designed specifically to integrate cleanly with SwiftUI views.

---

## Template Installation

### Installing the Template

To use the `LBPresenter.xctemplate`, you'll need to copy it to Xcode's template directory. Follow these steps:

1. Close Xcode if it's running
2. Copy the `LBPresenter.xctemplate` folder to the Xcode templates directory: `~/Library/Developer/Xcode/Templates` (If the destination folders don't exist, create them)

### Using the Template

Once installed, you can use the template in Xcode:

1. Open your project in Xcode
2. Right-click on the folder where you want to add the new files
3. Select "New File from Template..." (⌘N)
4. Scroll down to the "Templates" section
5. Select "LBPresenter"
6. Fill in the required information and click "Create"

The template will generate the necessary files with the specified naming convention and structure.

## License
LBPresenter is available under the Apache license. See the LICENSE file for more details.

---

## Contributions

Contributions are welcome! Feel free to open issues or submit pull requests.
