# flutter_starter

flutterで毎回行っている作業や設定を予めテンプレート化したプロジェクトです。

flutterのバージョンは3.7.2

主な設定は以下のとおり。
- ビルド設定(Debug or Release)ごとに、アプリ名・アプリID(Bundle Identifier、Application Id)を切り替えることができる
- ビルド時に環境(Dev or Prod)ごとに定義した値で切り替える(Web Apiの接続先など)ことができる
- Firebase SDKを組み込んでいる。また、ビルド設定(Debug or Release)ごとに、設定ファイルを切り替えることができる
- GitHub Actionsを利用してApp StoreまたはPlay Storeへアップロードすることができる
- 多言語対応

※ アップロードのタイミングはgit tag

セットアップ手順
1. [プロジェクトのクローン](#プロジェクトのクローン)
1. [git管理対象外のファイルを手動で追加する](#git管理対象外のファイルを手動で追加する)
1. [AndroidStudioビルド設定](#androidstudioビルド設定)
1. [GitHub Actions設定](#github-actions設定)
1. [プロジェクト名リネーム](#プロジェクト名リネーム)

## セットアップ手順

### プロジェクトのクローン
```
$ git clone https://github.com/nrikiji/flutter_starter.git
```

### git管理対象外のファイルを手動で追加する
公開したくないファイルはgitの管理対象外(.gitignore)としているので手動で追加する。

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

* signing.gradle の内容
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

### AndroidStudioビルド設定

Android Studioの「Edit Configurations」よりdebugとreleaseを追加する

debug: 「Addional arguments」に「--dart-define env=dev」を設定<br/>
<img src="https://user-images.githubusercontent.com/4780752/112789737-b883b480-9098-11eb-9a02-6e168dc2c62e.png" width="400" />

release: 「Addional arguments」に「--release --dart-define env=prod」を設定<br/>
<img src="https://user-images.githubusercontent.com/4780752/112789731-b6215a80-9098-11eb-9911-17645c277507.png" width="400"/>

※コマンドラインでビルドする場合
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

### GitHub Actions設定

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
App Store Connect API > APIキーファイルの内容
$ cat xxxxx.p8

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

   * signing.gradle の内容
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
Google Play Developer Publishing APIにアクセスするためのサービスアカウントを生成したときに生成される秘密鍵(JSON)をbase64した値

$ base64 -i api-xxxxx-xxxxx-xxxxx.json

・FIREBASE_ANDROID_GOOGLE_SERVICE_INFO(firebase)
google-services.jsonをbase64した値

$ base64 -i google-services.json
```

### プロジェクト名リネーム
flutter_start_appというプロジェクト名のため、適当なプロジェクト名に変更する。
変更箇所は以下を参照(flutter_start_appをstart_appに変更する例)

https://github.com/nrikiji/flutter_starter/commit/862703e5365adf55267984608bec994067a2410b