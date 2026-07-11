# 📚 دليل Error Handling

## نظرة عامة

نظام معالجة الأخطاء في VirooMall مصمم ليكون **شاملاً وآمناً وسهل الاستخدام**.

---

## 🏗️ العمارة

```
Exception (أي خطأ)
    ↓
ErrorHandler (معالج موحد)
    ↓
AppException (فئة موحدة)
    ↓
ErrorLogger (تسجيل)
    ↓
ErrorNotifier (إدارة الحالة)
    ↓
UI (عرض للمستخدم)
```

---

## 📂 أنواع الأخطاء

### 1. Network Exceptions
```dart
// خطأ في الاتصال
NetworkException(message: 'لا يوجد اتصال')

// خطأ Server
ServerException(message: 'خطأ في الخادم')

// انتظار طويل
TimeoutException(message: 'انقطع الاتصال')
```

### 2. Auth Exceptions
```dart
// مستخدم غير مصرح
UnauthorizedException()

// ممنوع من الوصول
ForbiddenException()

// خطأ في OTP
OTPException(message: 'رمز خاطئ')
```

### 3. Validation Exceptions
```dart
// خطأ في البيانات
ValidationException(
  message: 'البيانات خاطئة',
  fieldErrors: {
    'email': 'البريد غير صحيح',
    'phone': 'الهاتف غير صحيح',
  },
)

// البيانات غير موجودة
NotFoundException()
```

### 4. Business Exceptions
```dart
// رصيد غير كافي
InsufficientBalanceException()

// المنتج غير متاح
OutOfStockException()

// خطأ عام
BusinessException(message: 'الخطأ')
```

---

## 💻 الاستخدام

### المثال 1: معالجة بسيطة

```dart
try {
  await authService.verifyOTP(code: '123456');
} on OTPException catch (e) {
  print('❌ رمز خاطئ: ${e.message}');
} on AppException catch (e) {
  print('❌ خطأ: ${e.message}');
}
```

### المثال 2: مع Riverpod

```dart
final loginProvider = FutureProvider((ref) async {
  try {
    final result = await authService.sendOTP(phone: '+201234567890');
    return result;
  } on AppException catch (e) {
    ref.read(errorProvider.notifier).showError(e);
    rethrow;
  }
});
```

### المثال 3: مع Retry Logic

```dart
final products = await ErrorHandler().retryOperation(
  () => productService.getProducts(),
  maxAttempts: 3,
  delay: const Duration(milliseconds: 1000),
);
```

### المثال 4: في الـ UI

```dart
class ProductsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    final errorState = ref.watch(errorProvider);

    return ErrorBoundary(
      child: productsAsync.when(
        data: (products) => ListView(
          children: products.map((p) => ProductTile(p)).toList(),
        ),
        loading: () => const VirooLoadingIndicator(),
        error: (error, stack) => ErrorWidgetDisplay(
          message: error.toString(),
          onRetry: () => ref.refresh(productsProvider),
        ),
      ),
    );
  }
}
```

---

## 🎯 أفضل الممارسات

### ✅ افعل

```dart
// استخدم AppException
try {
  // operation
} on AppException catch (e) {
  ErrorLogger.logError(e);
}

// استخدم Result pattern
Result<Product> result = await getProduct(id);
if (result.isSuccess) {
  final product = result.asSuccess.data;
}

// سجل الأخطاء
ErrorLogger.logError(exception, stackTrace: stackTrace);
```

### ❌ لا تفعل

```dart
// لا تتجاهل الأخطاء
try {
  // operation
} catch (e) {
  // ❌ تجاهل
}

// لا تستخدم طباعة عادية
print('Error: $error'); // ❌ استخدم ErrorLogger

// لا تعرض stack trace للمستخدم
ScaffoldMessenger.showSnackBar(
  SnackBar(content: Text(stackTrace.toString())), // ❌
);
```

---

## 🔍 Debugging

### تفعيل Debug Logging

```dart
// في main.dart
void main() {
  // ErrorLogger سيطبع تفاصيل كاملة في debug mode
  runApp(const MyApp());
}
```

### الملفات المسجلة

في Debug mode، ستشوف:
```
════════════════════════════════════════════════════════════════════════════════
🔴 [ERROR] ERROR LOG
════════════════════════════════════════════════════════════════════════════════
📋 Type: OTPException
⏰ Time: 2026-07-11 10:30:45.123456
📝 Message: رمز التحقق غير صحيح
🏷️ Code: INVALID_OTP

🔗 Original Exception: FirebaseAuthException

📄 Stack Trace:
#0      AuthService.verifyOTP (package:viroomall_app/core/services/auth_service.dart:79:5)
#1      _login (package:viroomall_app/features/auth/providers/auth_provider.dart:45:8)
════════════════════════════════════════════════════════════════════════════════
```

---

## 📊 الإحصائيات والتحليل

### دمج مع Sentry

```dart
// TODO في المستقبل
// 1. إضافة Sentry SDK
// 2. تفعيل تحليل الأخطاء
// 3. عرض تقارير مفصلة
```

---

## 🚨 التنبيهات الهامة

1. **لا تعرض stack traces** للمستخدم النهائي
2. **استخدم رسائل ودية** بالعربية
3. **قدم خيار Retry** عند الأخطاء الشبكية
4. **سجل كل الأخطاء** للتحليل اللاحق
5. **تعامل مع الحالات الخاصة** (Auth, Validation, Business)

---

## 📞 الدعم

للأسئلة حول Error Handling:
- 📧 oroub.tank@gmail.com
- 🐙 GitHub Issues

