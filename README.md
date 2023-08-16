# OpenWeather App

[![Swift Version](https://img.shields.io/badge/Swift-5.5-orange.svg)](https://swift.org/)
[![iOS Version](https://img.shields.io/badge/iOS-15+-blue.svg)](https://developer.apple.com/ios/)
[![Combine](https://img.shields.io/badge/Combine-Yes-green.svg)](https://developer.apple.com/documentation/combine)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-Yes-purple.svg)](https://developer.apple.com/xcode/swiftui/)
[![MVVM](https://img.shields.io/badge/Architecture-MVVM-yellow.svg)](https://en.wikipedia.org/wiki/Model–view–viewmodel)

The OpenWeather app provides users with current weather information based on their location or a location of their choice. It consists of two main screens: one displaying the current temperature, and another allowing users to search for weather information in a specific location.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Testing](#testing)
- [Screenshots](#screenshots)
- [Contributing](#contributing)

## Features

- View current temperature in user's location or selected location.
- Search for weather information in a specific location.
- Real-time weather data from [OpenWeather](https://home.openweathermap.org).
- Error handling for network and location issues.
- Architecture: MVVM (Model-View-ViewModel).
- Technologies: Swift, SwiftUI, Combine, CoreLocation.
- Dark and Light mode supported.
- Responsive forecast updates based on location changes.
- Multiple temperature units supported.
- No external dependencies.

## Getting Started

### Prerequisites

- Xcode 14.3 or later
- iOS 16+
- Open Weather API key (replace with your own key)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/AleksandrVoropaev/OpenWeather.git
```
2. Navigate to the project directory:
```bash
cd OpenWeather
```
3. Open the Xcode project file:
```bash
open OpenWeather.xcodeproj
```
4. In `WeatherEndpoint.swift`, replace `your-api-key` with your OpenWeather API key.
5. Build and run the app on a simulator or device.

## Usage

Follow these steps to make the most out of the OpenWeather app:

1. Launch the app on your iOS device or simulator.

2. Check the weather in your current location.

3. Automatic Forecast Updates:
   - Experience automatic forecast updates when you move to a different location. Please note that according to Apple's documentation:
     ```
     Apps can expect a notification as soon as the device moves 500 meters or more from its previous notification. It should not expect notifications more frequently than once every five minutes.
     ```
   
4. Update weather information in your current location using the `pull to refresh` gesture.

5. Explore the `Search` tab:
   - Use this feature to search for locations around the world.

6. Select a location from the search results:
   - Upon selection, you'll be redirected to the `Weather` tab with updated weather conditions for the chosen place.

7. Reset weather conditions to your current location using the `pull to refresh` gesture.

## Testing

The app's codebase is written with testing in mind. You can find an example test in `SearchViewModelTest.swift`.

## Screenshots

![Current Location Weather](screenshots/weather_current_screen.png)![Current Location Weather](screenshots/weather_current_screen_dark.png)

![Location Search](screenshots/search_location_screen.png)![Location Search](screenshots/search_location_screen_dark.png)

![Selected Location Weather](screenshots/weather_selected_screen.png)![Selected Location Weather](screenshots/weather_selected_screen_dark.png)

## Contributing

Contributions are welcome! If you'd like to contribute to the project, please follow the standard GitHub workflow:

1. Fork the repository.
2. Create a new branch: `git checkout -b feature/your-feature-name`
3. Make your changes and commit them.
4. Push to your forked repository.
5. Submit a pull request.
