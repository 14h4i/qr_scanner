# QR Scanner App

A Flutter project for QR code scanner

## About
The application includes two screens: `Welcome` and `Scanner`.

The app is built using the new template: `Skeleton`.

## State management
Using `Bloc/RxDart` to manage states.

I use an `AppStateBloc` to manage the state of the application:
- `authorized`
- `unAuthorized`
- `loading`

## Shared Preferences
Use the `SharedPreferences` plugin to save application states and QR codes and caches.

The next time you open the app, the app status and the QR codes will be reloaded.

## Features
Features of QR Scanner:
- Pause and Resume Camera.
- Turn on and off the flash to help scan QR code in low light.
- Switch between your phone's front and back camera.
- Store QR codes in cache.
- Clear QR codes.

## Screenshots
| <img src="https://raw.githubusercontent.com/14h4i/qr_scanner/master/screenshots/screenshot-page-welcome.jpg" width="360" /> | <img src="https://raw.githubusercontent.com/14h4i/qr_scanner/master/screenshots/screenshot-page-scanner.jpg" width="360" /> |
| :------------: | :------------: |
| **Welcome** screen | **Scanner** screen |
