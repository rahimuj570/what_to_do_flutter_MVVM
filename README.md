# 📝 What To-Do : Task Reminder

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Dart](https://img.shields.io/badge/Dart-3.x-blue)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-success)
![Platform](https://img.shields.io/badge/Platform-Android-green)

**What To-Do : Task Reminder** is a smart Flutter-based Todo & Reminder application that helps users manage daily tasks efficiently with **multiple reminder alerts**, **image-to-text task creation**, and a **clean MVVM architecture**.

---

## ✨ Key Features

- ✅ Create, update, and delete todo tasks
- ⏰ **Multiple reminders per task**
  - Before 30 minutes
  - Before 10 minutes
  - After deadline
- 🔔 Local notifications with timezone support
- 📸 **Scan image → extract text → generate todo task**
- 🗓️ Date & time picker for deadline selection
- 📊 Visual progress tracking using gauges
- 🧩 Swipe actions (edit/delete) with smooth UI
- 💾 Offline-first using local database
- 🌠 Day/Night mode
- 🧠 Crash monitoring using Firebase Crashlytics

---

## 🏗 Architecture

This project follows the **MVVM (Model–View–ViewModel)** architecture:


**Why MVVM?**
- Clean separation of concerns  
- Easy testing & maintenance  
- Scalable for future features  

State management is handled using **Provider**.

---

## 🧪 Tech Stack & Packages

### Core
- **Flutter**
- **Dart**
- **Provider** (State Management)
- **SQFLite** (Local Database)

### Date & Time
- `flutter_datetime_picker_plus`
- `intl`
- `timezone`
- `flutter_timezone`

### Notifications
- `flutter_local_notifications`

### Image & ML
- `google_mlkit_text_recognition`
- `image_picker`
- `image_cropper`

### UI & UX
- `flutter_slidable`
- `syncfusion_flutter_gauges`

### Storage & Utilities
- `shared_preferences`
- `path`

### Firebase
- `firebase_core`
- `firebase_crashlytics`

---

## 📥 Download APK

You can download the app based on your device architecture:

- 🔹 **ARM64 (arm64-v8a)**  
  👉 [Download APK](downloads/app-arm64-v8a-release.apk)

- 🔹 **ARMv7 (armeabi-v7a)**  
  👉 [Download APK](downloads/app-armeabi-v7a-release.apk)

- 🔹 **x86_64**  
  👉 [Download APK](downloads/app-x86_64-release.apk)

  `OR`
  - 🔹 **APKPure (Universal APK)**  
  👉 [Download APK](https://apkpure.com/p/com.example.mvvm_task_management)


---

## 📸 Youtube Shorts

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/Sy2xJAW4zqQ/0.jpg)](https://youtube.com/shorts/Sy2xJAW4zqQ)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK
- Android Studio / VS Code
- Android device or emulator

### Run Locally
```bash
git clone https://github.com/rahimuj570/what_to_do_flutter_MVVM.git
cd what_to_do_flutter_MVVM
flutter pub get
flutter run
```
---
    🧑‍💻 Author
    Rahimujjaman Rahim
    Flutter Developer
---
### 📄 License

This project is for learning and personal use.
Feel free to fork and improve 🚀
