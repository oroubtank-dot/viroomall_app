// lib/core/notifiers/loading_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/loading_state.dart';

/// 🔄 Loading Notifier
/// مدير حالات التحميل
class LoadingNotifier extends StateNotifier<LoadingState> {
  LoadingNotifier() : super(LoadingState.initial);

  /// ابدأ التحميل
  void setLoading() {
    state = LoadingState.loading;
  }

  /// تعيين النجاح
  void setSuccess() {
    state = LoadingState.success;
  }

  /// تعيين الخطأ
  void setError() {
    state = LoadingState.error;
  }

  /// تحميل إضافي
  void setLoadingMore() {
    state = LoadingState.loadingMore;
  }

  /// تحديث
  void setRefreshing() {
    state = LoadingState.refreshing;
  }

  /// إعادة تعيين
  void reset() {
    state = LoadingState.initial;
  }

  /// تنفيذ عملية مع إدارة الحالة تلقائياً
  Future<T> execute<T>(
    Future<T> Function() operation, {
    bool setLoadingMore = false,
  }) async {
    try {
      if (setLoadingMore) {
        this.setLoadingMore();
      } else {
        setLoading();
      }

      final result = await operation();
      setSuccess();
      return result;
    } catch (e) {
      setError();
      rethrow;
    }
  }
}
