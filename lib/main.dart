import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_start_app/controller/app/app_controller.dart';
import 'package:flutter_start_app/controller/app/app_state.dart';
import 'package:flutter_start_app/localize.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      return runApp(ProviderScope(child: MyApp()));
    },
    (e, st) {
      log(e.toString());
      log(st.toString());
    },
  );
}

final appController = StateNotifierProvider<AppController, AppState>((ref) => AppController());

class MyApp extends StatelessWidget {
  final _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.hasError) {
            return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData.light().copyWith(
                primaryColor: Colors.white,
                primaryColorBrightness: Brightness.light,
                accentColor: Colors.blue,
                primaryTextTheme: TextTheme(
                  headline6: TextStyle(color: Colors.black),
                ),
                primaryIconTheme: IconThemeData(
                  color: Colors.black,
                ),
                colorScheme: ColorScheme.light(
                  primary: Colors.black,
                ),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                ),
                buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
              ),
              darkTheme: ThemeData.dark().copyWith(
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
                buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                  buttonColor: Colors.white,
                ),
              ),
              localizationsDelegates: [
                const AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en'),
                const Locale('ja'),
              ],
              home: Consumer(
                builder: (context, watch, _) {
                  final initialized = watch(appController).initialized;
                  return initialized
                      ? Scaffold(body: Center(child: Text("first screen")))
                      : Scaffold(body: Center(child: SizedBox.shrink()));
                },
              ),
            );
          }
          return SizedBox.shrink();
        });
  }
}