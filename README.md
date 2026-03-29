# Tally Task

Tally Task is a Flutter productivity app to help you track tasks with clear statuses, quick filtering, and a smooth UI flow from splash to login to dashboard.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Run the App](#run-the-app)
- [Testing](#testing)
- [Data Persistence](#data-persistence)
- [Screens](#screens)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)

## Overview

This app is designed around simple but practical task management:

- Add and organize tasks quickly
- Mark tasks as `Pending`, `Urgent`, or `Done`
- Track progress from the home dashboard
- Persist data locally so tasks remain after restart

## Features

- Task management
	- Add tasks with title, optional description, and status
	- Edit task details and status
	- Delete tasks with confirmation dialog
	- Swipe-to-delete with confirmation
- Task organization
	- Filter tasks by status
	- Search tasks by title/description
	- Sort tasks by priority and creation time
- Dashboard insights
	- Dynamic stats for pending, urgent, and done tasks
	- Animated progress indicator and percentage
- UI/UX polish
	- Splash screen and animated login experience
	- Gradient UI styling and custom typography
	- Responsive behavior improvements for keyboard interactions
- Local persistence
	- Task data stored using SharedPreferences

## Tech Stack

- Flutter (Material UI)
- Dart SDK `^3.11.0`
- `shared_preferences` for local storage
- `flutter_test` for widget tests

## Project Structure

```text
lib/
	main.dart
	models/
		task_model.dart
	services/
		task_storage.dart
	screens/
		splash_screen.dart
		login_screen.dart
		home_page.dart
		tasks_screen.dart
		counter.dart
test/
	widget_test.dart
	tasks_screen_test.dart
assets/
fonts/
```

## Getting Started

### Prerequisites

- Flutter SDK installed
- Dart SDK (comes with Flutter)
- Android Studio or VS Code with Flutter extension
- A connected device, emulator, or simulator

### Setup

1. Clone the repository:

	 ```bash
	 git clone https://github.com/<your-username>/tally_task.git
	 cd tally_task
	 ```

2. Install dependencies:

	 ```bash
	 flutter pub get
	 ```

3. Verify Flutter environment:

	 ```bash
	 flutter doctor
	 ```

## Run the App

```bash
flutter run
```

Build commands:

- Android APK: `flutter build apk`
- Web: `flutter build web`
- Windows: `flutter build windows`

## Testing

Run all tests:

```bash
flutter test
```

## Data Persistence

Tasks are stored locally using SharedPreferences. The app serializes each task to JSON and restores the list on startup.

Storage key currently used:

- `tasks_v1`

## Screens

- Splash Screen
	- Animated app intro before login
- Login Screen
	- Animated login button interaction
- Home Screen
	- Task summary cards and progress indicator
- Tasks Screen
	- Full CRUD operations, filters, search, and confirmation-based delete
- Counter Screen
	- Utility counter with back navigation support

## Roadmap

- Add due dates and reminders
- Add task categories/tags
- Add dark/light theme toggle
- Add export/import backup support
- Improve test coverage for services and edge cases

## Contributing

Contributions are welcome.

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m "Add your feature"`
4. Push to your branch: `git push origin feature/your-feature`
5. Open a Pull Request

## License

This project is currently unlicensed. Add a `LICENSE` file if you want to define usage rights.
