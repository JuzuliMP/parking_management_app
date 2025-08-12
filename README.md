# Parking Management App

A Flutter application for managing parking vehicles with authentication and CRUD operations.

## Features

- **Authentication**: Secure login with mobile number and password
- **Vehicle Management**: Complete CRUD operations for vehicles
- **Pagination**: Efficient vehicle listing with infinite scroll
- **Modern UI**: Material Design 3 implementation
- **Clean Architecture**: Well-structured codebase following best practices

## Architecture

The app follows Clean Architecture principles with:

- **Presentation Layer**: BLoC state management with Cubit
- **Domain Layer**: Business logic and use cases
- **Data Layer**: Repository pattern with remote data sources
- **Core**: Shared utilities, constants, and error handling

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code

### Installation

1. Clone the repository
2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```

### Demo Credentials

- **Mobile Number**: 9895680203
- **Password**: 123456

## API Integration

The app integrates with the Parking Management API:

- **Base URL**: <https://parking.api.salonsyncs.com>
- **Authentication**: Bearer token
- **Endpoints**: Login, Vehicle CRUD operations

## Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App constants
│   ├── errors/             # Error handling
│   ├── network/            # HTTP client
│   ├── routing/            # Navigation
│   ├── storage/            # Local storage
│   └── utils/              # Utilities
├── features/               # Feature modules
│   ├── auth/              # Authentication
│   └── vehicle/           # Vehicle management
└── shared/                # Shared components
    ├── theme/             # App theming
    └── widgets/           # Reusable widgets
```

## Dependencies

- `flutter_bloc`: State management
- `dio`: HTTP networking
- `go_router`: Navigation
- `equatable`: Value equality
- `dartz`: Functional programming
- `shared_preferences`: Local storage

## Testing

Run tests with:

```bash
flutter test
```

## Building

Build APK:

```bash
flutter build apk --release
```

## License

This project is developed for machine test purposes.
