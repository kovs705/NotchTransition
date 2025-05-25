# DynamicIslandTransition

A SwiftUI library that provides a smooth transition animation starting from the iPhone's Dynamic Island (or notch area for older devices), expanding to fill the entire screen. The library automatically adapts to different iPhone models and screen sizes.

## Features

- 🏝️ **Adaptive Design**: Automatically detects and adapts to different iPhone models (Dynamic Island, Notch, or older devices)
- 📱 **Universal Support**: Works on all iPhone models and iPad
- ⚡ **Smooth Animations**: Bouncy, fluid animations with customizable timing
- 🎨 **Themeable**: Support for custom colors, materials, and backgrounds
- 🛠️ **Configurable**: Multiple preset configurations (default, fast, slow) and full customization
- 📦 **Easy Integration**: Simple SwiftUI view modifier for quick implementation
- 🔧 **iOS 16+**: Built for modern iOS with SwiftUI best practices

## Device Support

| Device Type | Screen Sizes | Animation Adaptation |
|-------------|--------------|---------------------|
| **Dynamic Island** | iPhone 14 Pro, 15 series, 16 series | Native Dynamic Island dimensions |
| **Notch** | iPhone X, XS, 11, 12, 13 series | Scaled notch dimensions |
| **No Notch** | iPhone SE, 8, 7 and older | Simulated island effect |
| **iPad** | All iPad models | Larger dimensions for tablet |

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/DynamicIslandTransition.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter the repository URL
3. Select the version and add to your target

## Quick Start

### Basic Usage

```swift
import SwiftUI
import DynamicIslandTransition

struct ContentView: View {
    @State private var showTransition = false
    
    var body: some View {
        Button("Show Transition") {
            showTransition = true
        }
        .dynamicIslandTransition(isPresented: $showTransition) {
            VStack {
                Text("Hello from Dynamic Island!")
                    .foregroundColor(.white)
                
                Button("Close") {
                    showTransition = false
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
```

### Predefined Configurations

```swift
// Fast animation
.dynamicIslandTransitionFast(isPresented: $showFast) {
    FastContent()
}

// Slow animation
.dynamicIslandTransitionSlow(isPresented: $showSlow) {
    SlowContent()
}

// Themed with custom colors
.dynamicIslandTransition(
    isPresented: $showThemed,
    backgroundColor: .purple,
    material: .ultraThinMaterial
) {
    ThemedContent()
}
```

### Custom Configuration

```swift
let customConfig = TransitionConfiguration(
    animationTimings: TransitionConfiguration.AnimationTimings(
        initial: 0.1,
        notchToRectangle: 1.2,
        rectangleToFullscreen: 0.8,
        contentAppearance: 0.5
    ),
    backgroundColor: .indigo,
    backgroundMaterial: .regularMaterial
)

.dynamicIslandTransition(
    isPresented: $showCustom,
    configuration: customConfig
) {
    CustomContent()
}
```

## Configuration Options

### Animation Timings

```swift
struct AnimationTimings {
    let initial: TimeInterval           // Delay before animation starts
    let notchToRectangle: TimeInterval  // Time to expand from notch to rectangle
    let rectangleToFullscreen: TimeInterval // Time to expand to fullscreen
    let contentAppearance: TimeInterval // Time for content to appear
}
```

**Presets:**
- `.default`: Balanced timing (0.27s, 0.8s, 0.6s, 0.5s)
- `.fast`: Quick animations (0.15s, 0.5s, 0.4s, 0.3s)
- `.slow`: Leisurely animations (0.4s, 1.2s, 0.8s, 0.7s)

### Visual Customization

```swift
TransitionConfiguration(
    backgroundColor: Color,        // Background color of the transition shape
    backgroundMaterial: Material?  // Optional material effect for backdrop
)
```

### Device Detection

The library automatically detects your device type and adapts accordingly:

```swift
// Get current device information
let deviceType = DeviceDetector.currentDevice
let topSafeArea = DeviceDetector.topSafeAreaInset
let notchSize = DeviceDetector.notchDimensions(for: deviceType)
```

## Animation Phases

The transition consists of four distinct phases:

1. **Hidden** → **Notch**: Shape appears from the Dynamic Island/Notch area
2. **Notch** → **Rectangle**: Expands to a rounded rectangle
3. **Rectangle** → **Fullscreen**: Grows to fill the entire screen
4. **Content Appearance**: Your content fades in with animation

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.9+

## Examples

The library includes comprehensive examples showing:

- Basic implementation
- Different animation speeds
- Custom themes and materials
- Device-specific adaptations
- Advanced configurations

Run the example project to see all features in action.

## Architecture

```
DynamicIslandTransition/
├── Sources/
│   └── DynamicIslandTransition/
│       ├── DynamicIslandTransition.swift      # Main transition view
│       ├── DeviceDetector.swift               # Device detection utilities
│       ├── TransitionConfiguration.swift      # Configuration options
│       ├── View+DynamicIslandTransition.swift # SwiftUI extensions
│       └── ExampleUsage.swift                 # Usage examples
├── Tests/
│   └── DynamicIslandTransitionTests/
└── Package.swift
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup

1. Clone the repository
2. Open `Package.swift` in Xcode
3. Make your changes
4. Run tests
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by iOS Dynamic Island interaction patterns
- Built with SwiftUI and modern iOS design principles
- Thanks to the Swift community for feedback and suggestions

## Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/yourusername/DynamicIslandTransition/issues) page
2. Create a new issue with detailed information
3. Include device model, iOS version, and code samples

---

Made with ❤️ for the iOS development community
