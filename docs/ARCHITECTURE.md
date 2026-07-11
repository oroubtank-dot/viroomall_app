# 🏗️ دليل البنية والمعمارية

## نظرة عامة

VirooMall يتبع **Clean Architecture** مع **Feature-Based Structure**

---

## 📁 الطبقات الثلاث

### 1️⃣ Presentation Layer (UI)
```
features/products/presentation/
├── screens/         # الشاشات الرئيسية
├── widgets/         # Widgets صغيرة وقابلة لإعادة الاستخدام
└── providers/       # Riverpod providers خاصة بالميزة
```

**المسؤوليات:**
- عرض البيانات
- التقاط تفاعلات المستخدم
- استدعاء business logic عند الحاجة

### 2️⃣ Domain Layer (Business Logic)
```
features/products/domain/
├── models/          # كائنات البيانات
├── repositories/    # Interfaces (عقود)
└── usecases/        # المنطق التجاري (اختياري)
```

**المسؤوليات:**
- تحديد العقود (Interfaces)
- نماذج البيانات النظيفة
- قواعد العمل

### 3️⃣ Data Layer (Repository)
```
features/products/data/
├── models/          # Models مع serialization
├── datasources/     # Firebase, API, Local Storage
└── repositories/    # تطبيق الـ interfaces
```

**المسؤوليات:**
- جلب البيانات من مصادر مختلفة
- تحويل البيانات
- التخزين المحلي

---

## 🔀 تدفق البيانات

```
UI (Screen)
   ↓
Riverpod Provider
   ↓
Service / Repository
   ↓
Firebase / API
   ↓
back to UI
```

---

## 📂 مثال عملي: Products Feature

```
lib/features/products/
├── domain/
│   ├── models/
│   │   └── product_model.dart
│   └── repositories/
│       └── product_repository.dart (Interface)
├── data/
│   ├── models/
│   │   └── product_dto.dart (Data Transfer Object)
│   ├── datasources/
│   │   ├── product_firestore_datasource.dart
│   │   └── product_local_datasource.dart
│   └── repositories/
│       └── product_repository_impl.dart
└── presentation/
    ├── screens/
    │   ├── products_screen.dart
    │   └── product_details_screen.dart
    ├── widgets/
    │   ├── product_card.dart
    │   ├── product_filter.dart
    │   └── product_sort.dart
    └── providers/
        ├── products_provider.dart
        └── product_details_provider.dart
```

---

## 🎯 المبادئ

### 1. Single Responsibility
```dart
// ✅ صحيح - كل class له مسؤولية واحدة
class ProductService {
  Future<List<Product>> getProducts();
}

class ProductRepository {
  final ProductService service;
  // استخدام service
}

// ❌ خطأ - مسؤوليات متعددة
class ProductManager {
  Future<List<Product>> getProducts();
  void showLoading();
  void handleError();
}
```

### 2. Dependency Injection
```dart
// ✅ صحيح
class ProductRepository {
  final ProductService service;
  ProductRepository({required this.service});
}

// ❌ خطأ - creating internally
class ProductRepository {
  final service = ProductService();
}
```

### 3. Abstraction
```dart
// ✅ صحيح - Interface
abstract class ProductRepository {
  Future<List<Product>> getProducts();
}

class ProductRepositoryImpl extends ProductRepository {
  @override
  Future<List<Product>> getProducts() async {
    // implementation
  }
}

// ❌ خطأ - no abstraction
class ProductRepository {
  // direct implementation
}
```

---

## 🔌 Riverpod Integration

```dart
// lib/features/products/presentation/providers/products_provider.dart

final productsProvider = FutureProvider((ref) async {
  // 1. Get service/repository
  final repository = ref.watch(productRepositoryProvider);
  
  // 2. Set loading state
  ref.read(loadingProvider.notifier).setLoading();
  
  try {
    // 3. Fetch data
    final products = await repository.getProducts();
    
    // 4. Set success
    ref.read(loadingProvider.notifier).setSuccess();
    
    return products;
  } catch (e) {
    // 5. Handle error
    ref.read(loadingProvider.notifier).setError();
    ref.read(errorProvider.notifier).showError(e);
    rethrow;
  }
});
```

---

## 🎨 UI Integration

```dart
// lib/features/products/presentation/screens/products_screen.dart

class ProductsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch providers
    final productsAsync = ref.watch(productsProvider);
    final loadingState = ref.watch(loadingProvider);
    
    // 2. Handle states
    return productsAsync.when(
      data: (products) => ProductList(products: products),
      loading: () => const VirooLoadingIndicator(),
      error: (error, stack) => ErrorWidgetDisplay(
        message: error.toString(),
        onRetry: () => ref.refresh(productsProvider),
      ),
    );
  }
}
```

---

## 📚 الملفات الأساسية

### Core Services
- `auth_service.dart` - المصادقة
- `product_service.dart` - المنتجات
- `storage_service.dart` - التخزين المحلي
- `error_handler.dart` - معالجة الأخطاء

### Global Providers
- `loading_provider.dart` - حالات التحميل
- `error_provider.dart` - حالات الأخطاء

### Utilities
- `result_type.dart` - Either Pattern
- `app_exception.dart` - Exception Classes

---

## ✅ قائمة التحقق

- [ ] كل feature في مجلد منفصل
- [ ] Presentation, Domain, Data منفصلة
- [ ] استخدام Interfaces في Domain
- [ ] Dependency Injection مطبق
- [ ] Riverpod providers مركزية
- [ ] Error Handling موحد
- [ ] Loading states متسقة

---

## 📞 الدعم

للأسئلة:
- 📧 oroub.tank@gmail.com
- 🐙 GitHub Issues

