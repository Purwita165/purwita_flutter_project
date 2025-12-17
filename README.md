# purwita_flutter_project

A new Flutter project.

## Getting Started

# Flutter SQLite Todo App

A simple Todo List application built with Flutter using SQLite for local data persistence.

## Features
- Add Todo
- Mark Todo as Done
- Delete Todo
- Data stored locally using SQLite

## Tech Stack
- Flutter
- sqflite
- sqflite_common_ffi (for desktop)

## Platform Support
This application is intended to run on **Desktop (Windows)**.

SQLite is implemented using `sqflite`, which is supported on mobile and desktop platforms.
Flutter Web (Chrome / Edge) is **not supported** in this project.

## How to Run

1. Ensure Flutter SDK is installed
2. Clone this repository
3. Get dependencies:
   ```bash
   flutter pub get

4. Run the application on Windows:

    flutter run -d windows

Note: 
- Please do not run this project on Chrome or Edge, as SQLite is not supported on Flutter Web.

- This project focuses on implementing basic CRUD operations with SQLite and is developed as part of a Flutter Bootcamp assignment.
