# Test News App

Flutter app with authentication, news submission, and webhook integration.

## Features

- Splash screen with logo
- Login with JSON user validation
- Session management (auto-login)
- Add News form with webhook submission
- Draggable response bottom sheet
- Category management

## Prerequisites

- Flutter SDK
- Dart SDK

## Project Structure

```
lib/
├── controllers/     # GetX controllers
├── screens/        # UI screens
├── services/       # API & session services
├── models/         # Data models
├── routes/         # Go Router config
├── widgets/        # Reusable widgets
└── data/           # JSON data files
```

## Dependencies

- **get**: ^4.6.6 - State management
- **go_router**: ^14.2.7 - Navigation
- **shared_preferences**: ^2.2.2 - Local storage
- **http**: ^1.2.2 - Webhook calls

## Setup

1. Clone repository
2. Run `flutter pub get`
3. Run `flutter run`

## Usage

1. Splash screen shows for 3 seconds
2. Auto-navigates to login if no session
3. Login with email/password from users.json
4. Skip login option available
5. Add news and submit to webhook
6. View response in bottom sheet

## Test Users

All passwords: `abc@123`

- manikanta@gmail.com
- siva@gmail.com
- ram@gmail.com
- krishna@gmail.com

