import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ErrorLogger {
  // تسجيل خطأ
  static Future<void> logError(
    dynamic error,
    StackTrace? stackTrace, {
    String? hint,
    Map<String, dynamic>? extra,
  }) async {
    // طباعة في الـ Console (للـ Development)
    if (kDebugMode) {
      print('❌ ERROR: $error');
      if (hint != null) print('💡 HINT: $hint');
      if (stackTrace != null) print('📍 STACK TRACE: $stackTrace');
      if (extra != null) print('📦 EXTRA DATA: $extra');
    }

    // إرسال لـ Sentry (للـ Production)
    try {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
        hint: hint != null ? Hint.withMap({'hint': hint}) : null,
      );
      
      // إضافة بيانات إضافية
      if (extra != null) {
        Sentry.configureScope((scope) {
          extra.forEach((key, value) {
            scope.setExtra(key, value);
          });
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to send error to Sentry: $e');
      }
    }
  }

  // تسجيل رسالة
  static Future<void> logMessage(String message, {SentryLevel? level}) async {
    if (kDebugMode) {
      print('📝 MESSAGE: $message');
    }
    await Sentry.captureMessage(message, level: level ?? SentryLevel.info);
  }
}
