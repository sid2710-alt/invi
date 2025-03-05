# Invoice Generator App (In Progress)

## Overview
The Invoice Generator App is a mobile application built using Flutter. It allows businesses to create, manage, and share invoices efficiently. The app follows the BLoC pattern for state management and is designed to be scalable, with plans for backend integration using Java Spring Boot.

## Features
- **Invoice Management**: Create, view, and delete invoices.
- **Invoice Sharing**: Send invoices via Gmail, WhatsApp, or other sharing options.
- **PDF Generation**: Download invoices as PDFs.
- **Itemized Billing**: Include detailed item lists in invoices.
- **State Management**: Implemented using BLoC.
- **Navigation**: Uses GoRouter for future web compatibility.

## Tech Stack
### Frontend:
- **Flutter** (Dart)
- **BLoC** for state management
- **GoRouter** for navigation

### Backend (Planned):
- **Java Spring Boot**
- **SQL Database**
- **Microservices Architecture** (future expansion)

## Project Structure
```
lib/
 ├── blocs/          # Business logic components
 ├── models/         # Data models
 ├── repositories/   # Data fetching logic
 ├── screens/        # UI screens
 ├── widgets/        # Reusable UI components
 ├── main.dart       # Entry point
```

## Future Enhancements
- **User Authentication**
- **Cloud Syncing**
- **Web Version**
- **Advanced Reporting & Analytics**

## Contribution
Feel free to contribute by submitting issues or pull requests.

## License
This project is licensed under the MIT License.

