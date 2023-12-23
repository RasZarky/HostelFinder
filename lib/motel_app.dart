import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostel_finder/common/common.dart';
import 'package:hostel_finder/language/appLocalizations.dart';
import 'package:hostel_finder/modules/bottom_tab/bottom_tab_screen.dart';
import 'package:hostel_finder/providers/theme_provider.dart';
import 'package:hostel_finder/utils/enum.dart';
import 'package:hostel_finder/modules/splash/introductionScreen.dart';
import 'package:hostel_finder/modules/splash/splashScreen.dart';
import 'package:hostel_finder/routes/routes.dart';
import 'package:provider/provider.dart';

BuildContext? applicationcontext;

class MotelApp extends StatefulWidget {
  @override
  _MotelAppState createState() => _MotelAppState();
}

class _MotelAppState extends State<MotelApp> {

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              BottomTabScreen(
                // user: user,
              ),
        ),
      );
    }
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, provider, child) {
        applicationcontext = context;

        final ThemeData _theme = provider.themeData;
        return FutureBuilder(
          future: _initializeFirebase(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,

            ],
            supportedLocales: [
              const Locale('en'), // English
              const Locale('fr'), //French
              const Locale('ja'), // Japanises
              const Locale('ar'), //Arebic
            ],
            navigatorKey: navigatorKey,
            title: 'Hostel Finder',
            debugShowCheckedModeBanner: false,
            theme: _theme,
            routes: _buildRoutes(),
            builder: (BuildContext context, Widget? child) {
              _setFirstTimeSomeData(context, _theme);
              return Directionality(
                textDirection:
                context.read<ThemeProvider>().languageType == LanguageType.ar
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Builder(
                  builder: (BuildContext context) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaleFactor: MediaQuery.of(context).size.width > 360
                            ? 1.0
                            : MediaQuery.of(context).size.width >= 340
                            ? 0.9
                            : 0.8,
                      ),
                      child: child ?? SizedBox(),
                    );
                  },
                ),
              );
            },
          );
            },
          // child: MaterialApp(
          //   localizationsDelegates: [
          //     AppLocalizations.delegate,
          //     GlobalMaterialLocalizations.delegate,
          //     GlobalWidgetsLocalizations.delegate,
          //     GlobalCupertinoLocalizations.delegate,
          //   ],
          //   supportedLocales: [
          //     const Locale('en'), // English
          //     const Locale('fr'), //French
          //     const Locale('ja'), // Japanises
          //     const Locale('ar'), //Arebic
          //   ],
          //   navigatorKey: navigatorKey,
          //   title: 'Hostel Finder',
          //   debugShowCheckedModeBanner: false,
          //   theme: _theme,
          //   routes: _buildRoutes(),
          //   builder: (BuildContext context, Widget? child) {
          //     _setFirstTimeSomeData(context, _theme);
          //     return Directionality(
          //       textDirection:
          //           context.read<ThemeProvider>().languageType == LanguageType.ar
          //               ? TextDirection.rtl
          //               : TextDirection.ltr,
          //       child: Builder(
          //         builder: (BuildContext context) {
          //           return MediaQuery(
          //             data: MediaQuery.of(context).copyWith(
          //               textScaleFactor: MediaQuery.of(context).size.width > 360
          //                   ? 1.0
          //                   : MediaQuery.of(context).size.width >= 340
          //                       ? 0.9
          //                       : 0.8,
          //             ),
          //             child: child ?? SizedBox(),
          //           );
          //         },
          //       ),
          //     );
          //   },
          // ),
        );
      },
    );
  }

// when this application open every time on that time we check and update some theme data
  void _setFirstTimeSomeData(BuildContext context, ThemeData theme) {
    applicationcontext = context;
    _setStatusBarNavigationBarTheme(theme);
    //we call some theme basic data set in app like color, font, theme mode, language
    context
        .read<ThemeProvider>()
        .checkAndSetThemeMode(MediaQuery.of(context).platformBrightness);
    context.read<ThemeProvider>().checkAndSetColorType();
    context.read<ThemeProvider>().checkAndSetFonType();
    context.read<ThemeProvider>().checkAndSetLanguage();
  }

  void _setStatusBarNavigationBarTheme(ThemeData themeData) {
    final brightness = !kIsWeb && Platform.isAndroid
        ? themeData.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light
        : themeData.brightness;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: brightness,
      statusBarBrightness: brightness,
      systemNavigationBarColor: themeData.scaffoldBackgroundColor,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: brightness,
    ));
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      RoutesName.Splash: (BuildContext context) => SplashScreen(),
      RoutesName.IntroductionScreen: (BuildContext context) =>
          IntroductionScreen(),
    };
  }
}
