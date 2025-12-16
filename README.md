# personal_finances

Personal Finances is a sample Flutter application created to demonstrate practical Flutter skills, clean architecture, and common mobile development patterns.

The project focuses on readability, separation of concerns, and scalability rather than feature completeness.

## ⚠️ Project Status

This project is **not finished**. It represents the result of the first few hours of development and serves as a technical showcase rather than a production-ready application.

Due to limited available time, further development was intentionally stopped.

### Planned / Missing features

1. **Localization** – currently, all text messages are hardcoded. This is a known issue and would normally be addressed early in a production project.
2. **Category & date filters**
3. **Dark mode support**
4. **Editing and deleting transactions**
5. **Improved category handling** – categories are currently not case-sensitive.

The application has been tested on an iOS simulator and an Android emulator. Physical devices were not available, and web/desktop targets have not been validated.

## Building the project

To generate missing files (code generation), run:

```
dart run build_runner build
```

## Tech Stack

Key libraries and tools used in this project:

1. **GetIt + Injectable** – dependency injection
2. **Drift** – SQLite ORM
3. **Bloc (Cubit)** – state management and business logic separation
4. **GoRouter** – declarative navigation

## Architecture

The project follows a layered architecture with a clear separation between UI and business logic.

State management is implemented using **Cubit** instead of full Bloc, as the application logic is relatively simple and does not require event-driven complexity.

This approach keeps the codebase lightweight while remaining easy to extend.

### Widget naming convention

Widgets are organized into two main categories:

1. **Views**
   - Stateless UI components
   - No business logic
   - Render the current state only
   - Expose callbacks for user interactions

2. **Pages**
   - Composition layer
   - Create and connect views and cubits
   - Resolve dependencies
   - Coordinate data flow between layers

### Database

All database access is encapsulated in **DAO classes**, providing:
- Clear separation between data and business logic
- Easier testing
- Flexibility to replace the persistence layer in the future

