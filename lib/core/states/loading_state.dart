// lib/core/states/loading_state.dart

/// 🔄 Loading State
/// تمثيل حالات التحميل المختلفة
enum LoadingState {
  /// لم يتم البدء بعد
  initial,

  /// جاري التحميل
  loading,

  /// تم التحميل بنجاح
  success,

  /// حدث خطأ
  error,

  /// تحميل إضافي (Pagination)
  loadingMore,

  /// تحديث البيانات
  refreshing,
}

extension LoadingStateExtension on LoadingState {
  /// هل حالة التحميل جارية؟
  bool get isLoading =>
      this == LoadingState.loading ||
      this == LoadingState.loadingMore ||
      this == LoadingState.refreshing;

  /// هل تم التحميل بنجاح؟
  bool get isSuccess => this == LoadingState.success;

  /// هل حدث خطأ؟
  bool get isError => this == LoadingState.error;

  /// هل الحالة initial؟
  bool get isInitial => this == LoadingState.initial;

  /// هل يمكن عرض البيانات؟
  bool get canShowContent => this != LoadingState.initial && this != LoadingState.loading;
}
