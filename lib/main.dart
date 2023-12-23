import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostel_finder/utils/themes.dart';
import 'package:hostel_finder/providers/theme_provider.dart';
import 'package:hostel_finder/motel_app.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(_setAllProviders()));
}

Widget _setAllProviders() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(
          state: AppTheme.getThemeData,
        ),
      ),
    ],
    child: MotelApp(),
  );
}
