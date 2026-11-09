# Fatzz Dark

A dark-themed local music player starter for Android, built with Kotlin, Jetpack Compose, and AndroidX Media3.

## Included

- Home, Search, and Library screens
- Import local audio with Android's system document picker (`audio/*`)
- Persistent URI read access for imported tracks
- ExoPlayer playback through a `MediaSessionService`
- Play/pause, previous/next, and seek controls
- Media notification and lock-screen/media-session integration
- Local liked-song and imported-track lists

## Requirements

- Android Studio with JDK 17
- Android SDK Platform 35 and Build Tools 35.0.0
- Gradle 8.9 (Android Gradle Plugin 8.7.3)
- Android 8.0 (API 26) or newer for installation

## Build locally

Open this folder in Android Studio, allow Gradle sync, then run the `app` configuration on a connected Android device or emulator.

To build a debug APK from a terminal with Gradle 8.9 installed:

```bash
gradle --no-daemon assembleDebug
```

The APK is written to `app/build/outputs/apk/debug/app-debug.apk`.

## Build an APK using GitHub Actions (can be started from a phone)

This repository includes `.github/workflows/build-apk.yml`. It builds a debug APK on GitHub's hosted Linux runner and uploads it as an Actions artifact.

1. Create a new **private** or public repository on GitHub.
2. Upload the *contents* of this project folder to the repository root. The `.github/workflows/build-apk.yml` file must also be uploaded, preserving its folder path.
3. Open the repository's **Actions** tab and enable workflows if GitHub asks.
4. Select **Build Fatzz APK**, tap **Run workflow**, then confirm **Run workflow**.
5. Wait for the run to finish successfully. Open that run, find **Artifacts**, and download `Fatzz-Debug-APK`.
6. Extract the downloaded artifact ZIP. Install `app-debug.apk` on your Android phone. Android may ask you to allow installation from that browser or file manager.

If using GitHub's mobile website, switch the browser to **Desktop site** for repository file upload and Actions controls. Upload the project files/folders, not the outer `FatzzDark-Android-Source.zip` as a single file. Keep `.github/workflows/build-apk.yml` at exactly that path so GitHub detects the workflow.

## Privacy and permissions

The app uses Android's system document picker rather than broad storage permissions. It requests notification permission on Android 13+ and declares foreground media playback permissions for the playback service. The project does not add account login, analytics/tracking, or an internet permission.

## Current limitations

- Local audio only; no online streaming or account system
- No lyrics lookup, automatic album-art retrieval, or cloud sync
- This repository is source code. An APK is only produced after a successful local build or GitHub Actions run.
- The source has not yet been compiled or exercised on a physical device in this delivery environment. GitHub Actions is provided to perform the first real Android build and report compiler errors.
