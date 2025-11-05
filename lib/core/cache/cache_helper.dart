import 'package:hive_flutter/hive_flutter.dart';

class CacheHelper {
  static const String _moviesBoxName = 'movies_cache';
  static late Box _moviesBox;

  // تهيئة Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    _moviesBox = await Hive.openBox(_moviesBoxName);
  }

  static Future<void> cacheMovies(int page, List<Map<String, dynamic>> movies) async {
    await _moviesBox.put('page_$page', movies);
    print('✅ Cached ${movies.length} movies for page $page');
  }

  static List<Map<String, dynamic>>? getCachedMovies(int page) {
    final data = _moviesBox.get('page_$page');
    if (data != null) {
      print('✅ Retrieved ${(data as List).length} movies from cache for page $page');
      return List<Map<String, dynamic>>.from(data);
    }
    print(' No cached data for page $page');
    return null;
  }

  static Future<void> clearCache() async {
    await _moviesBox.clear();
    print('🗑️ Cache cleared');
  }

  static Future<void> deletePage(int page) async {
    await _moviesBox.delete('page_$page');
  }
}