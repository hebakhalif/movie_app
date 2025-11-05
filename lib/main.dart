import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/constants/api_constants.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'core/cache/cache_helper.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'screens/movies_list_screen.dart';

void main() async {
  // التأكد من تهيئة Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Hive Cache
  await CacheHelper.init();
  print('✅ Cache initialized');

  // تهيئة Sentry (Error Logging)
  await SentryFlutter.init(
    (options) {
      options.dsn = ApiConstants.apiKey; // هنحطها بعدين
      options.tracesSampleRate = 1.0; // 100% of transactions
      options.debug = true; // للـ Development بس
    },
    appRunner: () => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
           // title: 'Movie App',
            debugShowCheckedModeBanner: false,
            
            // الثيمات
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            
            // الشاشة الأولى
            home: const MoviesListScreen(),
          );
        },
      ),
    );
  }
}