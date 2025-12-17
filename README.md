# purwita_flutter_project

## Flutter SQLite Todo App

A simple Todo List application built with Flutter using SQLite for local data persistence.  
This project was developed as part of a **Flutter Bootcamp assignment**.

---

## Features
- Add Todo
- Mark Todo as Done
- Delete Todo
- Local data persistence using SQLite

---

## Tech Stack
- Flutter
- sqflite
- sqflite_common_ffi (for desktop)

---

## Platform Support
This application is intended to run on **Desktop (Windows)**.

SQLite is implemented using `sqflite`, which is supported on mobile and desktop platforms.  
❌ **Flutter Web (Chrome / Edge) is not supported** in this project.

---

## How to Run

### Prerequisites
- Flutter SDK installed
- Windows OS

### Steps
1. Clone this repository
2. Install dependencies:
   ```bash
   flutter pub get

3. Run the application on Windows:

    flutter run -d windows

Notes

Please do not run this project on Chrome or Edge, as SQLite is not supported on Flutter Web.

This project focuses on implementing basic CRUD operations with SQLite.