import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/app_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/license_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const UniversitySchedulerApp());
}

class UniversitySchedulerApp extends StatelessWidget {
  const UniversitySchedulerApp({super.key});

  Future<bool> _checkLicense() async {
    final prefs = await SharedPreferences.getInstance();
    final expireDateStr = prefs.getString('license_expire_date');
    
    if (expireDateStr == null) {
      return false; // اولین بار است، باید لایسنس وارد شود
    }
    final expireDate = DateTime.parse(expireDateStr);
    return DateTime.now().isBefore(expireDate);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()..loadAll()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'سامانه مدیریت کلاس‌ها',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            locale: const Locale('fa', 'IR'),
            supportedLocales: const [Locale('fa', 'IR'), Locale('en', 'US')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: FutureBuilder<bool>(
              future: _checkLicense(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                if (snapshot.hasData && snapshot.data == true) {
                  return const SplashScreen(); // لایسنس معتبر است
                }
                return const LicenseScreen(); // لایسنس منقضی یا وجود ندارد
              },
            ),
          );
        },
      ),
    );
  }
}
