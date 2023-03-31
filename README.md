# flutter-starter

This project is a pre-template of the tasks and settings that are done every time in flutter.

Flutter version is 3.7.9

The main settings are as follows  
- Switching the app name and app ID (Bundle Identifier, Application Id) for each build setting (Debug or Release).
- It is possible to switch the value defined for each environment (Dev or Prod) at build time (e.g., Web Api connection destination).
- Firebase SDK is built in. Also, the configuration file can be switched for each build setting (Debug or Release).
- Can upload to App Store or Play Store using GitHub Actions.
- Localization.

* Uploading timing is done by git tag  

Setup
1. [Clone project](#clone-project)
1. [Manually add files that are not under git control](#manually-add-files-that-are-not-under-git-control)
1. [AndroidStudio Build Settings](#androidstudio-build-settings)
1. [GitHubActions Settings](#configure-githubactions)
1. [Rename Project Name](#rename-project-name)

## Setup

### Clone Project
```
$ git clone https://github.com/nrikiji/flutter-starter.git
```

### Manually add files that are not under git control
The files that you don't want to publish are not managed by git (.gitignore), so you have to set them manually beforehand.

#### Debug Build
```
Configuration file to download from the firebase console.
・ios/Runner/GoogleService-Info-dev.plist
・android/app/src/debug/google-services.json
```

#### Release Build
* Not required if you only want to build releases with GitHub Actions.

```
Files required for Android release build
・android/app/signing/key.jks
・android/app/signing/signing.gradle

* signing.gradle body
signingConfigs {
  release {
     storeFile file("key.jks")
     storePassword "xxxxx"
     keyAlias "xxxxx"
     keyPassword "xxxxx"
  }
}

Configuration file to download from the firebase console
・ios/Runner/GoogleService-Info-prod.plist
・android/app/src/release/google-services.json
```

### AndroidStudio Build Settings

Add debug and release from "Edit Configurations" in Android Studio.

debug: set "--dart-define env=dev" to "Additional run args"<br/>
<img src="https://user-images.githubusercontent.com/4780752/224581519-26629f83-240a-4073-a064-9b4e790f6121.png" width="400" />

release: Set "--release --dart-define env=prod" to "Additional run args"<br/>
<img src="https://user-images.githubusercontent.com/4780752/224581518-ac07126d-be0b-4a0b-956f-3eff23672f2d.png" width="400"/>

* To build from the command line
```
# Debug
$ flutter build ios --dart-define=env=dev

# Release(iOS)
$ flutter build ios --release --dart-define=env=prod

# Release(Android)
$ flutter build appbundle --release --dart-define=env=prod
or
$ flutter build appbundle --release --dart-define=env=prod --no-shrink
```

### Configure GitHubActions

#### iOS(App Store)
Set the following in GitHub Secrets
```
・APPLE_CERTIFICATES
base64 value of the p12 file (iPhone Distribution:xxxxxxxxxxxx(xxxxxxx)) written from the key chain access.
$ base64 -i xxxxx.p12

・APPLE_PROFILE
base64 value for provisioning profile
$ base64 -i xxxxx.mobileprovision

・ASC_ISSUER_ID
App Store Connect API > ISSUE ID

・ASC_KEY_ID
App Store Connect API > Key ID

・ASC_API_KEY
App Store Connect API > API Key File Contents
$ cat xxxxx.p8

・ASC_TEAM_ID
App Store Connect API > TeamID

・APPLE_TEAM_ID
Apple Developer TeamID

・FIREBASE_IOS_GOOGLE_SERVICE_INFO(firebase)
base64 value of GoogleService-Info-prod.plist

$ base64 -i GoogleService-Info-prod.plist
```

#### Android(Play Store)
Set the following in GitHub Secrets
```
・ANDROID_SIGNING
base64 value of the zipped file containing the two files required for the release build, the jks file and the gradle file.

signing(directory)
 |- key.jks
 |- signing.gradle

   * signing.gradle body
   signingConfigs {
     release {
        storeFile file("key.jks")
        storePassword "xxxxx"
        keyAlias "xxxxx"
        keyPassword "xxxxx"
     }
   }

$ zip -r signing.zip signing/
$ base64 -i signing.zip

・PLAYSTORE_SERVICE_ACCOUNT_JSON
base64 value of the secret key (JSON) generated when the service account to access the Google Play Developer Publishing API is created.

$ base64 -i api-xxxxx-xxxxx-xxxxx.json

・FIREBASE_ANDROID_GOOGLE_SERVICE_INFO(firebase)
base64 value of google-services.json

$ base64 -i google-services.json
```

### Rename Project Name
Since the project name is flutter_start_app, change it to an appropriate project name.  
See below for the changes (example of changing flutter_start_app to start_app)  
  
https://github.com/nrikiji/flutter-starter/commit/862703e5365adf55267984608bec994067a2410b
