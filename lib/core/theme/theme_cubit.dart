import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

// States
class ThemeState {
  final bool isDarkMode;
  
  ThemeState({required this.isDarkMode});
}

// Cubit
class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeBoxName = 'theme_box';
  static const String _themeKey = 'is_dark_mode';
  
  ThemeCubit() : super(ThemeState(isDarkMode: false)) {
    _loadTheme();
  }
  
  // تحميل الثيم المحفوظ
  Future<void> _loadTheme() async {
    final box = await Hive.openBox(_themeBoxName);
    final isDark = box.get(_themeKey, defaultValue: false) as bool;
    emit(ThemeState(isDarkMode: isDark));
  }
  
  // تبديل الثيم
  Future<void> toggleTheme() async {
    final newValue = !state.isDarkMode;
    emit(ThemeState(isDarkMode: newValue));
    
    // حفظ الثيم
    final box = await Hive.openBox(_themeBoxName);
    await box.put(_themeKey, newValue);
  }
}