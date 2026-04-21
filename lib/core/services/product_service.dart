import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

/// =============================================
/// خدمة المنتجات - Product Service
/// =============================================
class ProductService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Collection Reference
  static CollectionReference get _productsCollection =>
      _firestore.collection('products');

  // =============================================
  // Stream للمنتجات (حسب النوع)
  // =============================================
  static Stream<List<ProductModel>> getProductsStream({
    String? productType,
    String? categoryId,
    int limit = 20,
  }) {
    Query query = _productsCollection
        .where('status', isEqualTo: 'approved')
        .orderBy('createdAt', descending: true);

    if (productType != null) {
      query = query.where('productType', isEqualTo: productType);
    }

    if (categoryId != null) {
      query = query.where('categoryId', isEqualTo: categoryId);
    }

    if (limit > 0) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    });
  }

  // =============================================
  // الحصول على منتج واحد
  // =============================================
  static Future<ProductModel?> getProduct(String productId) async {
    try {
      final doc = await _productsCollection.doc(productId).get();
      if (doc.exists) {
        return ProductModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // =============================================
  // إضافة منتج جديد
  // =============================================
  static Future<String?> addProduct(ProductModel product) async {
    try {
      final docRef = await _productsCollection.add(product.toFirestore());
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  // =============================================
  // تحديث منتج
  // =============================================
  static Future<bool> updateProduct(ProductModel product) async {
    try {
      await _productsCollection.doc(product.id).update(product.toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }

  // =============================================
  // حذف منتج
  // =============================================
  static Future<bool> deleteProduct(String productId) async {
    try {
      await _productsCollection.doc(productId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  // =============================================
  // زيادة عدد المشاهدات
  // =============================================
  static Future<void> incrementViews(String productId) async {
    try {
      await _productsCollection.doc(productId).update({
        'views': FieldValue.increment(1),
      });
    } catch (e) {
      // تجاهل الخطأ
    }
  }

  // =============================================
  // إضافة للمفضلة
  // =============================================
  static Future<void> toggleFavorite(String productId, bool isFavorite) async {
    try {
      await _productsCollection.doc(productId).update({
        'favorites': FieldValue.increment(isFavorite ? 1 : -1),
      });
    } catch (e) {
      // تجاهل الخطأ
    }
  }

  // =============================================
  // منتجات البائع
  // =============================================
  static Stream<List<ProductModel>> getSellerProducts(String sellerId) {
    return _productsCollection
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    });
  }
}
