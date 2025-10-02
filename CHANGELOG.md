## 1.0.15 - stable (Android-only)

Highlights:
- Android-only plugin: removed all iOS native code and iOS example
- DRM cleanup: removed FairPlay and certificateUrl; keep token/Widevine
- Controls: default to Material; removed Cupertino controls; simplify theme
- Rendering: buildView always uses Texture on Flutter side
- Docs: updated install, PiP, cache, DRM, home, coverpage, README
- Assets: removed iOS icons

Breaking Changes:
- Removed iOS platform support
- Removed FairPlay DRM (BetterPlayerDrmType.fairplay, certificateUrl)
- Removed Cupertino controls and Cupertino-specific options

Migration Guide:
- Remove usages of BetterPlayerDrmType.fairplay and certificateUrl
- If relying on Cupertino controls, switch to Material or provide customControlsBuilder
- Android usage remains the same; no API change for common scenarios

Commits:
- b8a50ed feat(android-only): remove iOS, drop FairPlay, docs cleanup, Material-only
- a989f21 chore(release): bump version to 1.0.15

## 1.0.14

- Flutter: Add adjustable video display aspect ratio support in player UI and API.

## 1.0.13

* Android: Foreground service compliance for Android 10+/targetSdk 35; add `FOREGROUND_SERVICE_MEDIA_PLAYBACK` permission and declare `foregroundServiceType=mediaPlayback` to prevent DDS/VM Service disconnects.
* Android: Upgrade Media3/ExoPlayer to 1.8.0 and bump `compileSdk` to 35.
* Android: Adapt to Media3 1.8.0 API changes; fix build issues by converting `MediaSessionCompat` token to `android.media.session.MediaSession.Token` and using `ExoPlayer.setAudioAttributes(...)` instead of the deprecated `audioComponent`.

## 1.0.6

* package update. 
* Kotlin version update to 1.9.22
* Media3 version update to 1.3.1
* gradle version update to 8.1.4
* targetSdkVersion update to 34

## 1.0.5

* package update

## 1.0.4

* ios player bug fix

## 1.0.3

* ExoPlayer migration Media3

## 1.0.2

* bug fix

## 1.0.1

* bug fix

## 1.0.0

* Initial release.
