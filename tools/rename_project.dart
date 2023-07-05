import 'dart:io';
import 'package:ini/ini.dart';

void main() async {
  final file = File("tools/config.ini");
  final lines = await file.readAsLines();
  final config = Config.fromStrings(lines).defaults();

  const releaseFilePath = '.github/workflows/release.yml';
  const buildGradleFilePath = 'android/app/build.gradle';
  const debugManifestFilePath = 'android/app/src/debug/AndroidManifest.xml';
  const mainManifestFilePath = 'android/app/src/main/AndroidManifest.xml';
  const profileManifestFilePath = 'android/app/src/profile/AndroidManifest.xml';
  const releaseManifestFilePath = 'android/app/src/release/AndroidManifest.xml';

  final devAppName = config['DevAppName'] ?? "Dev start_app";
  final prodAppName = config['ProdAppName'] ?? "Prod start_app";
  final flutterProdPackageName = config['FlutterProdPackageName'] ?? "start_app";
  final iosDebugPackageName = config['IOSDebugPackageName'] ?? "nrikiji.start-app.dev";
  final iosProdPackageName = config['IOSProdPackageName'] ?? "nrikiji.start-app";
  final androidPackageName = config['AndroidPackageName'] ?? "com.nrikiji.start_app";
  final iosProfileName = config['IOSProfileName'] ?? "start app";

  List<String> parts = androidPackageName.split('.');
  String firstPartAndroidPackage = parts.getRange(0, parts.length - 1).join('.');
  String secondPartAndroidPackage = parts.last;

  const releaseOriginalString = 'packageName: nrikiji.flutter_start_app';
  final releaseReplacementString = 'packageName: $androidPackageName';

  const buildGradleOriginalApplicationId = 'applicationId "nrikiji.flutter_start_app"';
  final buildGradleReplacementApplicationId = 'applicationId "$androidPackageName"';

  const buildGradleOriginalDebugAppName = 'resValue "string", "app_name", "Dev flutter_start_app"';
  final buildGradleReplacementDebugAppName = 'resValue "string", "app_name", "$devAppName"';

  const buildGradleOriginalProdAppName = 'resValue "string", "app_name", "Prod flutter_start_app"';
  final buildGradleReplacementProdAppName = 'resValue "string", "app_name", "$prodAppName"';

  const manifestOriginalPackage = 'package="nrikiji.flutter_start_app"';
  final manifestReplacementPackage = 'package="$androidPackageName"';

  const mainActivityDirectoryPath = 'android/app/src/main/kotlin/nrikiji/flutter_start_app';
  var newMainActivityDirectoryPath = 'android/app/src/main/kotlin/$firstPartAndroidPackage/$secondPartAndroidPackage';
  var newMainActivityFilePath = '$newMainActivityDirectoryPath/MainActivity.kt';

  const debugXcconfigFilePath = 'ios/Flutter/Debug.xcconfig';
  const debugBundleIdentifierOriginal = 'PRODUCT_BUNDLE_IDENTIFIER = nrikiji.flutter-start-app.dev';
  final debugBundleIdentifierReplacement = 'PRODUCT_BUNDLE_IDENTIFIER = $iosDebugPackageName';
  const debugDisplayNameOriginal = 'DISPLAY_NAME = Dev flutter_start_app';
  final debugDisplayNameReplacement = 'DISPLAY_NAME = $devAppName';

  const releaseXcconfigFilePath = 'ios/Flutter/Release.xcconfig';
  const releaseBundleIdentifierOriginal = 'PRODUCT_BUNDLE_IDENTIFIER = nrikiji.flutter-start-app';
  final releaseBundleIdentifierReplacement = 'PRODUCT_BUNDLE_IDENTIFIER = $iosProdPackageName';
  const releaseDisplayNameOriginal = 'DISPLAY_NAME = Prod flutter_start_app';
  final releaseDisplayNameReplacement = 'DISPLAY_NAME = $prodAppName';

  const appFileFilePath = 'ios/fastlane/Appfile';
  const appFileOriginalAppIdentifier = 'app_identifier "nrikiji.flutter-start-app"';
  final appFileReplacementAppIdentifier = 'app_identifier "$iosProdPackageName"';

  const fastFileFilePath = 'ios/fastlane/Fastfile';
  const fastFileOriginalProfileName = "profile_name = 'flutter-start-app'";
  final fastFileReplacementProfileName = "profile_name = '$iosProfileName'";

  const pubspecFilePath = 'pubspec.yaml';
  const pubspecOriginalName = 'name: flutter_start_app';
  final pubspecReplacementName = 'name: $flutterProdPackageName';

  const libDirectoryPath = 'lib';
  const testDirectoryPath = 'test';
  const originalPackageImport = 'import \'package:flutter_start_app/';
  final replacementPackageImport = 'import \'package:$flutterProdPackageName/';

  try {
    // Replace strings in release.yml
    final releaseFile = File(releaseFilePath);
    String releaseFileContent = releaseFile.readAsStringSync();

    if (releaseFileContent.contains(releaseOriginalString)) {
      releaseFileContent = releaseFileContent.replaceAll(releaseOriginalString, releaseReplacementString);
      releaseFile.writeAsStringSync(releaseFileContent);
      // ignore: avoid_print
      print('String replaced in release.yml successfully.');
    } else {
      // ignore: avoid_print
      print('Original string not found in release.yml.');
    }

    // Replace strings in build.gradle
    final buildGradleFile = File(buildGradleFilePath);
    String buildGradleFileContent = buildGradleFile.readAsStringSync();

    if (buildGradleFileContent.contains(buildGradleOriginalApplicationId)) {
      buildGradleFileContent = buildGradleFileContent.replaceAll(buildGradleOriginalApplicationId, buildGradleReplacementApplicationId);
      buildGradleFile.writeAsStringSync(buildGradleFileContent);
      // ignore: avoid_print
      print('ApplicationId replaced in build.gradle successfully.');
    } else {
      // ignore: avoid_print
      print('ApplicationId not found in build.gradle.');
    }

    if (buildGradleFileContent.contains(buildGradleOriginalDebugAppName)) {
      buildGradleFileContent = buildGradleFileContent.replaceAll(buildGradleOriginalDebugAppName, buildGradleReplacementDebugAppName);
      buildGradleFile.writeAsStringSync(buildGradleFileContent);
      // ignore: avoid_print
      print('Debug app name replaced in build.gradle successfully.');
    } else {
      // ignore: avoid_print
      print('Debug app name not found in build.gradle.');
    }

    if (buildGradleFileContent.contains(buildGradleOriginalProdAppName)) {
      buildGradleFileContent = buildGradleFileContent.replaceAll(buildGradleOriginalProdAppName, buildGradleReplacementProdAppName);
      buildGradleFile.writeAsStringSync(buildGradleFileContent);
      // ignore: avoid_print
      print('Prod app name replaced in build.gradle successfully.');
    } else {
      // ignore: avoid_print
      print('Prod app name not found in build.gradle.');
    }

    // Replace package name in debug manifest
    final debugManifestFile = File(debugManifestFilePath);
    String debugManifestFileContent = debugManifestFile.readAsStringSync();

    if (debugManifestFileContent.contains(manifestOriginalPackage)) {
      debugManifestFileContent = debugManifestFileContent.replaceAll(manifestOriginalPackage, manifestReplacementPackage);
      debugManifestFile.writeAsStringSync(debugManifestFileContent);
      // ignore: avoid_print
      print('Package name replaced in debug AndroidManifest.xml successfully.');
    } else {
      // ignore: avoid_print
      print('Package name not found in debug AndroidManifest.xml.');
    }

    // Replace package name in main manifest
    final mainManifestFile = File(mainManifestFilePath);
    String mainManifestFileContent = mainManifestFile.readAsStringSync();

    if (mainManifestFileContent.contains(manifestOriginalPackage)) {
      mainManifestFileContent = mainManifestFileContent.replaceAll(manifestOriginalPackage, manifestReplacementPackage);
      mainManifestFile.writeAsStringSync(mainManifestFileContent);
      // ignore: avoid_print
      print('Package name replaced in main AndroidManifest.xml successfully.');
    } else {
      // ignore: avoid_print
      print('Package name not found in main AndroidManifest.xml.');
    }

    // Replace package name in profile manifest
    final profileManifestFile = File(profileManifestFilePath);
    String profileManifestFileContent = profileManifestFile.readAsStringSync();

    if (profileManifestFileContent.contains(manifestOriginalPackage)) {
      profileManifestFileContent = profileManifestFileContent.replaceAll(manifestOriginalPackage, manifestReplacementPackage);
      profileManifestFile.writeAsStringSync(profileManifestFileContent);
      // ignore: avoid_print
      print('Package name replaced in profile AndroidManifest.xml successfully.');
    } else {
      // ignore: avoid_print
      print('Package name not found in profile AndroidManifest.xml.');
    }

    // Replace package name in release manifest
    final releaseManifestFile = File(releaseManifestFilePath);
    String releaseManifestFileContent = releaseManifestFile.readAsStringSync();

    if (releaseManifestFileContent.contains(manifestOriginalPackage)) {
      releaseManifestFileContent = releaseManifestFileContent.replaceAll(manifestOriginalPackage, manifestReplacementPackage);
      releaseManifestFile.writeAsStringSync(releaseManifestFileContent);
      // ignore: avoid_print
      print('Package name replaced in release AndroidManifest.xml successfully.');
    } else {
      // ignore: avoid_print
      print('Package name not found in release AndroidManifest.xml.');
    }

    // Rename MainActivity.kt directory
    final mainActivityDirectory = Directory(mainActivityDirectoryPath);

    if (mainActivityDirectory.existsSync()) {
      renameDirectoryRecursively(mainActivityDirectory, newMainActivityDirectoryPath);
      // ignore: avoid_print
      print('MainActivity.kt directory renamed successfully.');
    } else {
      // ignore: avoid_print
      print('MainActivity.kt directory not found.');
    }

    // Replace package name in MainActivity.kt
    final mainActivityFile = File(newMainActivityFilePath);
    String mainActivityFileContent = mainActivityFile.readAsStringSync();

    if (mainActivityFileContent.contains('package nrikiji.flutter_start_app')) {
      mainActivityFileContent = mainActivityFileContent.replaceAll('package nrikiji.flutter_start_app', 'package $androidPackageName');
      mainActivityFile.writeAsStringSync(mainActivityFileContent);
      // ignore: avoid_print
      print('Package name replaced in MainActivity.kt successfully.');
    } else {
      // ignore: avoid_print
      print('Package name not found in MainActivity.kt.');
    }

    // Replace strings in Debug.xcconfig
    final debugXcconfigFile = File(debugXcconfigFilePath);
    String debugXcconfigFileContent = debugXcconfigFile.readAsStringSync();

    if (debugXcconfigFileContent.contains(debugBundleIdentifierOriginal)) {
      debugXcconfigFileContent = debugXcconfigFileContent.replaceAll(debugBundleIdentifierOriginal, debugBundleIdentifierReplacement);
      debugXcconfigFile.writeAsStringSync(debugXcconfigFileContent);
      // ignore: avoid_print
      print('Debug.xcconfig bundle identifier replaced successfully.');
    } else {
      // ignore: avoid_print
      print('Debug.xcconfig bundle identifier not found.');
    }

    if (debugXcconfigFileContent.contains(debugDisplayNameOriginal)) {
      debugXcconfigFileContent = debugXcconfigFileContent.replaceAll(debugDisplayNameOriginal, debugDisplayNameReplacement);
      debugXcconfigFile.writeAsStringSync(debugXcconfigFileContent);
      // ignore: avoid_print
      print('Debug.xcconfig display name replaced successfully.');
    } else {
      // ignore: avoid_print
      print('Debug.xcconfig display name not found.');
    }

    // Replace strings in Release.xcconfig
    final releaseXcconfigFile = File(releaseXcconfigFilePath);
    String releaseXcconfigFileContent = releaseXcconfigFile.readAsStringSync();

    if (releaseXcconfigFileContent.contains(releaseBundleIdentifierOriginal)) {
      releaseXcconfigFileContent =
          releaseXcconfigFileContent.replaceAll(releaseBundleIdentifierOriginal, releaseBundleIdentifierReplacement);
      releaseXcconfigFile.writeAsStringSync(releaseXcconfigFileContent);
      // ignore: avoid_print
      print('Release.xcconfig bundle identifier replaced successfully.');
    } else {
      // ignore: avoid_print
      print('Release.xcconfig bundle identifier not found.');
    }

    if (releaseXcconfigFileContent.contains(releaseDisplayNameOriginal)) {
      releaseXcconfigFileContent = releaseXcconfigFileContent.replaceAll(releaseDisplayNameOriginal, releaseDisplayNameReplacement);
      releaseXcconfigFile.writeAsStringSync(releaseXcconfigFileContent);
      // ignore: avoid_print
      print('Release.xcconfig display name replaced successfully.');
    } else {
      // ignore: avoid_print
      print('Release.xcconfig display name not found.');
    }

    // Replace app_identifier in Appfile
    final appFile = File(appFileFilePath);
    String appFileContent = appFile.readAsStringSync();

    if (appFileContent.contains(appFileOriginalAppIdentifier)) {
      appFileContent = appFileContent.replaceAll(appFileOriginalAppIdentifier, appFileReplacementAppIdentifier);
      appFile.writeAsStringSync(appFileContent);
      // ignore: avoid_print
      print('app_identifier replaced in Appfile successfully.');
    } else {
      // ignore: avoid_print
      print('app_identifier not found in Appfile.');
    }

    // Replace app_identifier in Fastfile
    final fastFile = File(fastFileFilePath);
    String fastFileContent = fastFile.readAsStringSync();

    if (fastFileContent.contains(fastFileOriginalProfileName)) {
      fastFileContent = fastFileContent.replaceAll(fastFileOriginalProfileName, fastFileReplacementProfileName);
      fastFile.writeAsStringSync(fastFileContent);
      // ignore: avoid_print
      print('profile name replaced in Fastfile successfully.');
    } else {
      // ignore: avoid_print
      print('profile name not found in Fastfile.');
    }

    // Replace name in pubspec.yaml
    final pubspecFile = File(pubspecFilePath);
    String pubspecFileContent = pubspecFile.readAsStringSync();

    if (pubspecFileContent.contains(pubspecOriginalName)) {
      pubspecFileContent = pubspecFileContent.replaceAll(pubspecOriginalName, pubspecReplacementName);
      pubspecFile.writeAsStringSync(pubspecFileContent);
      // ignore: avoid_print
      print('name replaced in pubspec.yaml successfully.');
    } else {
      // ignore: avoid_print
      print('name not found in pubspec.yaml.');
    }

    // Replace package import paths in dart files
    void replacePackageImports(String directoryPath) {
      final directory = Directory(directoryPath);
      final dartFiles = directory.listSync(recursive: true, followLinks: false).whereType<File>();

      for (final dartFile in dartFiles) {
        final dartFilePath = dartFile.path;
        final dartFileContent = dartFile.readAsStringSync();

        if (dartFileContent.contains(originalPackageImport)) {
          final modifiedContent = dartFileContent.replaceAll(originalPackageImport, replacementPackageImport);
          dartFile.writeAsStringSync(modifiedContent);
          // ignore: avoid_print
          print('Package import path replaced in $dartFilePath successfully.');
        }
      }
    }

    // Replace package imports in lib directory
    replacePackageImports(libDirectoryPath);

    // Replace package imports in test directory
    replacePackageImports(testDirectoryPath);
  } catch (e) {
    // ignore: avoid_print
    print('Error: $e');
  }
}

void renameDirectoryRecursively(Directory directory, String newName) {
  if (!directory.existsSync()) {
    return;
  }

  final List<FileSystemEntity> contents = directory.listSync(recursive: true);

  for (final FileSystemEntity entity in contents) {
    if (entity is File) {
      final String newPath = entity.path.replaceFirst(directory.path, newName);
      final File newFile = File(newPath);
      newFile.createSync(recursive: true);
      entity.copySync(newPath);
      entity.deleteSync();
    } else if (entity is Directory) {
      final String newPath = entity.path.replaceFirst(directory.path, newName);
      final Directory newDirectory = Directory(newPath);
      newDirectory.createSync(recursive: true);
    }
  }

  directory.deleteSync(recursive: true);
}
