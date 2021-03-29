# flutter_starter

flutterで毎回行っている作業や設定を予めテンプレート化したプロジェクトです。

主な設定は以下のとおり。  
1. ビルド設定(Debug or Release)ごとに、アプリ名・アプリID(Bundle Identifier、Application Id)を切り替えることができる
1. ビルド時に環境(Dev or Prod)ごとに定義した値で切り替える(Web Apiの接続先など)ことができる
1. Firebase SDKを組み込んでいる。また、ビルド設定(Debug or Release)ごとに、設定ファイルを切り替えることができる
1. GitHub Actionsを利用してApp StoreまたはPlay Storeへアップロードすることができる

## Usage

### 設定
公開したくないファイルはgitの管理対象外(.gitignore)としているので手動で予め手動で設定する。

#### Debugビルド用
```
firebaseコンソールからダウンロードする設定ファイル
・ios/Runner/GoogleService-Info-dev.plist
・android/app/src/debug/google-services.json
```

#### Releaseビルド用
※GitHub Actionsでのみリリースビルドする場合は不要

```
Android リリースビルドに必要なファイル
・android/app/signing/key.jks
・android/app/signing/signing.gradle
signingConfigs {
  release {
     storeFile file("key.jks")
     storePassword "xxxxx"
     keyAlias "xxxxx"
     keyPassword "xxxxx"
  }
}

firebaseコンソールからダウンロードする設定ファイル
・ios/Runner/GoogleService-Info-prod.plist
・android/app/src/release/google-services.json
```

### ビルド

#### Android Studio
TODO:

#### コマンドライン
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

### GitHub Actionsでストアへアップロード

#### iOS(App Store)
GitHub Secretsに以下を設定
```
・APPLE_CERTIFICATES
キーチェーンアクセスから書き出したp12ファイル（iPhone Distribution:xxxxxxxxxxx(xxxxxx)）をbase64した値
$ base64 -i xxxxx.p12

・APPLE_PROFILE
プロビジョニングプロファイルをBase64した値
$ base64 -i xxxxx.mobileprovision

・ASC_ISSUER_ID
App Store Connect API > ISSUE ID

・ASC_KEY_ID
App Store Connect API > キーID

・ASC_API_KEY
App Store Connect API > APIキーファイルをbase64した値
$ base64 -i xxxxx.p8

・ASC_TEAM_ID
App Store Connect API > チームID

・APPLE_TEAM_ID
Apple Developer チームID

・FIREBASE_IOS_GOOGLE_SERVICE_INFO(firebase)
GoogleService-Info-prod.plistをbase64した値

$ base64 -i GoogleService-Info-prod.plist
```

#### Android(Play Store)
GitHub Secretsに以下を設定
```
・ANDROID_SIGNING
リリースビルドに必要なjksファイルとgradleファイルの2ファイルをzip圧縮したファイルをbase64した値

signing(directory)
 |- key.jks
 |- signing.gradle
   signingConfigs {
     release {
        storeFile file("key.jks")
        storePassword "xxxxx"
        keyAlias "xxxxx"
        keyPassword "xxxxx"
     }
   }

$ zip -r signing.zip signing/
$ base 64 -i signing.zip

・PLAYSTORE_SERVICE_ACCOUNT_JSON
Google Play Developer Publishing APIにアクセスするためのサービスアカウントを生成したときに生成される秘密鍵(JSON)をbase64した値

$ base64 -i api-xxxxx-xxxxx-xxxxx.json

・FIREBASE_ANDROID_GOOGLE_SERVICE_INFO(firebase)
google-services.jsonをbase64した値

$ base64 -i google-services.json
```
