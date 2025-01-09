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

## Cookbook

### Basic

Create a PresenterState containing a UiState and an enum of Action (doesn't have to be Equatable but refresh is optimized if it is)

```swift
import LBPresenter

struct DemoState: PresenterState, Equatable {

    struct UiState: Equatable {
        var count: Int
    }
    enum Action: Actionning {
        case increment, decrement
    }

    var uiState: UiState = .init(count: 0)
}
```

Add a reducer to handle those action and modify the state

```swift
import LBPresenter

struct DemoReducer {
    @MainActor static let reducer: Reducer<DemoState, Never> = .init(reduce: { state, action in
        switch action {
        case .increment:
            state.uiState.count += 1
            return .none
        case .decrement:
            state.uiState.count -= 1
            return .none
        }
    })
}
```

Use both to display the state and call the action thanks to the LBPresenter in your View

```swift
import LBPresenter
import SwiftUI

struct DemoView: View {

    @StateObject private var presenter: LBPresenter<DemoState, Never> = .init(initialState: .init(), reducer: DemoReducer.reducer)

    var body: some View {
        let _ = Self._printChanges()
        Form {
            Text("Count = \(presenter.state.uiState.count)")
            Button("Increment") { presenter.send(.increment) }
            Button("Decrement") { presenter.send(.decrement) }
        }
    }
}
```

### Start and Cancel an effect

In your refreshable create an enum to store the id you'll to the task you want to be able to cancel

```swift
private enum CancelID: String { case cancellableTask }
```

In your reducer you'll be able to link the task with the optional cancelId

```swift
case .startTask:
    return .run({ send, _ in
        do {
            print("Task started")
            try await Task.sleep(for: .seconds(3))
            print("Task completed")
        } catch is CancellationError {
            print("Task was cancelled")
        } catch {
            print("ooops! \(error)")
        }
    }, cancelId: CancelID.refreshable.rawValue)
```

And you can reuse it to cancel when wanted in another action

```swift
case .cancel:
    return .cancel(cancelId: CancelID.refreshable.rawValue)
```

### Start a push flow

Create a nav state (using DefaultNavPresenterState is a convenient way to get the action prefill and only handle the destination)

```swift
enum PushDestination: Hashable {
    case detail(PushDetailModel)
}

typealias PushFlowState = DefaultNavPresenterState<PushDestination>
```

The initialization of the presenter in the View will take 2 more parameters : the navState and the navReducer conveniently created by DefaultNavPresenterState for you

```swift
@StateObject private var presenter: LBPresenter<DemoState, PushFlowState> = .init(initialState: .init(), reducer: DemoReducer.reducer, navState: .init(), navReducer: PushFlowState.navReducer())
```
You can then add or use an action in your PresenterState and implement it in your reducer to navigate thanks to a side effect

```swift
case .pushDetail:
    return .run { _, sendNavigation in
        sendNavigation(.navigate(.detail(.init(id: "pushed"))))
    }
```

In the screen presenting you'll need to bind the path with the presenter and define a navigationDestination (Note that the next presenter is created from the previous one thanks to the `getChild` method so that it's lifecycle is managed by it's parent and to avoid recreating it you must pass the uuid generated for you)

```swift
NavigationStack(path: presenter.bindPath(send: PushFlowState.Action.navigate)) {
}
.navigationDestination { (destination: PushDestination, uuid) in
    switch destination {
    case let .detail(model):
        PushDetail(presenter: presenter.getChild(for: .init(modelId: model.id), and: PushDetailReducer.reducer, bindTo: uuid))
    }
}
```

The pushed screen can then retreive its presenter like this (using the same `PushFlowState` previously defined)

```swift
@ObservedObject var presenter: LBPresenter<PushDetailState, PushFlowState>
```

### Start a present flow

You first need to modify the `PresenterState` to be `SheetPresenterState` and define the `Sheet` that will trigger the present when not `nil`

```swift
struct PresentState: SheetPresenterState, Equatable {
    typealias Sheet = PresentDetailModel

    enum UiState: Equatable {
        ...
    }

    enum Action: Actionning {
        case present(Sheet?)
    }

    var uiState: UiState
    var presented: Sheet?
}
```

Adapt the reducer to modify the presented when you want to present or dismiss the next screen

```swift
case let .present(model):
    state.presented = model
    return .none
}
```

You can then add the `.sheet` in your view to present the next screen (Note that the next presenter is created from the previous one thanks to the `getPresentedChild` method so that it can be dismissed from the presented screen)

```swift
.sheet(item: presenter.binding(for: presenter.state.presented, send: PresentState.Action.present)) { model in
    PresentDetail(presenter: presenter.getPresentedChild(for: .init(uiState: .data(model)), reducer: PresentDetailReducer.reducer))
}
```

The presented screen can then retreive its presenter like this (you can start a new push flow from here if you need)

```swift
@ObservedObject var presenter: LBPresenter<PresentDetailState, Never>
```

To dismiss the flow from the presented screens you can return the side effect `.dismiss` in the reducer

```swift
switch action {
case .dismiss:
    return .dismiss
}
```

### Binding

To link text or focus change to an action you can create a binding through the presenter

```swift
@FocusState var focus: FormState.Field?

Form {
    TextField(text: presenter.binding(for: formData.name, send: FormState.Action.nameChanged)) {
}
.bind(presenter.binding(for: uiState.field, send: FormState.Action.focusChanged), to: $focus)
```

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

### Shortcut

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
