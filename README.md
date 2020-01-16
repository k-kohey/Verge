---
description: >-
  A Store-Pattern based data-flow architecture for iOS Application with UIKit /
  SwiftUI
---

# Verge - a state management pattern library for iOS App

![](.gitbook/assets/loop-2x%20%281%29.png)

## Verge - Store

**A Store-Pattern based data-flow architecture.**

The concept of VergeStore is inspired by [Redux](https://redux.js.org/) and [Vuex](https://vuex.vuejs.org/).

The characteristics are

* **Creates one or more Dispatcher. \(Single store, multiple dispatcher\)**
* **A dispatcher can have dependencies service needs. \(e.g. API Client, DB\)**
* **No switch-case to handle Mutation and Action**
* **Emits any events that isolated from State It's for SwiftUI's onReceive\(:\)**
* **Supports Logging \(Commit, Action, Performance monitoring\)**
* **Supports Middleware**

## Prepare moving to SwiftUI from now with Verge



## Overview

### **Declare**

```swift
struct State: StateType {
  var count: Int = 0
}

enum Activity {
  case happen
}

final class MyStore: StoreBase<State, Activity> {
  
  init() {
    super.init(initialState: .init(), logger: DefaultStoreLogger.shared)
  }
  
  func increment() -> Mutation<Void> {
    return .mutation {
      $0.count += 0
    }
  }
  
  func delayedIncrement() -> Action<Void> {
    return .action { context in
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        context.commit { $0.increment() }
        
        context.send(.happen)
      }
    }
  }
  
}
```

### Run

```swift
let store = MyStore()

store.commit { $0.increment() }

store.dispatch { $0.delayedIncrement() }

// Get value from current State
let count = store.state.count

// Subscribe state
store.makeGetter()
  .sink { state in
    
}
```

### Integrate with SwiftUI

```swift
struct MyView: View {
  
  @EnvironmentObject var store: MyStore
  
  var body: some View {
    Group {
      Text(store.state.count.description)
      Button(action: {
        self.store.commit { $0.increment() }
      }) {
        Text("Increment")
      }
    }
  }
}
```

### Integrate with UIKit

Of course Verge supports UIKit based application.

## Concept from...

{% embed url="https://medium.com/eureka-engineering/thought-about-arch-for-swiftui-1b0496d8094" %}



