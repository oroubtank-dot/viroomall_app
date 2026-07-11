# 🤝 دليل المساهمة

شكراً لك على اهتمامك بالمساهمة في VirooMall! 🎉

## 📋 قبل البدء

- اقرأ README.md
- اقرأ الدليل المعماري: `docs/ARCHITECTURE.md`
- افهم معالجة الأخطاء: `docs/ERROR_HANDLING.md`
- افهم حالات التحميل: `docs/LOADING_STATES.md`

---

## 🚀 خطوات المساهمة

### 1. Fork المشروع
```bash
git clone https://github.com/YOUR_USERNAME/viroomall_app.git
cd viroomall_app
```

### 2. أنشئ Branch جديد
```bash
# للميزات الجديدة
git checkout -b feature/your-feature-name

# للإصلاحات
git checkout -b fix/your-bug-fix

# للتحسينات
git checkout -b improvement/your-improvement
```

### 3. قم بالتطوير

**اتبع معايير الكود:**
- ✅ استخدم Clean Architecture
- ✅ اتبع Dart/Flutter Best Practices
- ✅ استخدم `const` عند الإمكان
- ✅ أضف تعليقات واضحة
- ✅ استخدم أسماء وصفية
- ✅ معالجة الأخطاء الشاملة
- ✅ دعم العربية والإنجليزية

**أمثلة:**

```dart
// ✅ صحيح
class ProductScreen extends ConsumerWidget {
  /// شاشة عرض المنتجات
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    
    return products.when(
      data: (data) => const ProductList(),
      loading: () => const VirooLoadingIndicator(),
      error: (error, stack) => ErrorWidgetDisplay(
        message: error.toString(),
      ),
    );
  }
}

// ❌ خطأ
class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // بدون معالجة أخطاء
    // بدون حالات تحميل
    return const Scaffold();
  }
}
```

### 4. Run Tests
```bash
flutter test
```

### 5. Format Code
```bash
dart format lib/
```

### 6. Analyze
```bash
flutter analyze
```

### 7. Commit
```bash
# اتبع Conventional Commits
git commit -m "type: description"

# أنواع الـ commits:
# feat:     ميزة جديدة
# fix:      إصلاح باگ
# docs:     توثيق
# style:    تنسيق الكود
# refactor: إعادة تنظيم
# perf:     تحسين الأداء
# test:     إضافة اختبارات
# ci:       تحسينات CI/CD

# أمثلة:
git commit -m "feat: add product search functionality"
git commit -m "fix: resolve loading state bug in cart"
git commit -m "docs: update error handling guide"
```

### 8. Push
```bash
git push origin feature/your-feature-name
```

### 9. Open Pull Request

**ملء القالب:**

```markdown
## 📝 الوصف

وصف قصير للتغييرات

## 🎯 النوع
- [ ] ✨ ميزة جديدة
- [ ] 🐛 إصلاح باگ
- [ ] 📚 توثيق
- [ ] ♻️ إعادة تنظيم
- [ ] ⚡ تحسين الأداء

## ✅ قائمة التحقق

- [ ] اتبعت معايير الكود
- [ ] أضفت التعليقات
- [ ] اختبرت التغييرات
- [ ] لا توجد مشاكل في التحليل
- [ ] عدّلت التوثيق إن لزم
- [ ] أضفت اختبارات إن أمكن

## 🔗 Links

- يرتبط بـ #issue-number
- يغلق #issue-number
```

---

## 📊 معايير القبول

### كود
- ✅ اتبع معايير الكود
- ✅ بدون أخطاء في التحليل
- ✅ معالجة الأخطاء الشاملة
- ✅ دعم RTL (العربية)
- ✅ اختبارات شاملة
- ✅ توثيق واضح

### PR
- ✅ عنوان واضح
- ✅ وصف مفصل
- ✅ بدون conflicts
- ✅ اجتياز جميع الـ checks
- ✅ موافقة مراجع واحد على الأقل

---

## 🐛 الإبلاغ عن الأخطاء

إذا وجدت خطأ، أرسل issue مع:

```markdown
## 📝 الوصف

وصف واضح للخطأ

## 🔄 خطوات التكرار

1. اذهب إلى...
2. انقر على...
3. شاهد الخطأ

## 🎯 السلوك المتوقع

ماذا يجب أن يحدث

## 🔴 السلوك الفعلي

ماذا يحدث فعلاً

## 📱 البيئة

- Flutter version: 3.x
- Dart version: 3.x
- Platform: Android/iOS
- Device: Model

## 🖼️ لقطات/فيديوهات

أرفق لقطات أو فيديوهات إن أمكن
```

---

## 💡 اقتراح ميزة جديدة

```markdown
## 📝 الوصف

وصف الميزة المطلوبة

## 🎯 المشكلة

ما المشكلة التي تحلها

## 💡 الحل المقترح

كيفية تنفيذ الحل

## 🤔 بدائل

حلول بديلة ممكنة

## 📝 سياق إضافي

معلومات إضافية
```

---

## 🏆 أفضل الممارسات

### Git
```bash
# اسحب آخر التحديثات قبل البدء
git pull origin main

# حافظ على commits صغيرة وواضحة
git commit -m "feat: add feature X"

# اجمع commits قبل المرج
git rebase -i origin/main
```

### الكود
```dart
// 1. استخدم AppException
try {
  // operation
} on AppException catch (e) {
  // handle
}

// 2. استخدم Riverpod
final provider = FutureProvider((ref) async {
  // implementation
});

// 3. معالجة التحميل
ref.read(loadingProvider.notifier).setLoading();

// 4. معالجة الأخطاء
ref.read(errorProvider.notifier).showError(exception);
```

### التوثيق
```dart
/// وصف واضح للدالة/الكلاس
/// 
/// مثال:
/// ```dart
/// final result = await getProducts();
/// ```
Future<List<Product>> getProducts() async {
  // implementation
}
```

---

## 📞 الدعم

- 📧 البريد: oroub.tank@gmail.com
- 🐙 GitHub Issues
- 💬 GitHub Discussions

---

## 📜 الترخيص

بالمساهمة، توافق على أن مساهمتك ستكون تحت رخصة MIT.

---

**شكراً لك على المساهمة! 🙏**
