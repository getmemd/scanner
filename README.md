# Scanner App

This repository contains the source code of an iOS application designed to detect and analyze nearby devices connected via Bluetooth, LAN/Wi-Fi, and also to detect hidden devices using the camera and magnetometer. The app helps evaluate device security and provides tools for ensuring the user’s digital safety.

## Features

- **Wi-Fi Scanning:**  
  Discover devices connected to the same Wi-Fi network. The app can detect devices, obtain their IP and MAC addresses, determine their security status, and allow users to mark them as safe or not.

- **Bluetooth Scanning:**  
  Find nearby Bluetooth devices, determine their signal strength (RSSI), and estimate their distance. Users can label these devices as “safe” or “suspicious.”

- **Magnetic Detector:**  
  Use magnetometer data to detect strong electromagnetic signals, potentially indicating hidden electronic devices.

- **Camera-Based Detection:**  
  Apply image filters (red/green/blue/black-white) to live camera feed to inspect the environment for hidden cameras or other devices.

- **History of Scans:**  
  The app stores a history of previously detected devices with timestamps. Users can review and clear their scanning history.

- **User Interface & Design:**  
  Custom fonts, icons, and color schemes. Features an onboarding flow, splash screen, and paywall screens for premium access.

- **Monetization via RevenueCat:**  
  Includes support for in-app purchases and subscriptions (weekly, monthly, annual plans, and trial periods) managed through RevenueCat.  
  **IAPViewModel** handles subscriptions, purchases, and restore flows.

- **Permission Handling:**  
  The app requests required permissions for camera, Bluetooth, and local network. If permissions are not granted, corresponding alerts guide the user to enable them in Settings.

## Workflow

1. **Main Screen (MainView):**  
   Uses a TabView with four tabs: History, Magnet, Radar (ScannerView), Detector (CameraView).

2. **Wi-Fi Scan:**  
   When “SEARCH DEVICES ON SHARED WI-FI” is tapped, the app checks local network permissions and Wi-Fi connection, then starts a LAN scan. After completion, it navigates to ResultView.

3. **Bluetooth Scan:**  
   On “SEARCH FOR BLUETOOTH DEVICES,” checks Bluetooth permission and scans nearby devices. After scanning completes, shows the ResultView.

4. **Magnetic Detector:**  
   “START SCANNING” begins reading magnetometer data and updating UI. User can stop scanning anytime.

5. **Camera Detector:**  
   Requests camera permission. On granting, it starts showing filtered camera previews, allowing detection of hidden devices.

6. **History:**  
   Each scan’s results are saved in history. Users can view past scans grouped by date and remove items or clear the entire history.

7. **Subscriptions & Paywall:**  
   Certain features require a subscription. If the user isn’t subscribed, a paywall is displayed. Purchases and restores are handled by IAPViewModel using RevenueCat.

## Requirements

- iOS 14+
- SwiftUI, Combine
- Hardware features (camera, Bluetooth, Wi-Fi)
- RevenueCat and AppsFlyer integration (keys required)

## Setup and Run

1. Clone the repository.
2. Install dependencies via Swift Package Manager if needed.
3. Open the project in Xcode.
4. Insert your RevenueCat and AppsFlyer keys into `AppConstants.swift`.
5. Run on a real device (some features such as Bluetooth and camera might not work on a simulator).

## License

This code is provided for internal use and analysis. Check licensing terms before redistributing.
