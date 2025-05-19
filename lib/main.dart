import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/core/services/shared_preferences_service.dart';
import 'package:telephony_rakuten_assignment/routes/app_pages.dart';
import 'core/localization/app_translations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferencesService.init();

  final userUid = SharedPreferencesService.getString('user_uid');
  runApp(MyApp(userUid: userUid));
}

class MyApp extends StatelessWidget {
  final String? userUid;
  const MyApp({super.key, required this.userUid});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Telephony Rakuten Assignment',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: const Locale('tr'),
      fallbackLocale: const Locale('en'),
      supportedLocales: const [
        Locale('tr'),
        Locale('en'),
        Locale('ar'),
        Locale('es'),
        Locale('ja'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Gilroy',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Gilroy'),
          displayMedium: TextStyle(fontFamily: 'Gilroy'),
          displaySmall: TextStyle(fontFamily: 'Gilroy'),
          headlineLarge: TextStyle(fontFamily: 'Gilroy'),
          headlineMedium: TextStyle(fontFamily: 'Gilroy'),
          headlineSmall: TextStyle(fontFamily: 'Gilroy'),
          titleLarge: TextStyle(fontFamily: 'Gilroy'),
          titleMedium: TextStyle(fontFamily: 'Gilroy'),
          titleSmall: TextStyle(fontFamily: 'Gilroy'),
          bodyLarge: TextStyle(fontFamily: 'Gilroy'),
          bodyMedium: TextStyle(fontFamily: 'Gilroy'),
          bodySmall: TextStyle(fontFamily: 'Gilroy'),
          labelLarge: TextStyle(fontFamily: 'Gilroy'),
          labelMedium: TextStyle(fontFamily: 'Gilroy'),
          labelSmall: TextStyle(fontFamily: 'Gilroy'),
        ),
      ),
      initialRoute: userUid != null ? Routes.HOME : AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
