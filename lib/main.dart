import 'dart:io';
import 'dart:ui';

import 'package:calendar_view/calendar_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meeting_room/common/color_schemes.dart';
import 'package:meeting_room/common/firebase_options.dart';
import 'package:meeting_room/model/calender_event.dart';
import 'package:meeting_room/router.dart';
import 'package:meeting_room/view/calender_screen/calender_screen_controller.dart';
import 'package:meeting_room/view/login/login_screen_controller.dart';
import 'package:provider/provider.dart';



const FlutterSecureStorage secureStorage = FlutterSecureStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    Firestore.initialize('coredax-meeting');
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  // ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState()  {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // appThemeSetting();
    });
  }

  Future<void> appThemeSetting() async {
    String? themType = await secureStorage.read(key: 'themeType');

    if(themType != null && themType == 'light'){
      changeTheme(ThemeMode.light);
    } else if(themType != null && themType == 'dark'){
      changeTheme(ThemeMode.dark);
    } else {
      changeTheme(ThemeMode.light);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginScreenController>(
            create: (_) => LoginScreenController()),
        ChangeNotifierProvider<CalenderScreenController>(
            create: (_) => CalenderScreenController()),
      ],
      child: Consumer<CalenderScreenController>(
        builder: (BuildContext context, controller, Widget? child) {
          return CalendarControllerProvider<CalenderEvent>(
            controller: controller.scheduleController,
            child: MaterialApp.router(
              routerConfig: router,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
              darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
              themeMode: _themeMode,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('ko', 'KR'),
                Locale('en', 'EN'),
              ],
              scrollBehavior: const ScrollBehavior().copyWith(
                dragDevices: {
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> changeTheme(ThemeMode themeMode) async {
    themeMode == ThemeMode.light
        ? await secureStorage.write(key: 'themeType', value: 'light')
        : themeMode == ThemeMode.dark
        ? await secureStorage.write(key: 'themeType', value: 'dark')
        : await secureStorage.write(key: 'themeType', value: 'system');
    setState(() {
      _themeMode = themeMode;
    });
  }
}
