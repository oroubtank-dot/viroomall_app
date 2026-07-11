# 🛍️ VirooMall - سوق متكامل بأنماط تسوق متعددة

## 📱 نظرة عامة

**VirooMall** هو تطبيق سوق إلكتروني احترافي مبني بـ **Flutter** يدعم 4 أنماط تسوق مختلفة مع ميزات عالمية متقدمة.

### 🎯 الأنماط الأربعة

| الوضع | الوصف | المستخدمون |
|-------|-------|----------|
| 🛍️ **Farz** | تسوق فردي عادي | المشترين العاديين |
| 🏪 **Gomla** | تسوق بالجملة | التجار والبائعين |
| ♻️ **Tasawok** | بيع وشراء المستعمل | هواة المستعمل |
| 🔥 **Mosta3mal** | تخفيضات وتصفية | محبي العروض |

---

## ✨ الميزات الرئيسية

### 🔐 الأمان والمصادقة
- ✅ تسجيل دخول برقم الهاتف + OTP
- ✅ بصمة إصبع (Biometric Authentication)
- ✅ جلسات آمنة مع Firebase
- ✅ معالجة شاملة للأخطاء

### 🛒 التسوق والدفع
- ✅ عربة تسوق متقدمة مع Sync Firebase
- ✅ المنتجات المفضلة
- ✅ نظام طلبات متكامل
- ✅ تتبع الطلبات في الوقت الفعلي
- ✅ محفظة إلكترونية
- ✅ نظام نقاط ومكافآت

### 👥 البائع والمشتري
- ✅ لوحة تحكم البائع (Dashboard)
- ✅ إدارة المنتجات (إضافة/تعديل/حذف)
- ✅ إحصائيات المبيعات
- ✅ إدارة الطلبات
- ✅ نظام التقييمات والآراء

### 📢 الإعلانات والتسويق
- ✅ إعلانات مدفوعة
- ✅ نظام الإعلانات المرئية
- ✅ الاشتراك في الإعلانات

### 🔔 التنبيهات والإشعارات
- ✅ إشعارات فورية (Push Notifications)
- ✅ تنبيهات الطلبات
- ✅ تنبيهات الرسائل

### 🔍 البحث والفلترة
- ✅ بحث متقدم
- ✅ البحث بالصوت 🎤
- ✅ البحث بالصورة 📷
- ✅ فلترة حسب الفئة والسعر والموقع

### 🎨 تجربة المستخدم
- ✅ واجهة مظلمة (Dark Mode) احترافية
- ✅ دعم اللغة العربية والإنجليزية (RTL)
- ✅ تأثيرات انتقالية سلسة
- ✅ تحميل skeleton بدلاً من loading بسيط

---

## 🛠️ التقنيات المستخدمة

### Frontend
```dart
Flutter 3.x+
Dart 3.0+
Riverpod (State Management)
GoRouter (Navigation)
```

### Backend & Services
```
Firebase:
  - Authentication (Phone + OTP)
  - Firestore (Real-time Database)
  - Storage (File Upload)
  - Cloud Messaging (Push Notifications)
```

### UI/UX Libraries
```dart
- google_fonts: Custom fonts
- flutter_svg: SVG support
- shimmer: Skeleton loading
- carousel_slider: Image carousel
- smooth_page_indicator: Page indicators
- local_auth: Biometric authentication
- image_cropper: Image cropping
- flutter_image_compress: Image compression
- video_player: Video playback
- video_compress: Video compression
```

---

## 📁 هيكل المشروع

```
lib/
├── main.dart                          # نقطة البداية
├── firebase_options.dart              # إعدادات Firebase
│
├── core/                              # الملفات الأساسية المشتركة
│   ├── exceptions/                    # فئات الأخطاء
│   │   └── app_exception.dart        # Base exception class
│   ├── services/                      # الخدمات الأساسية
│   │   ├── auth_service.dart         # خدمة المصادقة
│   │   ├── product_service.dart      # خدمة المنتجات
│   │   ├── storage_service.dart      # خدمة التخزين المحلي
│   │   ├── notification_service.dart # خدمة الإشعارات
│   │   ├── error_handler.dart        # معالج الأخطاء
│   │   └── error_logger.dart         # تسجيل الأخطاء
│   ├── states/                        # حالات التطبيق
│   │   ├── loading_state.dart        # حالات التحميل
│   │   └── error_state.dart          # حالات الأخطاء
│   ├── notifiers/                     # Riverpod Notifiers
│   │   ├── loading_notifier.dart     # مدير التحميل
│   │   └── error_notifier.dart       # مدير الأخطاء
│   ├── providers/                     # Riverpod Providers
│   │   ├── loading_provider.dart     # providers التحميل
│   │   └── error_provider.dart       # providers الأخطاء
│   ├── types/                         # Custom Types
│   │   └── result_type.dart          # Result/Either Pattern
│   ├── constants/                     # الثوابت
│   │   ├── market_type.dart          # أنماط السوق (Enum)
│   │   └── pricing_config.dart       # إعدادات الأسعار
│   ├── models/                        # النماذج الأساسية
│   │   ├── product_model.dart        # نموذج المنتج
│   │   └── order_model.dart          # نموذج الطلب
│   ├── theme/                         # المظهر والألوان
│   │   ├── app_colors.dart           # الألوان
│   │   ├── app_theme.dart            # موضوع التطبيق
│   │   └── app_widgets.dart          # widgets مخصصة
│   └── widgets/                       # Widgets مشتركة
│       ├── loading_overlay.dart      # Loading overlay
│       ├── loading_shimmer.dart      # Skeleton loading
│       ├── loading_indicator.dart    # مؤشر التحميل
│       ├── error_dialog.dart         # Error dialog
│       ├── error_snackbar.dart       # Error snackbar
│       ├── error_widget_display.dart # Error display
│       ├── error_boundary.dart       # Error boundary
│       ├── viroo_background.dart     # Background
│       ├── viroo_search_bar.dart     # Search bar
│       └── cart_notification.dart    # Cart notification
│
├── features/                          # الميزات (كل ميزة في مجلد منفصل)
│   ├── auth/                          # المصادقة
│   │   ├── login_screen.dart
│   │   ├── otp_screen.dart
│   │   ├── providers/
│   │   └── widgets/
│   ├── home/                          # الصفحة الرئيسية
│   │   └── presentation/
│   │       ├── screens/
│   │       ├── providers/
│   │       └── widgets/
│   ├── products/                      # المنتجات (Farz)
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── cart/                          # السلة
│   │   └── presentation/
│   ├── favorites/                     # المفضلة
│   │   └── presentation/
│   ├── orders/                        # الطلبات
│   │   ├── domain/
│   │   └── presentation/
│   ├── profile/                       # الملف الشخصي
│   │   ├── domain/
│   │   └── presentation/
│   ├── admin/                         # لوحة تحكم البائع
│   │   └── presentation/
│   ├── ads/                           # الإعلانات
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── reviews/                       # التقييمات
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── search/                        # البحث
│   │   └── presentation/
│   ├── settings/                      # الإعدادات
│   │   └── presentation/
│   ├── wallet/                        # المحفظة
│   │   ├── domain/
│   │   └── presentation/
│   ├── notifications/                 # الإشعارات
│   │   └── presentation/
│   ├── farz/                          # تسوق فردي
│   ├── gomla/                         # تسوق جملة
│   ├── tasawok/                       # مستعمل
│   └── mosta3mal/                     # تخفيضات
│
└── l10n/                              # التعريب (Localization)
    ├── app_ar.arb                    # العربية
    └── app_en.arb                    # الإنجليزية
```

---

## 🚀 البدء السريع

### المتطلبات
```bash
- Flutter SDK 3.x+
- Dart 3.0+
- Firebase Project
- Android/iOS development environment
```

### التثبيت

```bash
# 1. استنساخ المشروع
git clone https://github.com/oroubtank-dot/viroomall_app.git
cd viroomall_app

# 2. تثبيت المكتبات
flutter pub get

# 3. تشغيل المشروع
flutter run
```

### إعداد Firebase

1. أنشئ مشروع على [Firebase Console](https://console.firebase.google.com)
2. حمّل `google-services.json` و `GoogleService-Info.plist`
3. ضعهما في المسارات المناسبة:
   - Android: `android/app/`
   - iOS: `ios/Runner/`
4. فعّل المصادقة والـ Firestore و Storage

### ملف .env

أنشئ ملف `.env` في جذر المشروع:

```env
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
```

---

## 📚 دليل الاستخدام

### Error Handling

```dart
import 'package:viroomall_app/core/services/error_handler.dart';
import 'package:viroomall_app/core/exceptions/app_exception.dart';

// التقاط الخطأ
try {
  final product = await productService.getProduct(id);
} on AppException catch (e) {
  // معالجة الخطأ بشكل آمن
  print('خطأ: ${e.message}');
} catch (e, stackTrace) {
  // تحويل أي exception لـ AppException
  final appException = ErrorHandler().handleException(
    e,
    stackTrace: stackTrace,
  );
}
```

### Loading States

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viroomall_app/core/providers/loading_provider.dart';

class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingState = ref.watch(productsLoadingProvider);

    return loadingState.isLoading
        ? const VirooLoadingIndicator(message: 'جاري التحميل...')
        : const MyContent();
  }
}
```

### Error Display

```dart
import 'package:viroomall_app/core/widgets/error_boundary.dart';

ErrorBoundary(
  showAsDialog: true,
  child: MyScreen(),
)
```

---

## 🧪 الاختبار

```bash
# تشغيل الاختبارات
flutter test

# تشغيل اختبارات مع التغطية
flutter test --coverage
```

---

## 📦 البناء والنشر

### Android

```bash
# APK Release
flutter build apk --release

# App Bundle (Google Play)
flutter build appbundle --release
```

### iOS

```bash
# Build for iOS
flutter build ios --release
```

---

## 🤝 المساهمة

نرحب بالمساهمات! يرجى:

1. Fork المشروع
2. انشئ branch للميزة الجديدة: `git checkout -b feature/AmazingFeature`
3. Commit التغييرات: `git commit -m 'Add AmazingFeature'`
4. Push للـ branch: `git push origin feature/AmazingFeature`
5. افتح Pull Request

---

## 📋 معايير الكود

- ✅ استخدام Clean Architecture
- ✅ معالجة الأخطاء الشاملة
- ✅ التعليقات والتوثيق
- ✅ اتباع Dart/Flutter Best Practices
- ✅ استخدام Riverpod للـ State Management
- ✅ دعم العربية والإنجليزية

---

## 📄 الترخيص

هذا المشروع مرخص تحت رخصة MIT - انظر ملف [LICENSE](LICENSE) للتفاصيل.

---

## 👨‍💼 الفريق

**المطور الأساسي:** oroubtank-dot

---

## 📞 التواصل

- 📧 البريد: oroub.tank@gmail.com
- 🐙 GitHub: [@oroubtank-dot](https://github.com/oroubtank-dot)

---

## 🙏 شكر خاص

شكر لمجتمع Flutter العربي على الدعم المستمر!

---

## 🗺️ الخارطة الطريقية (Roadmap)

### المرحلة الحالية (v1.0)
- ✅ البنية الأساسية
- ✅ المصادقة
- ✅ الأنماط الأربعة
- 🚧 نظام الدفع
- 🚧 نظام التقييمات المتقدم

### المستقبل (v2.0+)
- 🔜 الدعم متعدد العملات
- 🔜 لوحة تحكم Admin
- 🔜 نظام الإحالات
- 🔜 التسويق بالعمولة
- 🔜 تطبيق ويب (Web)

---

**تم إنشاء هذا المشروع بحب من قبل فريق VirooMall** ❤️
