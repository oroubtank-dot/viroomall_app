# 📚 دليل Loading States

## نظرة عامة

نظام إدارة حالات التحميل في VirooMall يوفر طريقة موحدة وسهلة لتتبع حالة التحميل في التطبيق.

---

## 🔄 حالات التحميل

```dart
enum LoadingState {
  initial,      // لم يتم البدء بعد
  loading,      // جاري التحميل
  success,      // تم التحميل بنجاح
  error,        // حدث خطأ
  loadingMore,  // تحميل إضافي (Pagination)
  refreshing,   // تحديث البيانات
}
```

---

## 💻 أمثلة الاستخدام

### مثال 1: Global Loading

```dart
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingState = ref.watch(loadingProvider);

    return loadingState.isLoading
        ? const VirooLoadingIndicator(message: 'جاري التحميل...')
        : const MyContent();
  }
}
```

### مثال 2: Feature-specific Loading

```dart
class ProductsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingState = ref.watch(productsLoadingProvider);
    final products = ref.watch(productsProvider);

    return switch (loadingState) {
      LoadingState.loading => const LoadingGridShimmer(),
      LoadingState.error => ErrorWidgetDisplay(
          message: 'فشل تحميل المنتجات',
        ),
      _ => ListView(
          children: products.map((p) => ProductTile(p)).toList(),
        ),
    };
  }
}
```

### مثال 3: مع Execute Method

```dart
final authService = AuthService();
final notifier = ref.read(authLoadingProvider.notifier);

final user = await notifier.execute(
  () => authService.verifyOTP(code: '123456'),
);
```

### مثال 4: Skeleton Loading

```dart
LoadingState loadingState = LoadingState.loading;

return loadingState == LoadingState.loading
    ? const LoadingGridShimmer(
        itemCount: 6,
        crossAxisCount: 2,
      )
    : GridView(
        // content
      );
```

---

## 🎨 UI Components

### 1. LoadingOverlay
```dart
LoadingOverlay(
  child: MyContent(),
  useGlobalProvider: true,
)
```

### 2. LoadingShimmer
```dart
LoadingShimmer(
  width: 200,
  height: 150,
  borderRadius: BorderRadius.circular(12),
)
```

### 3. LoadingGridShimmer
```dart
LoadingGridShimmer(
  itemCount: 6,
  crossAxisCount: 2,
  itemHeight: 200,
)
```

### 4. LoadingListShimmer
```dart
LoadingListShimmer(
  itemCount: 5,
  itemHeight: 100,
)
```

### 5. VirooLoadingIndicator
```dart
VirooLoadingIndicator(
  message: 'جاري التحميل...',
  size: 50,
  color: VirooColors.primary,
)
```

---

## 🔄 Pattern: Loading → Success → Error

```dart
final authProvider = FutureProvider((ref) async {
  final notifier = ref.read(authLoadingProvider.notifier);
  try {
    // 1. set loading
    notifier.setLoading();
    
    // 2. do operation
    final result = await authService.login();
    
    // 3. set success
    notifier.setSuccess();
    return result;
  } catch (e) {
    // 4. set error
    notifier.setError();
    rethrow;
  }
});
```

---

## 📊 Pagination

```dart
class ProductsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingState = ref.watch(productsLoadingProvider);
    final products = ref.watch(productsProvider);

    void loadMore() {
      ref.read(productsLoadingProvider.notifier).setLoadingMore();
      ref.refresh(productsProvider);
    }

    return ListView.builder(
      itemCount: products.length + 1,
      itemBuilder: (context, index) {
        if (index == products.length) {
          return loadingState == LoadingState.loadingMore
              ? const VirooLoadingIndicator()
              : const SizedBox();
        }
        return ProductTile(products[index]);
      },
    );
  }
}
```

---

## 🔄 Pull-to-Refresh

```dart
refreshCallback: () async {
  final notifier = ref.read(productsLoadingProvider.notifier);
  notifier.setRefreshing();
  await ref.refresh(productsProvider);
}
```

---

## 📞 الدعم

للأسئلة:
- 📧 oroub.tank@gmail.com
- 🐙 GitHub Issues

