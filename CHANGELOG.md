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
