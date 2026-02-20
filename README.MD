## 🧠 Project Overview

Smart Pickup is a mobile application that helps residents receive real-time updates about neighbourhood waste collection schedules, delays, and truck arrivals. The app improves communication between residents and waste collection teams so that pickups are never missed and communities stay cleaner.

Residents can view pickup timings, receive instant notifications, and report missed collections, while admins can update schedules and send alerts in real time.

----------

## 🎯 Problem Statement

Residents often miss waste collection because they don’t receive timely updates about schedule changes or delays. This leads to inconvenience, missed pickups, and poor waste management.

Smart Pickup provides a reliable and real-time communication system between waste collection teams and residents.

----------

## 🚀 Solution

Smart Pickup delivers:

-   Real-time pickup updates
    
-   Delay notifications
    
-   Arrival alerts
    
-   Admin control for schedule updates
    

This ensures residents always know when the waste truck is arriving.

----------

## 🛠️ Tech Stack

**Frontend**

-   Flutter (Mobile App UI)
    

**Backend**

-   Firebase Authentication
    
-   Cloud Firestore Database
    
-   Firebase Cloud Messaging (Notifications)
    

**Infrastructure**

-   Google Cloud Platform
    
-   Maps integration (optional)
    
-   Cloud Functions (for automation)
    

----------

## 👥 User Roles

### Residents

-   Login/signup
    
-   Select location
    
-   View pickup schedule
    
-   Receive notifications
    
-   Report missed pickup
    

### Admin

-   Update pickup timings
    
-   Send delay alerts
    
-   Change truck status
    
-   Manage areas
    

----------

## 🔑 Key Features

-   Real-time waste pickup updates
    
-   Push notifications before arrival
    
-   Delay alerts
    
-   Area-based schedule tracking
    
-   Simple and clean UI
    
-   Admin dashboard
    

----------

## 🗂️ Project Structure (High Level)

`lib/
 ├── screens/
 ├── widgets/
 ├── services/
 ├── models/
 └── main.dart` 

Firebase:

-   users collection
    
-   areas collection
    
-   schedules collection
    
-   notifications collection
    

----------

## 📅 Development Timeline (1 Month)

**Week 1:**  
Project setup, Firebase integration, login UI

**Week 2:**  
Area selection, schedule display, admin update

**Week 3:**  
Notifications, real-time updates

**Week 4:**  
UI polish, testing, final demo

----------

## 🌍 Impact

Smart Pickup improves communication between residents and waste collection services, helping create cleaner and more organized neighbourhoods through reliable real-time updates.

----------

## 🔮 Future Enhancements

-   Live truck tracking with maps
    
-   AI delay prediction
    
-   WhatsApp alerts
    
-   Complaint tracking dashboard
    
-   Municipality integration
    

----------

## 🏁 Conclusion

Smart Pickup aims to make waste collection more efficient, transparent, and reliable through real-time technology. This project demonstrates how mobile apps and cloud services can solve everyday civic problems and improve community living.

----------

**Team TrashTech**  
Sibiraj • Harish

---

## 3.8 Introduction to Flutter & Dart

## 📱 SmartPickup Flutter App

SmartPickup is a smart waste pickup booking mobile app built using Flutter.

### 📁 Folder Structure

-   **main.dart** → app entry point
    
-   **screens/** → all app screens
    
-   **widgets/** → reusable UI components
    
-   **models/** → data models
    
-   **services/** → API/Firebase logic
    

This structure helps keep code modular and scalable.

### ⚙️ Setup

`flutter pub get
flutter run` 

### 💡 What I learned

-   Flutter uses widgets for UI
    
-   Stateful widgets update UI dynamically
    
-   Dart is fast and easy for UI development
    
-   Folder structure helps scale app later

---

## 3.4 Introduction to Firebase Services and Real-Time Data Integration

📘 What we did in this module

- Set up a Flutter project and ran it successfully

- Connected the app with Firebase

- Configured Cloud Firestore database

- Created a collection called pickups

- Added functionality to book a pickup using the + button

- Stored pickup data in Firestore with:
    
    - status
    
    - timestamp

- Fetched data from Firestore

- Displayed all pickup bookings in the app UI

- Enabled real-time updates (new pickups appear instantly)

- Tested the app by running it on Chrome and emulator


---

## 3.9 Building Responsive Mobile Interfaces:

# 📱 SmartPickup – Responsive Flutter UI

This task demonstrates a responsive Flutter interface integrated with Firebase Firestore.  
The screen adapts to different device sizes (phone and tablet) and orientations while showing real-time pickup bookings.

## 🚀 Features

-   Firebase Firestore real-time pickup booking
    
-   Responsive layout using **MediaQuery**
    
-   Phone → single column list view
    
-   Tablet → grid layout
    
-   Works in portrait & landscape
    
-   Add pickup button updates UI instantly
    

## 📱 Responsive Logic Used

`double width = MediaQuery.of(context).size.width;
bool isTablet = width > 600;` 

-   Width < 600 → phone layout
    
-   Width > 600 → tablet grid layout
    

Grid changes based on orientation using screen width & height.

## 🛠 Tech Stack

-   Flutter
    
-   Dart
    
-   Firebase Core
    
-   Cloud Firestore
    

## 🧪 Testing

Tested on:

-   Android emulator (phone view)
    
-   Tablet width using Chrome resize
    
-   Portrait & landscape modes
    

## 💡 Reflection

Making the layout responsive required adjusting padding, text size, and switching between list and grid views based on screen width. Responsive design improves usability by ensuring the app looks clean and readable across phones, tablets, and different orientations.

---

## 3.10 Firebase Integration: Authentication & Firestore

- SmartPickup is a Flutter mobile app connected with Firebase Authentication and Cloud Firestore.

- Users can sign up, log in, and book waste pickups through a responsive dashboard.

- Pickup data is stored in Firestore and updates in real time.

- Firebase provides secure login and scalable cloud storage without a custom backend.

- The project demonstrates building a responsive, cloud-connected Flutter application.

---
## 3.11 Setting Up Flutter SDK, Android Studio, and First Emulator Run

# Flutter Environment Setup and First App Run

## Steps Followed
- Installed Flutter SDK and added to PATH
- Installed Android Studio and required SDK tools
- Created and launched Pixel 4 emulator
- Verified setup using flutter doctor
- Ran Flutter app using flutter run

## Reflection
I successfully set up Flutter, Android Studio, and emulator.  
Initially faced minor setup issues but resolved them using flutter doctor.  
Now I can build and test mobile apps directly on emulator which will help in future Flutter + Firebase projects.

---

## 3.12 Exploring Flutter Project Folder Structure and Understanding File Roles

## Overview
This project explores the default folder structure of a Flutter application and explains the purpose of each important folder and configuration file. Understanding this structure helps in organizing code, managing assets, and building scalable Flutter apps.

## Key Folders
- **lib/** – Main source code folder containing `main.dart`, screens, widgets, services, and models.
- **android/** – Android-specific build files, Gradle configs, and manifest.
- **ios/** – iOS configuration files used by Xcode for building the app.
- **assets/** – Stores images, fonts, and static files (declared in `pubspec.yaml`).
- **test/** – Contains unit and widget test files.

## Important Files
- **pubspec.yaml** – Manages dependencies, assets, fonts, and project settings.
- **README.md** – Project documentation and setup instructions.
- **.gitignore** – Files and folders ignored by Git.
- **build/** – Auto-generated compiled build files.

## Why This Matters
A clean project structure improves readability, teamwork, and scalability. It helps developers quickly find files, manage features efficiently, and maintain the app as it grows.

---