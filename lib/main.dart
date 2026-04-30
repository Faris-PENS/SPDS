import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spds/core/supabase/supabase_init.dart';
import 'package:spds/core/style/theme.dart';
import 'package:spds/presentation/sign_in/sign_in_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spds/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestPermission();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();
  await SupabaseInit.init();
  
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('id', 'ID')
        ],
        path: 'assets/langs',
        fallbackLocale: const Locale('en', 'US'),
        useFallbackTranslations: true,
        child: const MyApp(),
      ),
    ),
  );
}
  




  
Future<void> _requestPermission() async {
  await Permission.location.request();
  await Permission.nearbyWifiDevices.request();
  await Permission.notification.request(); 
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppThemeData.darkTheme,
      darkTheme: AppThemeData.darkTheme,
      themeMode: ThemeMode.dark,
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
    );
  }
}