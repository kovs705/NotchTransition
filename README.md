<div align="center">
  <img width="300" height="330" src="/Assets/NotchTransition.png" alt="NotchTransition preview">
  <h1><b>NotchTransition</b></h1>
  <p>
    <b>SwiftUI transition that expands from the iPhone notch / Dynamic Island into a full-screen view.</b>
    <br>
    <i>iOS 16.4+ with Metal shader effects on iOS 17+.</i>
  </p>
</div>

<div align="center">
  <a href="https://swift.org">
    <img src="https://img.shields.io/badge/Swift-5.9-orange.svg" alt="Swift Version">
  </a>
  <a href="https://www.apple.com/ios/">
    <img src="https://img.shields.io/badge/iOS-16.4%2B-blue.svg" alt="iOS">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT">
  </a>
</div>

## What It Does

- Starts from the notch / Dynamic Island area.
- Expands into a rounded black shell.
- Can show a shader-driven inner card before your destination view appears.
- Dismisses back out with the shader hidden by default.
- Adapts sizing for Dynamic Island devices, notch devices, older iPhones, and iPad.

## Installation

### Swift Package Manager

Add the package:

```swift
dependencies: [
    .package(url: "https://github.com/kovs705/NotchTransition.git", branch: "main")
]
```

Then add `NotchTransition` to your target dependencies.

## Basic Usage

```swift
import SwiftUI
import NotchTransition

struct ContentView: View {
    @State private var showTransition = false

    var body: some View {
        Button("Show Transition") {
            showTransition = true
        }
        .notchTransition(isPresented: $showTransition) {
            VStack(spacing: 24) {
                Text("Hello from NotchTransition")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                Button("Close") {
                    showTransition = false
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
        }
    }
}
```

## Recommended API

The easiest API is the direct modifier overload where the important options are visible in the call site:

```swift
.notchTransition(
    isPresented: $showTransition,
    animationTimings: .default,
    backgroundColor: .black,
    material: .ultraThinMaterial,
    innerViewStyle: .gradientFill,
    innerSurfaceLayout: .screenshot,
    showsInnerViewOnDismiss: false
) {
    DestinationView()
}
```

### Parameters

- `animationTimings`: transition speed preset or custom timings.
- `backgroundColor`: color of the outer expanding shell.
- `material`: optional backdrop material shown when fullscreen.
- `innerViewStyle`: shader or fill used for the inner card.
- `innerSurfaceLayout`: spacing of the inner card inside the black shell during the rectangle phase.
- `showsInnerViewOnDismiss`: whether the shader card becomes visible again while dismissing. Default is `false`.

## Presets

### Timing presets

```swift
.notchTransition(
    isPresented: $showSlow,
    animationTimings: .slow
) {
    SlowView()
}
```

### Theme helper

```swift
.notchTransitionThemed(
    isPresented: $showThemed,
    backgroundColor: .cyan,
    material: .ultraThinMaterial
) {
    ThemedView()
}
```

### Slow helper

```swift
.notchTransitionSlow(isPresented: $showSlow) {
    SlowView()
}
```

## Inner View Styles

`InnerViewStyle` controls what appears inside the rounded inner card before your destination content fades in.

```swift
.sinebow
.lightGrid
.gradientFill
.plain(.blue)
.invisible
```

Notes:

- On iOS 17+, `sinebow`, `lightGrid`, and `gradientFill` use Metal shaders.
- On iOS 16.4 to iOS 16.x, those styles fall back to an animated gradient.
- `.invisible` keeps only the outer black shell.

## Inner Surface Layout

`InnerSurfaceLayout` controls the screenshot-style spacing of the shader card inside the expanding black shell.

Available presets:

```swift
.compact
.screenshot
.immersive
```

Custom layout:

```swift
let layout = TransitionConfiguration.InnerSurfaceLayout(
    horizontalInset: 14,
    topPadding: 10,
    bottomPadding: 14
)

.notchTransition(
    isPresented: $showTransition,
    innerSurfaceLayout: layout
) {
    DestinationView()
}
```

## Dismiss Behavior

By default, the inner shader card stays hidden during dismiss:

```swift
.notchTransition(
    isPresented: $showTransition,
    showsInnerViewOnDismiss: false
) {
    DestinationView()
}
```

If you want the shader card to reappear while dismissing:

```swift
.notchTransition(
    isPresented: $showTransition,
    showsInnerViewOnDismiss: true
) {
    DestinationView()
}
```

## Full Configuration Object

If you want to construct and reuse one configuration, that still works:

```swift
let config = TransitionConfiguration(
    animationTimings: .slow,
    backgroundColor: .indigo,
    backgroundMaterial: .regularMaterial,
    innerViewStyle: .gradientFill,
    innerSurfaceLayout: .screenshot,
    showsInnerViewOnDismiss: false
)

.notchTransition(
    isPresented: $showTransition,
    configuration: config
) {
    DestinationView()
}
```

There are also fluent helpers on `TransitionConfiguration`:

```swift
let config = TransitionConfiguration.default
    .innerViewStyle(.lightGrid)
    .innerSurfaceLayout(.compact)
    .showsInnerViewOnDismiss(true)
```

Use them if you want. The direct modifier overload is usually easier to read.

## Animation Phases

1. Hidden -> Notch
2. Notch -> Rectangle
3. Rectangle -> Fullscreen
4. Destination content fades in

On dismiss, destination content fades out first, then the shell exits. The inner shader is hidden by default during that dismiss path.

## Device Support

| Device Type | Behavior |
|-------------|----------|
| Dynamic Island iPhones | Uses native Dynamic Island dimensions |
| Notch iPhones | Uses scaled notch dimensions |
| Older iPhones | Simulates a notch-origin transition |
| iPad | Uses larger tablet sizing |

## Requirements

- iOS 16.4+
- Xcode 15+
- Swift 5.9+

## Example

The package includes example views in:

- `Sources/NotchTransition/Example/NotchTransitionExample.swift`

## License

MIT. See [LICENSE](LICENSE).
