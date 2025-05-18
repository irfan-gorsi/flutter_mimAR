# Flutter Frontend – Technical Task

## Overview

This is the Flutter frontend implementation of the technical task. The app includes login, signup, and a home screen that displays weather information, a random motivational quote, gemini feature and a list of users. It connects to a Node.js backend via RESTful APIs.

## Features

- Login and Signup screens  
  - Responsive UI design  
  - Form validation (email format, password strength)  
  - Authentication using JWT  
- Home Screen  
  - Displays weather data (based on city or location)  
  - Shows a random motivational quote  
  - Lists all users in a table format  
  - Added gemini text generation feature  
- State Management using Provider or Riverpod

## Getting Started

### Prerequisites

- Flutter SDK (v3.0.0 or above)  
- Dart SDK  
- Android Studio or VS Code  
- Node.js backend running separately

### Installation

1. Clone the repository:

```bash
git clone https://github.com/your-username/flutter_frontend.git
cd mimar
```

##  Folder Structure

```plaintext
flutter_frontend/
├── lib/
│   ├── main.dart                           # Main Flutter app entry point
│   ├── components/                         # Reusable UI components
│   │   ├── custom_button.dart
│   │   ├── custom_text_field.dart
│   │   └── headertext.dart
│   ├── screens/                            # App screens organized by feature
│   │   ├── login/                          # Login screen and logic
│   │   │   ├── api_service.dart
│   │   │   ├── login_controller.dart
│   │   │   └── login.dart
│   │   ├── signup/                         # Signup screen and logic
│   │   │   ├── signup_controller.dart
│   │   │   └── signup.dart
│   │   ├── home/
│   │   │   └── allusers/
│   │   │       └── api_service.dart
│   │   ├── gemini/                         # Gemini AI integration
│   │   │   ├── chat_screen.dart
│   │   │   ├── gemini_controller.dart
│   │   │   └── gemini_widget.dart
│   │   ├── quotecomp/                      # Motivational quote feature
│   │   │   ├── quote_api_service.dart
│   │   │   ├── quote_controller.dart
│   │   │   └── quotecard.dart
│   │   └── weathercomp/                    # Weather display feature
│   │       ├── api_service.dart
│   │       ├── weather_controller.dart
│   │       └── detailed_weather_screen.dart
│   └── utils/                              # Utility and helper files
│       └── env.dart
├── pubspec.yaml                            # Flutter project configuration
```

##  Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_dotenv: ^5.2.1
  http: ^1.4.0
  flutter_riverpod: ^2.6.1
  flutter_lints: ^5.0.0
  shared_preferences: ^2.5.3
  geolocator: ^9.0.1
  permission_handler: ^12.0.0+1
```
