import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/app_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تنظیم نوار وضعیت (Status Bar)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF17365D),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // جهت عمودی
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const UniversitySchedulerApp());
}

class UniversitySchedulerApp extends StatelessWidget {
  const UniversitySchedulerApp({super.key});

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
            supportedLocales: const [
              Locale('fa', 'IR'),
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              // اطمینان از اینکه فونت‌ها در همه‌جا یکسان هستند
              return Directionality(
                textDirection: TextDirection.rtl,
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}