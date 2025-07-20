# Alaw Tiluk Dashboard

A modern Flutter mobile application designed to monitor environmental safety through real-time sensor data, graphical trends, and integrated weather forecasts. This app is part of the **Solar Powered IoT-Based Smart Ventilation and Fire Safety** system for Alaw Tiluk.

---

## 📱 Features

- **Live Data Monitoring**  
  Displays real-time values of temperature, humidity, smoke, and fire sensors from Firebase.

- **Sensor Graphs**  
  Interactive line charts showing trends over time for each sensor (powered by `fl_chart`).

- **Weather Forecast**  
  Weekly weather data and predictive insights using the Open-Meteo API.

- **System Logs**  
  View status logs and event history from Firebase.

- **User Interface**  
  Clean, responsive Flutter UI.  
  Custom splash screen and organized page navigation.

---

## 🧰 Tech Stack

- **Flutter** (Dart)
- **Firebase Realtime Database**
- **Open-Meteo Weather API**
- **fl_chart** package for graphs
- **Provider / setState** for state management
- **Firebase Core & Firebase Options**

---

## 🛠️ Installation

1. **Clone this repository:**

```bash
git clone https://github.com/Ad1e/AlawTiluk.git
cd AlawTiluk
```

2. **Install dependencies:**

```bash
flutter pub get
```

3. **Set up Firebase:**
   - Ensure `firebase_options.dart` is correctly configured for your Firebase project.
   - Add your Firebase configuration files:
     - `google-services.json` (for Android)
     - `GoogleService-Info.plist` (for iOS)

---

## 📂 Folder Structure

```
lib/
├── main.dart
├── firebase_options.dart
│
├── pages/
│   ├── dashboard_home.dart
│   ├── livedata.dart
│   ├── sensorgraph.dart
│   ├── logs.dart
│   └── weather.dart
│
├── services/
│   ├── firebase_service.dart
│   └── weather_service.dart
│
├── widgets/
│   ├── sensor_card.dart
│   └── graph_widget.dart
│
└── assets/
    └── images/
        └── logo.webp
```

---

## 👥 Authors

- **Aldwin C. Mazan**
- **Don Clifford I. Montalbo**
- **Ulysis N. Ilagan**  
BSIT Students | Alaw Tiluk Safety Project

---

## 📄 License

This project is for academic purposes under Batangas State University TNEU.  
<<<<<<< HEAD
All rights reserved © 2025.
=======
All rights reserved © 2025.
>>>>>>> d02e74254e7ac1e41ed1fb27d90da7b37a323afe
